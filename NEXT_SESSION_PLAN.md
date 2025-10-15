# Next Session Plan — Operator Norm Bound

**Date**: October 14, 2025  
**Objective**: Replace the `operator_norm_bound` axiom in `IVI/RealSpecMathlib.lean` with a constructive proof.

---

## Session Goals

1. Upgrade the row-level bound (`row_square_sum_le`) into a vector-level inequality:
   `∑ᵢ |(M v)_i|² ≤ (d : ℝ) * c² * ‖v‖²`.
2. Deduce `‖M v‖ ≤ c * √(n * d) * ‖v‖` and set up the `ContinuousLinearMap.opNorm_le_bound` call.
3. Capture any auxiliary lemmas (e.g. Cauchy-Schwarz in this setting) so they can be reused if the proof does not finish.

---

## Pre-Session Checklist

- [ ] Skim `RealSpecMathlib.lean` around the current axiom for context (`rg "operator_norm_bound"`).
- [ ] Refresh the definitions of `entrywiseBounded` and `rowSparsity` (likely in `IVI/Invariant.lean`).
- [ ] Open mathlib docs for matrix norms and `Finset` inequalities.

Helpful commands:
```bash
# Inspect hypotheses in Lean
#check entrywiseBounded
#check rowSparsity

# Build just the target file during development
lake build IVI.RealSpecMathlib
```

---

## Step-by-Step Outline

### 1. Interpret Hypotheses (20 min)
- Expand `entrywiseBounded M c` to understand the pointwise absolute value bound.
- Expand `rowSparsity M d` to extract a cardinality statement (`≤ d` non-zero entries).
- Record any helper lemmas already available (search `rg "rowSparsity"`).

### 2. Record Row Lemma (5 min) ✅
- Use the proven `row_square_sum_le` for each row.
- Note that this already yields `‖row_i‖² ≤ d · c²`.

### 3. Bound `‖M v‖` (45–60 min)
- Work with `Matrix.toEuclideanCLM` or `Matrix.mulVec`.
- For each row, apply Cauchy-Schwarz: `|(Mv)_i| ≤ ‖row_i‖₂ ‖v‖₂`.
- Sum the squares using Parseval / orthogonality; conclude `‖M v‖ ≤ c * √(n * d) * ‖v‖`.
- Invoke `ContinuousLinearMap.opNorm_le_bound`.

### 4. Package the Result (10 min)
- Define `norm_M := ‖A‖`.
- Provide the inequality as the witness required by the axiom.
- Wrap the proof in the expected existential.

### 5. Testing & Documentation (15 min)
- Run `lake build IVI.RealSpecMathlib`.
- If successful, update `PRIORITY_1_PROGRESS.md`, `REMAINING_AXIOMS_ANALYSIS.md`, and session notes.
- If not, record blockers and partial lemmas.

---

## Resources & Lemmas

- `ContinuousLinearMap.opNorm_le_bound`
- `Finset.card_filter_le`
- `Finset.sum_natCast`
- `Matrix.toEuclideanCLM` norm properties
- Inequalities: `Real.sqrt_mul`, `mul_le_mul_of_nonneg`, `Real.norm_eq_abs`

If new helper lemmas are required (e.g. a bound on the ℓ₂ norm of a sparse vector), write them in-line with comments so they can later be upstreamed to mathlib.

---

## Stretch Goals (if time remains)

1. Check whether a tighter bound `‖M‖ ≤ c * √d` (independent of `n`) is provable under current definitions.
2. Sketch how the quantitative bound feeds into `powerIter_converges` (Phase 1.3).
3. Audit other remaining axioms to prioritize the next elimination.

---

## Exit Criteria

- [ ] Proof of `operator_norm_bound` compiles with no `sorry`.
- [ ] Build succeeds locally.
- [ ] Documentation updated (progress + next steps).
- [ ] Blockers noted if proof incomplete.
