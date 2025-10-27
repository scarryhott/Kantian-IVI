#!/usr/bin/env python3

import argparse
import json
from dataclasses import asdict
from typing import Any

import numpy as np

from ivi_core.forms import NullForms
from ivi_core.iprojection import measure
from ivi_core.types import IProjection, PhenomenalRecord, ThicknessField

try:
    from ivi_lightmatter.adapter import LightmatterForms
    from ivi_lightmatter.models import LMParams
    from ivi_lightmatter.inference import run_wls
    from ivi_thickness.model import Params as LMRawParams
except ImportError:
    LightmatterForms = None
    LMParams = None
    run_wls = None
    LMRawParams = None


def _ensure_lightmatter() -> None:
    if None in (LightmatterForms, LMParams, run_wls, LMRawParams):
        raise SystemExit(
            "Lightmatter dependencies not available. Install ivi_thickness and "
            "the Lightmatter package."
        )


def _normalize_beta(beta: Any) -> list[float]:
    if hasattr(beta, "tolist"):
        return list(beta.tolist())
    if isinstance(beta, (list, tuple)):
        return list(beta)
    return [float(beta)]


def _demo_measure(forms: ThicknessField) -> PhenomenalRecord:
    class TrivialState:
        def project(
            self, ip: IProjection, thickness: ThicknessField
        ) -> PhenomenalRecord:
            determinacy = float(np.mean(thickness.lapse_W))
            return PhenomenalRecord(
                outcome={"determinacy": determinacy, "index": dict(ip.index)},
                evidence={"forms": thickness.meta},
            )

    return measure(TrivialState(), IProjection(index={"agent": "demo"}), forms)


def main() -> None:
    parser = argparse.ArgumentParser("ivi")
    sub = parser.add_subparsers(dest="cmd")

    p_run = sub.add_parser("run", help="Run Lightmatter WLS and emit IVI narrative")
    p_run.add_argument("--eps-grain", type=float, default=1e-18)
    p_run.add_argument("--eps-flat", type=float, default=-1e-19)
    p_run.add_argument("--E0-eV", type=float, default=10.0)
    p_run.add_argument("--kappa0", type=float, default=1e20)
    p_run.add_argument("--p", type=float, default=1.0)
    p_run.add_argument("--q", type=float, default=1.0)
    p_run.add_argument("--data-dir", type=str, default="./time_thickness_data")

    p_meas = sub.add_parser("measure", help="Perform an IVI measurement (i-projection)")
    p_meas.add_argument("--T", type=float, required=True, help="Temperature (K)")
    p_meas.add_argument("--kappa", type=float, required=True)
    p_meas.add_argument("--phi_c2", type=float, default=0.0)
    p_meas.add_argument("--eps-grain", type=float, default=1e-18)
    p_meas.add_argument("--eps-flat", type=float, default=-1e-19)
    p_meas.add_argument("--E0-eV", type=float, default=10.0)
    p_meas.add_argument("--kappa0", type=float, default=1e20)
    p_meas.add_argument("--p", type=float, default=1.0)
    p_meas.add_argument("--q", type=float, default=1.0)

    sub.add_parser("null-forms", help="Demonstrate NullForms measurement")

    args = parser.parse_args()

    if args.cmd == "run":
        _ensure_lightmatter()
        params = LMRawParams(
            args.eps_grain, args.eps_flat, args.E0_eV, args.kappa0, args.p, args.q
        )
        fits = run_wls(params, args.data_dir)
        out = {
            "lens": {
                "beta": _normalize_beta(fits.lens.beta),
                "chi2": float(fits.lens.chi2),
                "dof": int(fits.lens.dof),
            },
            "clock": {
                "beta": _normalize_beta(fits.clock.beta),
                "chi2": float(fits.clock.chi2),
                "dof": int(fits.clock.dof),
            },
            "pulsar": {
                "beta": _normalize_beta(fits.pulsar.beta),
                "chi2": float(fits.pulsar.chi2),
                "dof": int(fits.pulsar.dof),
            },
            "combined": {
                "chi2": float(fits.combined.chi2_total),
                "dof": int(fits.combined.dof_total),
            },
        }
        print(json.dumps(out, indent=2))
        return

    if args.cmd == "measure":
        _ensure_lightmatter()
        lm_forms = LightmatterForms(
            LMParams(
                args.eps_grain,
                args.eps_flat,
                args.E0_eV,
                args.kappa0,
                args.p,
                args.q,
            )
        )
        forms = lm_forms.lapse(
            context={
                "Phi_over_c2": args.phi_c2,
                "kappa": args.kappa,
                "T_K": args.T,
            }
        )
        record = _demo_measure(forms)
        print(json.dumps(asdict(record), indent=2))
        return

    if args.cmd == "null-forms":
        forms = NullForms().lapse(context={})
        record = _demo_measure(forms)
        print(json.dumps(asdict(record), indent=2))
        return

    parser.print_help()


if __name__ == "__main__":
    main()
