# Next Session Plan — Power Iteration Kickoff

**Date**: October 15, 2025  
**Objective**: Set up the infrastructure needed to prove `powerIter_converges` in `IVI/RealSpecMathlib.lean`.

---

## Session Goals

1. Review existing mathlib lemmas on eigenvalues/eigenvectors for real symmetric matrices.
2. Define the normalized power iteration map in Lean (`iterate (normalize (M · ·))`).
3. Identify and record any missing helper lemmas (add to `LEMMAS_NEEDED.md`).

---

## Pre-Session Checklist

- [ ] Skim `IVI/RealSpecMathlib.lean` to locate the current power-iteration axioms.
- [ ] Collect references (textbook or mathlib docs) outlining the standard proof.
- [ ] Prepare scratch files (`explore_opnorm_bound.lean`, etc.) for experiments.

Helpful commands:
```bash
# Search for existing power iteration references
rg "powerIter" -n IVI
# Build the project
lake build
```

---

## Step-by-Step Outline

### 1. Survey Mathlib (30 min)
- Search for lemmas involving `Eigenvalues`, `OrthonormalBasis`, and `Matrix.mulVec`.
- Note any convenient tools for working in the eigenbasis of a Hermitian matrix.

### 2. Define Iteration (45 min)
- Formalize `powerIterStep M v := normalize (Matrix.toEuclideanCLM M v)`.
- Discuss normalization strategy to avoid division by zero (e.g., require `v ≠ 0` or use `‖v‖` guard).
- Encode the iterative sequence using Lean’s `Nat.rec` or `Nat.iterate`.

### 3. Capture Missing Lemmas (15 min)
- If geometric-series arguments or spectral-gap inequalities are missing, jot them down in `LEMMAS_NEEDED.md`.
- Prototype any auxiliary results in the `explore_power_iter` scratch file.

---

## Exit Criteria

- [ ] Iteration definition compiles.
- [ ] Key supporting lemmas identified and documented.
- [ ] Updated notes in `LEMMAS_NEEDED.md`, `PRIORITY_1_PROGRESS.md`, and session logs.

---

## Stretch Goals

1. Draft the statement of `powerIter_converges` with explicit hypotheses.
2. Outline the geometric-decay argument within the eigenbasis decomposition.
3. Note any reuse opportunities for operator-norm results just proven.
