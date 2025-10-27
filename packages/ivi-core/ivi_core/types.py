from dataclasses import dataclass
from typing import Any, Mapping, Optional, Protocol

import numpy as np

Float = float
Array = np.ndarray


@dataclass
class ThicknessField:
    """Constitutive field(s) that make phenomena determinate for a local perspective."""

    lapse_W: Array
    meta: Mapping[str, Any]


class FormsProvider(Protocol):
    def lapse(self, *, context: Mapping[str, Any]) -> ThicknessField:
        ...


@dataclass
class IProjection:
    """Local indexical 'cut' into resuperposition (the measurement as appearance)."""

    index: Mapping[str, Any]


class NoumenalState(Protocol):
    """Abstract 'unitary' state; IVI does not require a concrete representation."""

    ...


@dataclass
class PhenomenalRecord:
    """A determinate outcome in the space of appearances."""

    outcome: Mapping[str, Any]
    evidence: Mapping[str, Any]


class Resuperposition(Protocol):
    """Keeps unitary dynamics; supports local i-projections."""

    def project(self, ip: IProjection, forms: ThicknessField) -> PhenomenalRecord:
        ...
