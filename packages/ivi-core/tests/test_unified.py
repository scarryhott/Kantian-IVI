from __future__ import annotations

from typing import Any, Mapping

from ivi_core.unified import IVIStep


class DummyForms:
    def lapse(self, *, context: Mapping[str, Any]) -> Mapping[str, Any]:
        return {"weight": context.get("seed", 0)}


def test_ivi_step_composes_in_order():
    def fractal(x: int) -> int:
        return x + 1

    def flow(t: float, x: int) -> int:
        assert t == 0.5
        return x * 2

    def kakeya(x: int, *, weight: Mapping[str, Any]) -> int:
        assert weight["weight"] == 7
        return x - 3

    step = IVIStep(fractal=fractal, flow=flow, kakeya=kakeya, forms=DummyForms())
    result = step(2, t=0.5, context={"seed": 7})
    assert result == (2 + 1) * 2 - 3
