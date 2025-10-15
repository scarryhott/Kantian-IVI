# Next Work: Prove `operator_norm_bound`

**Goal**: Remove the remaining high-priority axiom in `IVI/RealSpecMathlib.lean` by proving the quantitative operator-norm bound for sparse, entrywise-bounded matrices.

---

## Where We Stand ✅

- `lambdaHead_eq_opNorm` is now a fully proven theorem (both helper lemmas completed).
- `weyl_eigenvalue_bound_real_n` is also a theorem, powered by the new operator-norm equivalence.
- Remaining spectral axioms in this file:
  1. `embedToMatrix` (structural bridge, low priority)
  2. `operator_norm_bound` (quantitative estimate) **← focus**
  3. Power-iteration and Lipschitz axioms (Phase 1.3–1.4 targets)

Eliminating `operator_norm_bound` tightens the quantitative side of Phase 1.2 and sets up Phase 2 (runtime/error analysis).

---

## Statement To Prove

```lean
axiom operator_norm_bound
  {n : Nat} (M : RealMatrixN n) (c : ℝ) (d : Nat)
  (h_entry : entrywiseBounded M c)
  (h_sparse : rowSparsity M d)
  (h_c_pos : c ≥ 0) :
  ∃ (norm_M : ℝ), norm_M ≤ c * Real.sqrt (n * d)
```

**Intuition**: A matrix with at most `d` non-zero entries per row and entries bounded by `c` has spectral norm ≤ `c √(n d)`. This is a standard Gershgorin/ℓ₂ estimate.

---

## Plan of Attack

### Step 1 — Reformulate the Goal
- Interpret the conclusion as `‖M‖ ≤ c * √(n * d)` under the L2 operator norm.
- Translate `entrywiseBounded` and `rowSparsity` hypotheses into algebraic bounds on matrix rows.
- Decide whether to work directly with the matrix-as-linear-map (`Matrix.toEuclideanCLM`) or via vector inequalities.

### Step 2 — Row-wise Norm Bound ✅ *Completed via `row_square_sum_le`*
- Every row now satisfies: `∑ᵢ (M i j)² ≤ d · c²`.
- This controls the squared ℓ₂ norm of each row; ready to feed into Cauchy-Schwarz.

### Step 3 — Global Bound (In Progress)
- Apply Cauchy-Schwarz on each row using `row_square_sum_le`.
- Target: `‖M v‖² ≤ (c² * n * d) ‖v‖²`, hence `‖M v‖ ≤ c √(n d) ‖v‖`.
- Once the inequality is established, invoke `ContinuousLinearMap.opNorm_le_bound`.

### Step 4 — Existential Packaging
- The lemma currently states an existence of some `norm_M`. We can instantiate it with `‖M‖` and reuse the inequality.
- Conclude the axiom using the derived bound.

---

## Supporting Lemmas To Look For 🔍

- `Matrix.row` + `Finset` lemmas for counting non-zero entries.
- `Real.sqrt_mul`, `Real.sqrt_natCast` for handling √(n * d).
- `Finset.card` bounds from `rowSparsity`.
- Norm inequalities: `norm_sum_le`, `norm_mul`, `Finset.norm_sum_le`.

If a ready-made lemma exists (e.g. in `mathlib` for sparse matrices), prefer reusing it; otherwise derive the estimate manually.

---

## Risks / Open Questions

1. **Formalizing sparsity**: confirm `rowSparsity` gives the right combinatorial bound (≤ d non-zero entries per row). If not, adjust or strengthen the lemma.
2. **Non-negativity of √ argument**: ensure `n * d` coerces to ℝ with appropriate non-negativity proofs.
3. **Existence statement**: convert the inequality into the requested existential witness cleanly.

Fallback: if direct proof stretches too long, document the main missing lemma(s) and commit partial progress.

---

## Stretch Goals

1. Generalize the bound to rectangular matrices (if helpful later).
2. Explore whether `rowSparsity` can be derived from stronger structural assumptions (for Phase 2).
3. Begin scaffolding for `powerIter_converges` using the new quantitative bounds.

---

## Ready Checklist

- [ ] Locate or restate key helper lemmas (row norm bound, sum-of-squares bound).
- [ ] Express `‖M‖` via `Matrix.toEuclideanCLM`.
- [ ] Prove `‖M v‖ ≤ c * √(n * d) * ‖v‖`.
- [ ] Package into existential statement.
- [ ] Update documentation (`PRIORITY_1_PROGRESS.md`, statuses) once complete.
