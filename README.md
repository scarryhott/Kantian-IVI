# IVI — Intangibly Verified Information (Lean 4 stubs)

Minimal Lean 4 axiomatization of IVI “from pure reason,” mirroring Kant’s transcendental structure.

## Build

```bash
lake build
```

## Run demo

```bash
lake exe ivi-demo
```

### Layout

- `IVI/Core.lean` — primitives (Categories, Modality, SVO, Schema)
- `IVI/Pure.lean` — pure reason axioms A1–A12
- `IVI/Logic.lean` — reusable `lawful`, `compatible`, and `harmonize`
- `IVI/Operators.lean` — IVI operations (VWM, Encode, Resuperpose, Rotate)
- `IVI/Domain.lean` — domain specializations (math, physics, ethics, aesthetics, law)
- `IVI/System.lean` — system unity and closure checks
- `IVI/C3Model.lean` — mathlib-free ℂ³ placeholder scaffold
- `IVI/Intangible.lean` — intangible verification (Δi translation, fractal iteration)
- `IVI/Invariant.lean` — spectral invariant + convergence runner
- `IVI/FixedPoint.lean` — fixed-point predicate and runner (loop closure, scale agreement)
- `IVI/Theorems.lean` — named theorem stubs (T1–T5)
- `IVI/Proofs.lean` — proven lemmas (symmetry, harmonize/Resuperpose singletons, closure helper)
- `IVI/Demo.lean` — tiny demo wiring pieces together

## What's new in this enhancement pack

- Strengthened recognition logic in `IVI/Logic.lean` (`lawful`, `compatible`, `harmonize`).
- Bridged `VWM` with `compatible` and added `closed_sublist` in `IVI/Operators.lean`.
- Introduced theorem placeholders in `IVI/Theorems.lean` for future proof work.
- Added `IVI/C3Model.lean`, a mathlib-free ℂ³ resonance scaffold.

## Enhancement Pack 2

- `IVI/Proofs.lean` delivers `VWM_symm`, `compatible_iff_VWM`, `harmonize_singleton`,
  `Resuperpose_singleton`, and `closedUnderIVI_cons` with full proofs.
- `IVI/Logic.lean` exposes `compatible_refl_on` when you can supply a reflexive closure.
- `IVI/System.lean` adds `harmonizeIfClosed` so any closed list yields a harmonized witness.
- `IVI/Demo.lean` exercises the new results without printing raw propositions.
- `IVI/Intangible.lean` formalises the Δi = k · |r⃗| · θ rule and recursive domain interactions.
- `IVI/Invariant.lean` adds resonance matrices + power iteration to detect convergence invariantly.
- `IVI/FixedPoint.lean` captures the fixed-point predicate (λ, loop closure, scale agreement) with a runner.

Everything still builds cleanly:

```bash
lake build && lake exe ivi-demo
```

## Where to go next

1. Replace the axioms in `IVI/Theorems.lean` with genuine proofs.
2. Enrich `Recognition.sound` and domain rules with domain-specific laws.
3. Swap `IVI/C3Model.lean` for a full complex-vector backend when ready.
4. Use the new lemmas as scaffolding for stronger domain logics or topology upgrades.
# Kantian-IVI
# Kantian-IVI
