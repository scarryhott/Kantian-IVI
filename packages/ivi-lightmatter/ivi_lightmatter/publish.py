from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

from .inference import ChannelFits


@dataclass
class Narrative:
    """Textual artifact that IVI can weave into philosophical narratives."""

    title: str
    body: str


def render_summary(fits: ChannelFits) -> Narrative:
    """Produce a lightweight textual summary of Lightmatter fits."""

    body = "\n".join(
        [
            f"Lensing χ²/dof: {fits.lens.chi2:.3f}/{fits.lens.dof}",
            f"Clock χ²/dof: {fits.clock.chi2:.3f}/{fits.clock.dof}",
            f"Pulsar χ²/dof: {fits.pulsar.chi2:.3f}/{fits.pulsar.dof}",
            f"Combined χ²/dof: {fits.combined.chi2_total:.3f}/{fits.combined.dof_total}",
        ]
    )
    return Narrative(title="Lightmatter Fit Summary", body=body)


def save_summary(fits: ChannelFits, path: Path) -> Path:
    """Serialize the narrative summary to disk."""

    narrative = render_summary(fits)
    path.write_text(f"# {narrative.title}\n\n{narrative.body}\n", encoding="utf-8")
    return path
