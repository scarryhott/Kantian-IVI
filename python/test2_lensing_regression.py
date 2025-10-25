"""
IVI Test #2 (Cosmic): Lensing delay residuals vs radiation (flattening) and grain proxy (thickening)

Input CSV columns (one row per lens or per image-pair):
  lens_id,z_lens,z_src,delta_t_obs_days,delta_t_model_days,sigma_days,
  rad_intensity,kappa_proxy,shear_proxy

Run:
  python test2_lensing_regression.py lens_residuals.csv
"""
import argparse, numpy as np, pandas as pd

def weighted_ols(X, y, w):
    W = np.diag(w)
    XT_W = X.T @ W
    XT_W_X = XT_W @ X
    XT_W_y = XT_W @ y
    beta = np.linalg.solve(XT_W_X, XT_W_y)
    yhat = X @ beta
    res = y - yhat
    dof = max(1, len(y) - X.shape[1])
    sigma2 = (res.T @ W @ res) / dof
    cov = np.linalg.inv(XT_W_X) * sigma2
    se = np.sqrt(np.diag(cov))
    return beta, se

if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("csv", help="lens_residuals.csv")
    args = ap.parse_args()
    df = pd.read_csv(args.csv).dropna(subset=[
        "delta_t_obs_days","delta_t_model_days","sigma_days",
        "rad_intensity","kappa_proxy","shear_proxy"
    ])
    resid = (df["delta_t_obs_days"] - df["delta_t_model_days"]) / df["delta_t_model_days"]
    frac_sigma = df["sigma_days"] / df["delta_t_model_days"]
    w = 1.0 / np.clip(frac_sigma.values**2, 1e-12, None)
    X = np.column_stack([
        np.ones(len(df)),
        df["rad_intensity"].values,
        df["kappa_proxy"].values,
        df["shear_proxy"].values
    ])
    y = resid.values
    beta, se = weighted_ols(X, y, w)
    names = ["a (intercept)","b (radiation)","c (grain)","d (shear)"]
    for n, b, s in zip(names, beta, se):
        print(f"{n:15s} = {b:+.4e} ± {1.96*s:.4e}  (95% CI)")
