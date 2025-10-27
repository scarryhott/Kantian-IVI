from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Callable, Generic, Iterable, Mapping, Protocol, Sequence, TypeVar

S = TypeVar("S")


class Fractal(Protocol[S]):
    """Fractal expansion operator."""

    def __call__(self, state: S) -> S: ...


class QuaternionFlow(Protocol[S]):
    """Quaternion (symmetry) flow."""

    def __call__(self, t: float, state: S) -> S: ...


class Kakeya(Protocol[S]):
    """Kakeya coherence projection."""

    def __call__(self, state: S, *, weight: Mapping[str, Any]) -> S: ...


class FormsProvider(Protocol):
    """Minimal Lightmatter-style interface."""

    def lapse(self, *, context: Mapping[str, Any]) -> Mapping[str, Any]: ...


@dataclass(slots=True)
class IVIStep(Generic[S]):
    fractal: Fractal[S]
    flow: QuaternionFlow[S]
    kakeya: Kakeya[S]
    forms: FormsProvider | None = None

    def __call__(self, state: S, *, t: float, context: Mapping[str, Any]) -> S:
        expanded = self.fractal(state)
        guided = self.flow(t, expanded)
        weight = self.forms.lapse(context=context) if self.forms else context
        return self.kakeya(guided, weight=weight)


def ivi_run(
    step: IVIStep[S],
    initial: S,
    times: Iterable[float],
    *,
    context_factory: Callable[[S, float], Mapping[str, Any]] | None = None,
) -> S:
    """Iterate the discrete IVI evolution."""

    state = initial
    for t in times:
        ctx = context_factory(state, t) if context_factory else {}
        state = step(state, t=t, context=ctx)
    return state


class VectorField(Protocol[S]):
    """RHS for the continuous IVI equation."""

    def __call__(self, t: float, state: S) -> S: ...


class Gradient(Protocol[S]):
    """Gradient of the Kakeya potential."""

    def __call__(self, state: S) -> S: ...


@dataclass(slots=True)
class IVIODE(Generic[S]):
    growth: VectorField[S]
    flattening: Gradient[S]
    lam: float

    def rhs(self, t: float, state: S) -> tuple[S, tuple[float, S]]:
        """Return (growth, flattening) so callers can assemble the ODE."""

        return self.growth(t, state), (self.lam, self.flattening(state))
