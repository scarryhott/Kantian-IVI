# Lemmas Needed for lambdaHead_eq_opNorm Proof

**Date**: October 13, 2025  
**Goal**: Find mathlib lemmas to complete the proof

---

## What We Need to Prove

```lean
theorem lambdaHead_eq_opNorm {n : Nat} [Fintype (Fin n)] [DecidableEq (Fin n)] [Nonempty (Fin n)]
    (A : RealMatrixN n) (hA : Matrix.IsSymm A) :
    open scoped Matrix.Norms.L2Operator in
    lambdaHead A hA = ‖A‖
```

Where:
```lean
noncomputable def lambdaHead (A : RealMatrixN n) (hA : Matrix.IsSymm A) : ℝ :=
  let hHerm : Matrix.IsHermitian A := Matrix.isHermitian_iff_isSymmetric.mpr hA
  Finset.univ.sup' (Finset.univ_nonempty (α := Fin n)) (fun i => |hHerm.eigenvalues i|)
```

---

## Step 1: eigenvalue_le_opNorm

**Goal**: Prove `|(hHerm.eigenvalues i)| ≤ ‖A‖` for each `i : Fin n`

### Lemmas Needed

1. **Eigenvector property**:
   ```lean
   -- Need: A.mulVec (hHerm.eigenvectorBasis i) = hHerm.eigenvalues i • (hHerm.eigenvectorBasis i)
   -- Search for: Matrix.IsHermitian.apply_eigenvectorBasis
   --         or: Matrix.IsHermitian.eigenvectorBasis_apply
   --         or: Matrix.IsHermitian.hasEigenvector
   ```

2. **Orthonormal property**:
   ```lean
   -- Need: ‖hHerm.eigenvectorBasis i‖ = 1
   -- Search for: OrthonormalBasis.norm_eq_one
   --         or: OrthonormalBasis.orthonormal
   ```

3. **Operator norm bound**:
   ```lean
   -- Need: ‖A.mulVec v‖ ≤ ‖A‖ * ‖v‖
   -- Search for: Matrix.norm_mulVec_le
   --         or: ContinuousLinearMap.le_op_norm
   --         or: norm_mulVec_le
   ```

### Proof Sketch

```lean
lemma eigenvalue_le_opNorm (i : Fin n) :
    |(hHerm A hA).eigenvalues i| ≤ ‖A‖ := by
  let v := (hHerm A hA).eigenvectorBasis i
  let λ := (hHerm A hA).eigenvalues i
  -- Step 1: A v = λ v (eigenvector property)
  have h_eigen : A.mulVec v = λ • v := sorry -- Need lemma
  -- Step 2: ‖v‖ = 1 (orthonormal)
  have h_norm : ‖v‖ = 1 := sorry -- Need lemma
  -- Step 3: |λ| = ‖λ • v‖ / ‖v‖ = ‖A v‖ / ‖v‖
  calc |λ| = |λ| * ‖v‖ := by rw [h_norm, mul_one]
       _ = ‖λ • v‖ := by rw [norm_smul]
       _ = ‖A.mulVec v‖ := by rw [← h_eigen]
       _ ≤ ‖A‖ * ‖v‖ := sorry -- Need operator norm bound
       _ = ‖A‖ := by rw [h_norm, mul_one]
```

---

## Step 2: sup_eigenvalues_le_opNorm

**Goal**: Prove `lambdaHead A hA ≤ ‖A‖`

### Lemmas Needed

None! This follows directly from Step 1 and `Finset.sup'_le`.

### Proof

```lean
theorem sup_eigenvalues_le_opNorm :
    lambdaHead A hA ≤ ‖A‖ := by
  unfold lambdaHead
  apply Finset.sup'_le
  intro i _
  exact eigenvalue_le_opNorm A hA i
```

**Status**: Structure is complete, just needs Step 1.

---

## Step 3: opNorm_le_sup_eigenvalues

**Goal**: Prove `‖A‖ ≤ lambdaHead A hA`

### Lemmas Needed

1. **Orthonormal basis decomposition**:
   ```lean
   -- Need: Any v can be written as Σᵢ (hHerm.eigenvectorBasis.repr v i) • (hHerm.eigenvectorBasis i)
   -- Search for: OrthonormalBasis.sum_repr
   --         or: OrthonormalBasis.repr_apply_apply
   ```

2. **Parseval's identity**:
   ```lean
   -- Need: ‖v‖² = Σᵢ |(hHerm.eigenvectorBasis.repr v i)|²
   -- Search for: OrthonormalBasis.norm_sq_eq_sum
   --         or: Orthonormal.norm_sq_eq_sum
   ```

3. **Linearity of matrix multiplication**:
   ```lean
   -- Need: A.mulVec (Σᵢ cᵢ • vᵢ) = Σᵢ cᵢ • (A.mulVec vᵢ)
   -- Should follow from: Matrix.mulVec_add, Matrix.mulVec_smul
   ```

4. **Norm of sum with orthogonal vectors**:
   ```lean
   -- Need: ‖Σᵢ cᵢ • vᵢ‖² = Σᵢ |cᵢ|² when vᵢ are orthonormal
   -- This is Parseval's identity again
   ```

### Proof Sketch

```lean
theorem opNorm_le_sup_eigenvalues :
    ‖A‖ ≤ lambdaHead A hA := by
  -- Operator norm is sup of ‖Av‖/‖v‖ over nonzero v
  -- Suffices to show: ‖A.mulVec v‖ ≤ lambdaHead A hA * ‖v‖ for all v
  suffices ∀ v, ‖A.mulVec v‖ ≤ lambdaHead A hA * ‖v‖ by sorry
  intro v
  -- Decompose v in eigenvector basis
  let basis := (hHerm A hA).eigenvectorBasis
  let c := basis.repr v
  -- v = Σᵢ c(i) • basis(i)
  have h_decomp : v = ∑ i, c i • basis i := sorry -- Need lemma
  -- A v = Σᵢ c(i) • λᵢ • basis(i)
  have h_Av : A.mulVec v = ∑ i, c i • (hHerm A hA).eigenvalues i • basis i := by
    rw [h_decomp]
    sorry -- Need linearity + eigenvector property
  -- ‖A v‖² = Σᵢ |c(i)|² |λᵢ|² (Parseval)
  have h_norm_Av : ‖A.mulVec v‖^2 = ∑ i, |c i|^2 * |(hHerm A hA).eigenvalues i|^2 := sorry
  -- ‖v‖² = Σᵢ |c(i)|² (Parseval)
  have h_norm_v : ‖v‖^2 = ∑ i, |c i|^2 := sorry
  -- Each |λᵢ|² ≤ (lambdaHead A hA)²
  have h_bound : ∀ i, |(hHerm A hA).eigenvalues i|^2 ≤ (lambdaHead A hA)^2 := sorry
  -- Therefore: ‖A v‖² ≤ (lambdaHead A hA)² * ‖v‖²
  calc ‖A.mulVec v‖^2 = ∑ i, |c i|^2 * |(hHerm A hA).eigenvalues i|^2 := h_norm_Av
       _ ≤ ∑ i, |c i|^2 * (lambdaHead A hA)^2 := by sorry -- Use h_bound
       _ = (lambdaHead A hA)^2 * ∑ i, |c i|^2 := by sorry -- Algebra
       _ = (lambdaHead A hA)^2 * ‖v‖^2 := by rw [← h_norm_v]
  -- Take square roots
  sorry
```

---

## Step 4: Main Theorem

**Goal**: Combine Steps 2 and 3

### Lemmas Needed

None! Just `le_antisymm`.

### Proof

```lean
theorem lambdaHead_eq_opNorm :
    lambdaHead A hA = ‖A‖ := by
  apply le_antisymm
  · exact sup_eigenvalues_le_opNorm A hA
  · exact opNorm_le_sup_eigenvalues A hA
```

**Status**: Complete, just needs Steps 2 and 3.

---

## Search Strategy

### 1. Online Mathlib Docs
- https://leanprover-community.github.io/mathlib4_docs/
- Search for: "IsHermitian", "eigenvector", "OrthonormalBasis", "operator norm"

### 2. Lean Zulip
- https://leanprover.zulipchat.com/
- Search archives for: "spectral theorem", "eigenvalue norm"
- Ask in #mathlib if stuck

### 3. Mathlib Source
- Look in: `Mathlib/LinearAlgebra/Matrix/Spectrum.lean`
- Look in: `Mathlib/Analysis/CStarAlgebra/Matrix.lean`
- Look in: `Mathlib/Analysis/InnerProductSpace/PiL2.lean`

### 4. Use `#check` in Lean
```lean
#check Matrix.IsHermitian.apply_eigenvectorBasis
#check OrthonormalBasis.norm_eq_one
#check Matrix.norm_mulVec_le
#check OrthonormalBasis.sum_repr
```

---

## Priority Order

### High Priority (Step 1)
1. Eigenvector property lemma
2. Orthonormal property lemma
3. Operator norm bound lemma

**Why**: Step 1 is the foundation. Once proven, Step 2 follows immediately.

### Medium Priority (Step 3)
4. Orthonormal basis decomposition
5. Parseval's identity
6. Linearity lemmas

**Why**: Step 3 is harder but well-structured. These lemmas should exist in mathlib.

### Low Priority
7. Algebra and calculation lemmas

**Why**: These are standard and should be easy to find or prove.

---

## Fallback Strategy

If we can't find the exact lemmas in mathlib:

### Option 1: Prove Helper Lemmas
- Prove the missing lemmas ourselves using more basic mathlib lemmas
- This is more work but ensures we understand the mathematics

### Option 2: Use Sorry Strategically
- Leave the hardest parts as `sorry` initially
- Focus on getting the structure right
- Fill in `sorry`s incrementally

### Option 3: Ask for Help
- Post on Lean Zulip with specific questions
- Mathlib community is very helpful
- Include minimal working example

---

## Next Actions

### Immediate
1. Search mathlib docs for "Matrix.IsHermitian.apply_eigenvectorBasis"
2. Search for "OrthonormalBasis.norm"
3. Search for "Matrix.norm_mulVec"

### If Found
1. Attempt to prove Step 1
2. Verify Step 2 compiles
3. Document progress

### If Not Found
1. Search for related lemmas
2. Check Lean Zulip archives
3. Consider proving helper lemmas ourselves

---

## Estimated Difficulty

| Step | Difficulty | Reason |
|------|-----------|--------|
| Step 1 | Medium | Need to find 3 lemmas, but they should exist |
| Step 2 | Easy | Follows directly from Step 1 |
| Step 3 | Hard | Need orthonormal decomposition, more complex |
| Step 4 | Easy | Just combines Steps 2 and 3 |

**Overall**: Medium-Hard, but achievable with mathlib infrastructure.

---

## Success Indicators

### We're on the right track if:
- ✅ We find eigenvector property lemma
- ✅ We find orthonormal property lemma
- ✅ We find operator norm bound lemma
- ✅ Step 1 proof compiles

### We might need help if:
- ❌ Can't find eigenvector property after 1 hour of searching
- ❌ Type errors we can't resolve
- ❌ Mathlib doesn't have the lemmas we need

---

**Updated**: October 13, 2025  
**Status**: Lemmas identified, ready to search  
**Next**: Search mathlib documentation
