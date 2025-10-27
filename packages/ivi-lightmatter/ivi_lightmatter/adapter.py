from dataclasses import dataclass
from typing import Any, Mapping

import numpy as np

from ivi_core.types import FormsProvider, ThicknessField

from .models import LMParams, to_lm

try:
    from ivi_thickness.model import lapse_W as lm_lapse_W
except ImportError as exc:  # pragma: no cover
    raise ImportError(
        "The ivi_thickness package is required. Install it or vendor Lightmatter."
    ) from exc


@dataclass
class LightmatterForms(FormsProvider):
    """Concrete FormsProvider backed by the Lightmatter lapse model."""

    params: LMParams

    def lapse(self, *, context: Mapping[str, Any]) -> ThicknessField:
        Phi_over_c2 = np.asarray(context.get("Phi_over_c2", 0.0), float)
        kappa = np.asarray(context["kappa"], float)
        T_K = np.asarray(context["T_K"], float)

        raw_params = to_lm(self.params)
        W = lm_lapse_W(Phi_over_c2, kappa, T_K, raw_params)
        meta = {
            "source": "lightmatter/ivi_thickness",
            "eps_grain": self.params.epsilon_grain,
            "eps_flat": self.params.epsilon_flat,
            "units": {"W": "dimensionless", "Phi_over_c2": "dimensionless", "T_K": "K"},
        }
        return ThicknessField(lapse_W=W, meta=meta)
