# Lemmas Needed — Power Iteration

**Target theorem**: `powerIter_converges`  
**Context**: real symmetric matrices (`Matrix.IsHermitian`) with spectral gap.

---

## Pending Lemmas

1. **Eigenbasis Expansion Bound**
   ```lean
   lemma eigenbasis_coeff_decay
       {λ₁ : ℝ} (gap : ∀ i ≠ i₀, |λᵢ| ≤ r) :
       |⟪eigen i, (M^k) • v⟫| ≤ |λᵢ|^k * C
   ```
   - Needed to quantify the decay of non-dominant components.
   - Requires expressing iterates in the Hermitian eigenbasis.

2. **Normalization Control**
   ```lean
   lemma normalize_iterate_bound
       (hk : ‖(Matrix.toEuclideanCLM M)^k v‖ ≠ 0) :
       ‖normalize ((Matrix.toEuclideanCLM M)^k v) - dominantVec‖ ≤ …
   ```
   - Ensures each step of normalized iteration is well-defined and bounded.

3. **Spectral-Gap Inequality**
   ```lean
   lemma spectral_gap_ratio
       (gap : |λ₂| ≤ r * |λ₁|) :
       |λ₂ / λ₁|^k ≤ r^k
   ```
   - Formalizes geometric decay relative to the dominant eigenvalue.

4. **Iterated Action in Eigenbasis**
   ```lean
   lemma iterate_in_eigenbasis
       (v : EuclideanSpace ℝ (Fin n)) :
       (Matrix.toEuclideanCLM M)^[k] v =
         ∑ i, (λᵢ ^ k * ⟪eigen i, v⟫) • eigen i
   ```
   - Converts repeated application of `M` into scalar powers in the orthonormal basis.

5. **Normalization Continuity**
   ```lean
   lemma normalize_lim {x : ℕ → E} (hx : x ⟶ x₀) (h≠0 : x₀ ≠ 0) :
       normalize (x n) ⟶ normalize x₀
   ```
   - Needed to conclude convergence of the normalized iteration.

---

## Notes

- Many pieces may exist in mathlib; confirm before proving from scratch.
- Track discovered lemmas in `explore_power_iter.lean` before moving them into `IVI/RealSpecMathlib.lean`.
