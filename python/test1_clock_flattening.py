"""
IVI Test #1 (Local): Heat-driven flattening in optical clocks
Model: r_k = 0.5 * eps_flat * (G(T1_k) - G(T2_k)) + noise
Run: python test1_clock_flattening.py data.csv --q 1 --T0 300
CSV columns: time, r, T1, T2, w (optional)
"""
import argparse, numpy as np, pandas as pd

def fit_eps_flat(r, T1, T2, q=1.0, T0=300.0, w=None):
    G1 = (T1 / T0)**q
    G2 = (T2 / T0)**q
    x  = 0.5 * (G1 - G2)
    if w is None:
        denom = np.dot(x, x)
        eps = np.dot(x, r) / denom
        resid = r - eps * x
        dof = max(1, len(r)-1)
        s2  = np.dot(resid, resid) / dof
        var = s2 / denom
    else:
        W = np.diag(w)
        denom = x @ W @ x
        eps = (x @ W @ r) / denom
        resid = r - eps * x
        dof = max(1, len(r)-1)
        s2  = (resid @ W @ resid) / dof
        var = s2 / denom
    se = np.sqrt(var)
    return eps, se

if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("csv", help="data csv with columns: time,r,T1,T2[,w]")
    ap.add_argument("--q", type=float, default=1.0)
    ap.add_argument("--T0", type=float, default=300.0)
    args = ap.parse_args()

    df = pd.read_csv(args.csv)
    r  = df["r"].to_numpy()
    T1 = df["T1"].to_numpy()
    T2 = df["T2"].to_numpy()
    w  = df["w"].to_numpy() if "w" in df.columns else None
    eps, se = fit_eps_flat(r, T1, T2, q=args.q, T0=args.T0, w=w)
    print(f"eps_flat_hat = {eps:.3e} ± {1.96*se:.3e} (95% CI)")
