import numpy as np
import pytest

pytest.importorskip("ivi_thickness")

from ivi_lightmatter.adapter import LightmatterForms
from ivi_lightmatter.models import LMParams


def test_lightmatter_lapse_signs():
    forms = LightmatterForms(LMParams(1e-18, -1e-19, 10.0, 1e20, 1.0, 1.0))
    out = forms.lapse(
        context={"Phi_over_c2": 0.0, "kappa": 1e20, "T_K": 300.0}
    )
    assert np.isfinite(out.lapse_W).all()
