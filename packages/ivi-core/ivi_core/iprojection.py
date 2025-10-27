from .types import IProjection, PhenomenalRecord, Resuperposition, ThicknessField


def measure(
    state: Resuperposition, ip: IProjection, forms: ThicknessField
) -> PhenomenalRecord:
    """Core measurement: appearance from i-projection + constitutive forms."""

    return state.project(ip, forms)
