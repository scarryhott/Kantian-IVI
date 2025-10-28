import numpy as np
import pytest

pytest.importorskip("ivi_thickness")

from ivi_lightmatter.invariants import assert_invariants, compute_invariants
from ivi_lightmatter.models import LMParams


def test_compute_invariants_defaults():
    report = compute_invariants(
        LMParams(
            epsilon_grain=1e-18,
            epsilon_flat=-1e-19,
            E0_eV=10.0,
            kappa0=1e20,
            p=1.0,
            q=1.0,
        )
    )
    data = report.as_dict()

    assert data["spacetime_max_error"] <= 1e-12
    assert data["sheet_delta_max"] <= 1e-12
    assert data["lapse_all_positive"] is True
    assert data["lapse_min"] > 0.0
    assert data["i_of_t_finite"] is True
    # Should not raise
    assert_invariants(report)


def test_assert_invariants_failure():
    from ivi_lightmatter.invariants import InvariantReport

    report = InvariantReport(
        spacetime_max_error=1e-3,
        sheet_delta_max=1e-4,
        lapse_min=-0.1,
        lapse_all_positive=False,
        i_of_t_finite=False,
    )
    with pytest.raises(ValueError) as exc:
        assert_invariants(report, spacetime_tol=1e-5, sheet_tol=1e-5, min_lapse=0.0)
    msg = str(exc.value)
    assert "spacetime_max_error" in msg
    assert "sheet_delta_max" in msg
    assert "lapse positivity" in msg
    assert "i_of_t" in msg
