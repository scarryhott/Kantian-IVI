from dataclasses import dataclass

try:
    from ivi_thickness.model import Params
except ImportError as exc:  # pragma: no cover
    raise ImportError(
        "The ivi_thickness package is required. Install it or vendor Lightmatter."
    ) from exc


@dataclass
class LMParams:
    epsilon_grain: float
    epsilon_flat: float
    E0_eV: float
    kappa0: float
    p: float
    q: float


def to_lm(params: LMParams) -> Params:
    return Params(
        epsilon_grain=params.epsilon_grain,
        epsilon_flat=params.epsilon_flat,
        E0_eV=params.E0_eV,
        kappa0=params.kappa0,
        p=params.p,
        q=params.q,
    )
