# Lightmatter Integration Guide

This guide explains how to bridge the Lightmatter time-thickness physics model with the Kantian-IVI abstractions. The integration follows a layered design so that the philosophical interfaces (`FormsProvider`, `IProjection`, resuperposition) stay decoupled from concrete physics backends.

## Workspace Layout

```
Kantian-IVI/
├─ packages/
│  ├─ ivi-core/          # Kantian IVI abstractions (philosophy layer)
│  ├─ ivi-lightmatter/   # Adapter that wraps Lightmatter physics
│  ├─ ivi-cli/           # Unified CLI (IVI + Lightmatter)
│  └─ ivi-examples/      # Optional notebooks/configs
├─ lightmatter/          # Lightmatter v1 (ivi_thickness package)
└─ lightmatter2/         # Lightmatter v2 (drop-in replacement, richer outputs)
```

The `packages` workspace keeps reusable Python components in editable sub-packages. Both `lightmatter/` and `lightmatter2/` ship the `ivi_thickness` module; you can work with either by putting the desired folder on `PYTHONPATH` or installing it in editable mode.

## Installation

1. Install the Kantian packages in editable mode:
   ```bash
   pip install -e packages/ivi-core -e packages/ivi-lightmatter -e packages/ivi-cli
   ```

2. Install Lightmatter (`ivi_thickness`). Choose the release you need:
   - v1 (original workflow):
     ```bash
     pip install -e lightmatter
     ```
   - v2 (updated diagnostics & publishing):
     ```bash
     pip install -e lightmatter2
     ```
   - or install from PyPI/another source if available.

When running commands ad-hoc without installation you can rely on `PYTHONPATH`, e.g.:
```bash
PYTHONPATH=packages/ivi-core:packages/ivi-lightmatter:packages/ivi-cli:lightmatter2 python3 -m ivi_cli null-forms
```

## Key Interfaces

| Layer              | Module                                                 | Responsibility                                            |
| ------------------ | ------------------------------------------------------ | ---------------------------------------------------------- |
| Philosophical core | `ivi_core.types`, `ivi_core.forms`, `ivi_core.iprojection` | Defines `ThicknessField`, `FormsProvider`, and measurement |
| Physics adapter    | `ivi_lightmatter.adapter`, `ivi_lightmatter.models`    | Converts Lightmatter params/context into IVI forms         |
| Inference helpers  | `ivi_lightmatter.inference`, `ivi_lightmatter.data`    | Wrap WLS/MCMC fits and data access                         |
| Publishing         | `ivi_lightmatter.publish`                              | Emits human-readable narratives for IVI logs               |
| CLI                | `ivi_cli.__main__`                                     | Entry point for running fits or toy measurements           |

## CLI Quickstart

After installation:

```bash
# run full Lightmatter fits and capture summary JSON
python3 -m ivi_cli run --data-dir ./lightmatter/time_thickness_data

# generate a toy IVI measurement that consumes Lightmatter lapse data
python3 -m ivi_cli measure --T 300 --kappa 1e20 --phi_c2 0.0

# sanity-check the philosophical layer without physics
python3 -m ivi_cli null-forms
```

The CLI surfaces JSON so downstream tooling (Lean scripts, notebooks, dashboards) can ingest phenomena records without importing Python internals.

## Tests

Each package contains light pytest coverage:

```bash
pytest packages/ivi-core/tests
pytest packages/ivi-lightmatter/tests
```

The Lightmatter adapter tests auto-skip when `ivi_thickness` is unavailable so CI can run even without the physics dependency.

## Migration / PR Checklist

Use this checklist when upstreaming changes:

- [ ] Vendor or install the `lightmatter/` repo (`ivi_thickness` import path resolvable).
- [ ] (Optional) Prefer the newer `lightmatter2/` drop-in package if you want the latest diagnostics (`PYTHONPATH` now includes both).
- [ ] `pip install -e packages/ivi-core -e packages/ivi-lightmatter -e packages/ivi-cli`.
- [ ] Run `pytest packages/ivi-core/tests packages/ivi-lightmatter/tests`.
- [ ] Run `python3 -m ivi_cli run --data-dir ./lightmatter/time_thickness_data` (smoke).
- [ ] Run `python3 -m ivi_cli measure --T 300 --kappa 1e20 --phi_c2 0.0`.
- [ ] Update documentation (`README.md`, session logs) with any new narratives or figures.
- [ ] Attach generated narratives/plots via `ivi_lightmatter.publish` if relevant.

## Extending Beyond Lightmatter

The `FormsProvider` protocol allows alternate physics backends to plug in. Create a new package that implements `FormsProvider.lapse`, return `ThicknessField`, and wire it into the CLI or other orchestration code. Lightmatter stays a reference implementation rather than a hard dependency of IVI philosophy.
