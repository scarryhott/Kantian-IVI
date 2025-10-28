from __future__ import annotations

from dataclasses import dataclass
from typing import Sequence

import numpy as np

from .models import LMParams, to_lm

try:
    from ivi_thickness.model import (
        i_of_t,
        lapse_W,
        sheet_delta,
        t_local_from_sheet,
    )
except ImportError as exc:  # pragma: no cover
    raise ImportError(
        "The ivi_thickness package is required. Install it or vendor Lightmatter."
    ) from exc


@dataclass
class InvariantReport:
    spacetime_max_error: float
    sheet_delta_max: float
    lapse_min: float
    lapse_all_positive: bool
    i_of_t_finite: bool

    def as_dict(self) -> dict[str, float | bool]:
        return {
            "spacetime_max_error": self.spacetime_max_error,
            "sheet_delta_max": self.sheet_delta_max,
            "lapse_min": self.lapse_min,
            "lapse_all_positive": self.lapse_all_positive,
            "i_of_t_finite": self.i_of_t_finite,
        }

    def check(
        self,
        *,
        spacetime_tol: float = 1e-6,
        sheet_tol: float = 1e-6,
        min_lapse: float = 0.0,
    ) -> None:
        assert_invariants(
            self,
            spacetime_tol=spacetime_tol,
            sheet_tol=sheet_tol,
            min_lapse=min_lapse,
        )


def compute_invariants(
    params: LMParams,
    *,
    lambda_samples: Sequence[float] | None = None,
    m_samples: Sequence[float] | None = None,
    ell_samples: Sequence[float] | None = None,
    kappa_samples: Sequence[float] | None = None,
    temp_samples: Sequence[float] | None = None,
    phi_over_c2: float = 0.0,
) -> InvariantReport:
    """
    Evaluate core IVI invariants for diagnostics:

    1. Spacetime duality: λ · (1/λ) ≈ 1
    2. Kakeya sheet closure: δ = 0 when j = m·ℓ² / t²
    3. Lapse positivity: W > 0 for representative contexts
    4. Log-time map finiteness: i(t) produces finite values on-sheet
    """

    lam = np.asarray(lambda_samples if lambda_samples is not None else (0.25, 0.5, 1.0, 2.0), float)
    spacetime_max_error = float(np.max(np.abs(lam * (1.0 / lam) - 1.0)))

    m_vals = np.asarray(m_samples if m_samples is not None else (0.5, 1.0, 2.0), float)
    ell_vals = np.asarray(ell_samples if ell_samples is not None else (0.1, 0.2, 0.4), float)
    m_grid, ell_grid = np.meshgrid(m_vals, ell_vals, indexing="ij")
    t_vals = t_local_from_sheet(m_grid, ell_grid)
    t_safe = np.clip(t_vals, 1e-9, None)
    j_vals = m_grid * (ell_grid**2) / (t_safe**2)
    sheet_delta_max = float(np.max(np.abs(sheet_delta(j_vals, ell_grid))))

    kappa_vals = np.asarray(
        kappa_samples if kappa_samples is not None else np.linspace(0.0, params.kappa0, 5),
        float,
    )
    temp_vals = np.asarray(
        temp_samples if temp_samples is not None else np.linspace(10.0, 300.0, 5), float
    )
    phi = np.full_like(kappa_vals, float(phi_over_c2))
    lapse = lapse_W(phi, kappa_vals, temp_vals, to_lm(params))
    lapse_min = float(np.min(lapse))
    lapse_all_positive = bool(np.all(lapse > 0.0))

    i_vals = i_of_t(m_grid, np.abs(t_safe))
    i_of_t_finite = bool(np.isfinite(i_vals).all())

    return InvariantReport(
        spacetime_max_error=spacetime_max_error,
        sheet_delta_max=sheet_delta_max,
        lapse_min=lapse_min,
        lapse_all_positive=lapse_all_positive,
        i_of_t_finite=i_of_t_finite,
    )


def assert_invariants(
    report: InvariantReport,
    *,
    spacetime_tol: float = 1e-6,
    sheet_tol: float = 1e-6,
    min_lapse: float = 0.0,
) -> None:
    """
    Raise ValueError if the invariant report violates the supplied thresholds.
    """

    failures: list[str] = []
    if report.spacetime_max_error > spacetime_tol:
        failures.append(
            f"spacetime_max_error={report.spacetime_max_error:.3e} exceeds tolerance {spacetime_tol:.3e}"
        )
    if report.sheet_delta_max > sheet_tol:
        failures.append(
            f"sheet_delta_max={report.sheet_delta_max:.3e} exceeds tolerance {sheet_tol:.3e}"
        )
    if not report.lapse_all_positive or report.lapse_min < min_lapse:
        failures.append(
            f"lapse positivity violated (min={report.lapse_min:.3e}, required>{min_lapse:.3e})"
        )
    if not report.i_of_t_finite:
        failures.append("i_of_t produced non-finite values on the sheet")

    if failures:
        raise ValueError("Invariant checks failed: " + "; ".join(failures))
