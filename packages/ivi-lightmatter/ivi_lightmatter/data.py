from dataclasses import dataclass
from pathlib import Path
from typing import Any

try:
    from ivi_thickness.data import DataHub
except ImportError as exc:  # pragma: no cover
    raise ImportError(
        "The ivi_thickness package is required. Install it or vendor Lightmatter."
    ) from exc


@dataclass
class LightmatterData:
    """Convenience wrapper for Lightmatter datasets."""

    data_dir: Path

    def hub(self) -> DataHub:
        return DataHub(str(self.data_dir))

    def load_all(self) -> dict[str, Any]:
        hub = self.hub()
        return {
            "lens": hub.load_h0licow_like(),
            "clock": hub.load_clock_like(),
            "pulsar": hub.load_nanograv_like(),
        }
