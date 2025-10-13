# Lemma Search Results

**Date**: October 13, 2025  
**Session**: Searching for lemmas to prove eigenvalue_le_opNorm

---

## ✅ Found: Orthonormal Property

**Lemma**: `OrthonormalBasis.orthonormal`

**Usage**:
```lean
example (i : Fin n) : ‖hHerm.eigenvectorBasis i‖ = 1 := by
  exact hHerm.eigenvectorBasis.orthonormal.1 i
```

**Status**: ✅ Works perfectly!

---

## ⚠️ Found (Complex): Eigenvector Property

**Lemma**: `LinearMap.IsSymmetric.eigenvectorBasis_apply_self_apply`

**Type**:
```lean
LinearMap.IsSymmetric.eigenvectorBasis_apply_self_apply :
  ∀ {𝕜 : Type u_1} [RCLike 𝕜] {E : Type u_2} [NormedAddCommGroup E] [InnerProductSpace 𝕜 E]
    {T : E →ₗ[𝕜] E} [FiniteDimensional 𝕜 E] {n : ℕ} (hT : T.IsSymmetric) (hn : Module.finrank 𝕜 E = n)
    (v : E) (i : Fin n),
  (hT.eigenvectorBasis hn).repr (T v) i = (hT.eigenvalues hn i) * (hT.eigenvectorBasis hn).repr v i
```

**Challenge**: This is for **linear maps**, not matrices!

**Key Insight**: `Matrix.IsHermitian.eigenvectorBasis` is defined using the linear map version:
```lean
def Matrix.IsHermitian.eigenvectorBasis :=
  (⋯.eigenvectorBasis ⋯).reindex (Fintype.equivOfCardEq ⋯)
```

**What we need**: Connect `A.mulVec v` to `Matrix.toEuclideanLin A v`

---

## 🔍 Need to Find: Matrix-LinearMap Connection

**What we need**:
1. Lemma showing `A.mulVec v = Matrix.toEuclideanLin A v` (or similar)
2. Way to convert `Matrix.IsHermitian` to `LinearMap.IsSymmetric`
3. Connection between matrix eigenvalues and linear map eigenvalues

**Potential lemmas to search**:
- `Matrix.toEuclideanLin_apply`
- `Matrix.toEuclideanLin_mulVec`
- `Matrix.IsHermitian.toLinearMap`

---

## 🔍 Need to Find: Operator Norm Bound

**What we need**: `‖A.mulVec v‖ ≤ ‖A‖ * ‖v‖`

**Potential lemmas**:
- `Matrix.norm_mulVec_le`
- `ContinuousLinearMap.le_op_norm`
- Operator norm definition for matrices

**Status**: Not yet searched

---

## Alternative Strategy

### Option 1: Use Linear Map Throughout

Instead of working with `A.mulVec`, work with `Matrix.toEuclideanLin A`:

```lean
theorem eigenvalue_le_opNorm (i : Fin n) :
    |(hHerm A hA).eigenvalues i| ≤ ‖Matrix.toEuclideanLin A‖ := by
  -- Use LinearMap.IsSymmetric.eigenvectorBasis_apply_self_apply directly
  sorry
```

**Challenge**: Need to show `‖Matrix.toEuclideanLin A‖ = ‖A‖`

### Option 2: Find Matrix-Specific Lemmas

Search for lemmas specifically about `Matrix.IsHermitian` and eigenvalues:

```bash
#check Matrix.IsHermitian.eigenvalues_eq
#check Matrix.IsHermitian.apply_eigenvectorBasis
```

### Option 3: Prove Helper Lemmas

If mathlib doesn't have the direct connection, prove:

```lean
lemma matrix_mulVec_eq_toEuclideanLin (v : EuclideanSpace ℝ (Fin n)) :
    A.mulVec v = Matrix.toEuclideanLin A v := sorry

lemma matrix_norm_eq_linearMap_norm :
    ‖A‖ = ‖Matrix.toEuclideanLin A‖ := sorry
```

---

## Next Actions

### Immediate (30 min)
1. Search for `Matrix.toEuclideanLin_apply` or similar
2. Search for operator norm lemmas for matrices
3. Check if there's a direct `Matrix.IsHermitian` eigenvector lemma

### If Not Found (1 hour)
1. Prove the helper lemmas ourselves
2. Use the linear map version throughout
3. Convert at the end

### Fallback (Ask for Help)
1. Post on Lean Zulip with specific question
2. Include minimal working example
3. Ask about matrix vs linear map eigenvectors

---

## Key Insight

**The Challenge**: Mathlib's spectral theorem is primarily for linear maps, not matrices directly.

**The Solution**: Either:
1. Find the bridge lemmas (matrix ↔ linear map)
2. Work with linear maps throughout
3. Prove the bridge lemmas ourselves

**Estimated Time**: 
- If bridge lemmas exist: 1-2 hours
- If we need to prove them: 3-4 hours
- If we work with linear maps: 2-3 hours

---

## Confidence Level

- **Orthonormal property**: ✅ 100% - Works perfectly
- **Eigenvector property**: ⚠️ 70% - Exists but needs conversion
- **Operator norm bound**: 🔍 50% - Haven't searched yet

**Overall**: 70% confident we can complete this, but may take longer than initially estimated.

---

## Updated Timeline

| Task | Original Estimate | New Estimate | Reason |
|------|------------------|--------------|--------|
| Find lemmas | 1 hour | 1.5 hours | Need matrix-linear map bridge |
| Prove Step 1 | 2-4 hours | 3-5 hours | More complex than expected |
| **Total** | **3-5 hours** | **4.5-6.5 hours** | Matrix vs linear map complexity |

---

**Status**: In progress, encountering expected complexity  
**Next**: Search for matrix-linear map bridge lemmas  
**Confidence**: Still high, just needs more careful work
