from dataclasses import dataclass
from typing import Callable

from .types import IProjection, PhenomenalRecord, Resuperposition, ThicknessField


@dataclass
class CallableResuperposition:
    """Adapter that turns a callable into a Resuperposition implementation."""

    projector: Callable[[IProjection, ThicknessField], PhenomenalRecord]

    def project(self, ip: IProjection, forms: ThicknessField) -> PhenomenalRecord:
        return self.projector(ip, forms)
