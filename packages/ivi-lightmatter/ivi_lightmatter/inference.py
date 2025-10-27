from dataclasses import dataclass
from typing import Any

try:
    from ivi_thickness.fit import (
        combined_assessment,
        fit_clock_channel,
        fit_lensing_channel,
        fit_pulsar_channel,
    )
    from ivi_thickness.data import DataHub
    from ivi_thickness.model import Params
except ImportError as exc:  # pragma: no cover
    raise ImportError(
        "The ivi_thickness package is required. Install it or vendor Lightmatter."
    ) from exc


@dataclass
class ChannelFits:
    lens: Any
    clock: Any
    pulsar: Any
    combined: Any


def run_wls(params: Params, data_dir: str = "./time_thickness_data") -> ChannelFits:
    hub = DataHub(data_dir)
    df_lens = hub.load_h0licow_like()
    df_clock = hub.load_clock_like()
    df_psr = hub.load_nanograv_like()

    lens = fit_lensing_channel(df_lens, params, hub)
    clock = fit_clock_channel(df_clock, params)
    puls = fit_pulsar_channel(df_psr, params, hub)
    comb = combined_assessment(lens, clock, puls)
    return ChannelFits(lens, clock, puls, comb)
