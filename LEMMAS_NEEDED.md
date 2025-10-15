# Lemmas Needed — `operator_norm_bound`

**Goal**: Prove the axiom

```lean
operator_norm_bound
  {n : Nat} (M : RealMatrixN n) (c : ℝ) (d : Nat)
  (h_entry : entrywiseBounded M c)
  (h_sparse : rowSparsity M d)
  (h_c_pos : c ≥ 0) :
  ∃ norm_M, norm_M ≤ c * Real.sqrt (n * d)
```

---

## Key Ingredients

1. **Row-level ℓ₂ bound** ✅ *Done — see `row_square_sum_le`*
   ```lean
   lemma row_square_sum_le
       (h_entry : entrywiseBounded M c) (h_sparse : rowSparsity M d)
       (h_c_pos : 0 ≤ c) (i : Fin n) :
       (∑ j, (M i j) ^ 2) ≤ (d : ℝ) * c ^ 2
   ```
   - Converts sparsity into a bound on the squared ℓ₂ norm of each row.
   - Proof strategy: restrict to the non-zero support, bound each term by `c²`,
     and apply the cardinality inequality from `rowSparsity`.

2. **Cauchy-Schwarz per row**
   ```lean
   have : ‖(Matrix.toEuclideanCLM M) v‖^2
        = ∑ i, ‖⟪row i, v⟫‖^2
   ```
   - Follows from Parseval/orthonormality of standard basis.
   - Each inner product bounded by `‖row i‖ * ‖v‖`.

3. **Global inequality**
   ```lean
   ‖M v‖ ≤ c * Real.sqrt (n * d) * ‖v‖
   ```
   - After squaring & summing, use `Finset.sum_le_sum`.

4. **Operator norm packaging**
   - Apply `ContinuousLinearMap.opNorm_le_bound`.
   - Witness chosen as `‖M‖`.

---

## Lemmas To Search / Prove

- `Finset.card_filter_le` to bound the number of non-zero entries.
- Conversion between `rowSparsity` hypothesis and `Finset` statements.
- `Matrix.toEuclideanCLM` properties (unit vectors as orthonormal basis).
- `Real.sqrt_mul`, `Real.sqrt_natCast`.
- Any existing mathlib lemma bounding norms of sparse vectors (if available).

If a lemma is not in mathlib, sketch it locally with comments so it can later be generalized or upstreamed.
