# Experiments

**Test #1 — Local heat flattening (lab).**
Compare identical optical clocks at 300 K vs 77 K after standard BBR corrections.
Model:


r_k = (Δν/ν)_resid ≈ (1/2) ε_flat (G(T1_k) − G(T2_k)) + η_k.

Estimate `ε_flat` via (W)LS/GLS on time series.

**Test #2 — Lensing regression (cosmology).**
For each lens (or image pair), form


residual = (Δt_obs − Δt_GR)/Δt_GR.

Regress:


residual ~ a + b · (LOS radiation) + c · (κ_proxy) + d · (shear_proxy).

IVI expects `b<0` (heat flattening), `c>0` (grain thickening).
