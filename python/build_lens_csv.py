"""
IVI Lens CSV Builder
- Reads a manifest.yaml with lenses + URLs (PDF/HTML)
- Downloads documents and attempts to extract time-delay tables
- Writes lens_residuals.csv with observed/model delays (covariates left blank)

Install:
  pip install requests pandas pyyaml pdfplumber lxml html5lib

Run:
  python build_lens_csv.py --manifest manifest.yaml --out lens_residuals.csv
"""
import os, re, sys, argparse, requests, pandas as pd
try:
    import pdfplumber
except Exception:
    pdfplumber = None
import yaml

def safe_filename(s): return re.sub(r'[^A-Za-z0-9._-]+', '_', s)[:120]

def download(url, dest):
    r = requests.get(url, headers={"User-Agent":"IVI-Lens/1.0"}, timeout=60)
    r.raise_for_status()
    with open(dest, "wb") as f: f.write(r.content)
    return dest

def extract_tables_from_pdf(p):
    if pdfplumber is None: return []
    out=[]
    with pdfplumber.open(p) as pdf:
        for pg in pdf.pages:
            try: tbls = pg.extract_tables()
            except: tbls = []
            for t in tbls:
                w=max(len(r) for r in t) if t else 0
                t=[r+[None]*(w-len(r)) for r in t]
                out.append(pd.DataFrame(t))
    return out

def extract_tables_from_html(url):
    try: return pd.read_html(url)
    except: return []

def looks_like_delay_table(df):
    txt=" ".join(map(str, df.fillna("").values.flatten())).lower()
    hits=sum(k in txt for k in ["delay","time delay","days","day","delta t","time-delay"])
    return hits>=2

def parse_delay_table(df):
    out=[]; d=df.copy()
    d.columns=[str(c).strip().lower() for c in d.columns]
    def pick(val):
        try: return float(str(val).replace("±"," ").split()[0])
        except: return None
    col_obs=next((c for c in d.columns if "delay" in c and ("obs" in c or "meas" in c)), None)
    col_mod=next((c for c in d.columns if "delay" in c and ("model" in c or "pred" in c or "gr" in c)), None)
    col_sig=next((c for c in d.columns if any(k in c for k in ["sigma","uncert","error","err"])), None)
    for _,row in d.iterrows():
        obs=pick(row.get(col_obs)) if col_obs in d.columns else None
        mod=pick(row.get(col_mod)) if col_mod in d.columns else None
        sig=pick(row.get(col_sig)) if col_sig in d.columns else None
        rowtxt=" ".join(map(str,row.values)).lower()
        if obs is None and ("day" in rowtxt or "days" in rowtxt):
            m=re.search(r'([0-9]+\.[0-9]+|[0-9]+)\s*(?:±|\+/-)?\s*([0-9]*\.?[0-9]+)?\s*(?:d|day|days)', rowtxt)
            if m:
                obs=float(m.group(1))
                if m.group(2): sig=float(m.group(2))
        if any(v is not None for v in [obs, mod, sig]):
            out.append({"delta_t_obs_days":obs,"delta_t_model_days":mod,"sigma_days":sig})
    return out

def best_effort(url, cache):
    fn=safe_filename(url); path=os.path.join(cache, fn)
    if fn.lower().endswith(".pdf"):
        download(url, path); tables=extract_tables_from_pdf(path)
    else:
        tables=extract_tables_from_html(url)
        if not tables:
            try: download(url, path+".pdf"); tables=extract_tables_from_pdf(path+".pdf")
            except: tables=[]
    cand=[]
    for df in tables:
        df0=df.copy()
        if len(df0)>0:
            row0=[str(x).lower() for x in df0.iloc[0].tolist()]
            if any(any(k in cell for k in ["delay","time","days","delta","σ","sigma"]) for cell in row0):
                df0.columns=row0; df0=df0.iloc[1:].reset_index(drop=True)
        if looks_like_delay_table(df0):
            cand+=parse_delay_table(df0)
    return cand

if __name__=="__main__":
    ap=argparse.ArgumentParser()
    ap.add_argument("--manifest", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--cache", default="cache_docs")
    args=ap.parse_args()
    os.makedirs(args.cache, exist_ok=True)
    man=yaml.safe_load(open(args.manifest,"r",encoding="utf-8"))
    rows=[]
    for it in man.get("lenses",[]):
        lens, zl, zs = it.get("lens_id"), it.get("z_lens"), it.get("z_src")
        ex=[]
        for u in it.get("urls",[]):
            try: ex+=best_effort(u, args.cache)
            except Exception as e: print(f"[warn] {lens}: {u}: {e}", file=sys.stderr)
        if not ex:
            rows.append({"lens_id":lens,"z_lens":zl,"z_src":zs,
                         "delta_t_obs_days":"","delta_t_model_days":"","sigma_days":"",
                         "rad_intensity":"","kappa_proxy":"","shear_proxy":""})
        else:
            seen=set()
            for c in ex:
                key=(c.get("delta_t_obs_days"),c.get("delta_t_model_days"),c.get("sigma_days"))
                if key in seen: continue
                seen.add(key)
                rows.append({"lens_id":lens,"z_lens":zl,"z_src":zs,
                             "delta_t_obs_days":c.get("delta_t_obs_days",""),
                             "delta_t_model_days":c.get("delta_t_model_days",""),
                             "sigma_days":c.get("sigma_days",""),
                             "rad_intensity":"","kappa_proxy":"","shear_proxy":""})
    df=pd.DataFrame(rows, columns=[
        "lens_id","z_lens","z_src","delta_t_obs_days","delta_t_model_days","sigma_days",
        "rad_intensity","kappa_proxy","shear_proxy"
    ])
    df.to_csv(args.out, index=False)
    print(f"[OK] wrote {args.out} with {len(df)} rows.")
