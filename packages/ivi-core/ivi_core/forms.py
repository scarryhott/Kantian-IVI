from typing import Any, Mapping

import numpy as np

from .types import FormsProvider, ThicknessField


class NullForms(FormsProvider):
    """Fallback provider: zero deformation to the lapse."""

    def lapse(self, *, context: Mapping[str, Any]) -> ThicknessField:
        return ThicknessField(lapse_W=np.ones(1), meta={"model": "null"})
