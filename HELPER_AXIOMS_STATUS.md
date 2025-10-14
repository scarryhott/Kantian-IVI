# Helper Axioms Status: eigenvalue_le_opNorm & opNorm_le_sup_eigenvalues

**Date**: October 14, 2025  
**Status**: Documented, ready for future work

---

## 🎯 Current Situation

We have two helper axioms remaining for `lambdaHead_eq_opNorm`:

1. **eigenvalue_le_opNorm**: Each eigenvalue ≤ operator norm
2. **opNorm_le_sup_eigenvalues**: Operator norm ≤ supremum of eigenvalues

Together, these prove: `lambdaHead A = ‖A‖`

---

## ⚠️ Key Constraint: No Circular Dependencies

**Critical Discovery**: Cannot use `lambdaHead_eq_opNorm` to prove its own dependencies!

### Correct Dependency Order
```
eigenvalue_le_opNorm (axiom - must prove independently)
    ↓
sup_eigenvalues_le_opNorm (theorem ✅)
    ↓
lambdaHead_eq_opNorm (theorem ✅) ← also needs opNorm_le_sup_eigenvalues
```

**Attempted Proof** (October 14):
- Tried to prove `eigenvalue_le_opNorm` using `lambdaHead_eq_opNorm`
- Created circular dependency
- Reverted to axiom

---

## 📋 Proof Strategies

### For eigenvalue_le_opNorm

**Goal**: Show |λᵢ| ≤ ‖A‖ for each eigenvalue λᵢ

**Strategy**:
1. Get eigenvector vᵢ with ‖vᵢ‖ = 1 and A *ᵥ vᵢ = λᵢ • vᵢ
2. Compute: ‖A *ᵥ vᵢ‖ = ‖λᵢ • vᵢ‖ = |λᵢ| * ‖vᵢ‖ = |λᵢ|
3. Use operator norm bound: ‖A *ᵥ vᵢ‖ ≤ ‖A‖ * ‖vᵢ‖ = ‖A‖
4. Therefore: |λᵢ| ≤ ‖A‖

**Mathlib Lemmas Needed**:
- Eigenvector property: `A *ᵥ vᵢ = λᵢ • vᵢ`
- Orthonormal basis: `‖vᵢ‖ = 1` (from `OrthonormalBasis.orthonormal`)
- Operator norm bound: `‖A *ᵥ v‖ ≤ ‖A‖ * ‖v‖` (from `ContinuousLinearMap.le_opNorm`)

**Difficulty**: Medium (need to connect matrix mulVec to continuous linear map)

**Estimated Time**: 2-3 hours

---

### For opNorm_le_sup_eigenvalues

**Goal**: Show ‖A‖ ≤ sup |λᵢ|

**Strategy 1: Spectral Decomposition**
1. Any vector v = Σᵢ cᵢ vᵢ (eigenvector basis expansion)
2. Then A *ᵥ v = Σᵢ cᵢ λᵢ vᵢ
3. By Parseval: ‖A *ᵥ v‖² = Σᵢ |cᵢ λᵢ|² ≤ (max |λᵢ|)² Σᵢ |cᵢ|² = (max |λᵢ|)² ‖v‖²
4. Therefore: ‖A *ᵥ v‖ ≤ (max |λᵢ|) ‖v‖ for all v
5. By `ContinuousLinearMap.opNorm_le_bound`: ‖A‖ ≤ max |λᵢ|

**Mathlib Lemmas Needed**:
- `OrthonormalBasis.repr`: Decompose vector in eigenvector basis
- `OrthonormalBasis.sum_repr`: v = Σᵢ (repr v i) • vᵢ
- Parseval's identity for orthonormal bases
- `ContinuousLinearMap.opNorm_le_bound`

**Difficulty**: Hard (requires careful manipulation of sums and norms)

**Estimated Time**: 3-4 hours

---

**Strategy 2: Spectral Radius (Attempted)**
1. For self-adjoint elements: spectral radius = norm
2. Spectral radius = sup of |spectrum|
3. Spectrum = eigenvalues
4. Therefore: norm = sup |eigenvalues|

**Problem**: 
- `IsSelfAdjoint.spectralRadius_eq_nnnorm` works for C*-algebras over ℂ
- Real matrices don't have the required algebra structure
- Type mismatch: `Algebra ℂ (Matrix (Fin n) (Fin n) ℝ)` not synthesizable

**Status**: Blocked by type system issues

**Estimated Time**: Unknown (may need mathlib extension)

---

## 🎓 What We Learned

### Technical
1. **Circular dependencies are subtle** - easy to create accidentally
2. **Type system matters** - C*-algebra results don't directly apply to real matrices
3. **Mathlib is deep** - spectral theory spans multiple modules
4. **Proof order matters** - must prove dependencies before using them

### Strategic
1. **Document clearly** - future us (or others) will appreciate detailed notes
2. **Don't get stuck** - sometimes it's better to move on and come back
3. **Progress is progress** - understanding the problem is valuable
4. **Build stability** - keep the codebase working while exploring

---

## 📊 Impact Analysis

### If We Prove Both Helper Axioms

**Benefits**:
- `lambdaHead_eq_opNorm` becomes a pure theorem (no axiom dependencies)
- Axiom count: 30 → 28 (-2)
- Major theoretical milestone
- Demonstrates complete understanding of spectral theory

**Cost**:
- 5-7 hours of focused work
- High technical difficulty
- Risk of getting stuck

### If We Leave Them As Axioms

**Benefits**:
- Can continue with other Phase 1 priorities
- Maintain momentum
- Diversify work
- Build more experience with mathlib

**Cost**:
- 2 axioms remain
- Theoretical incompleteness
- May need to come back later

---

## 💡 Recommendation

**Move on to other priorities** for now. Here's why:

1. **Diminishing returns**: We've already proven the main theorem (`lambdaHead_eq_opNorm`)
2. **Well-documented**: The helper axioms have clear proof strategies
3. **Other opportunities**: Phase 1 has 6 more priorities to tackle
4. **Learning curve**: Other proofs might teach us techniques useful here
5. **Momentum**: Keep making visible progress

**Come back when**:
- We've gained more mathlib experience
- We've completed other Phase 1 priorities
- We find relevant examples in mathlib
- We have a fresh perspective

---

## 🎯 Alternative Approach

Instead of proving these two specific axioms, we could:

1. **Find existing mathlib theorems** that directly state `lambdaHead = opNorm` for symmetric matrices
2. **Use mathlib's spectral theory** more directly instead of our custom `lambdaHead` definition
3. **Refactor** to use mathlib's definitions throughout

This might be easier than proving from scratch!

---

## 📚 References

### Mathlib Modules
- `Mathlib.LinearAlgebra.Matrix.Spectrum`
- `Mathlib.Analysis.InnerProductSpace.PiL2`
- `Mathlib.Analysis.CStarAlgebra.Matrix`
- `Mathlib.Analysis.CStarAlgebra.Spectrum`

### Key Lemmas Found
- `Matrix.IsHermitian.eigenvalues_eq`
- `Matrix.IsHermitian.eigenvectorBasis`
- `OrthonormalBasis.orthonormal`
- `ContinuousLinearMap.le_opNorm`
- `ContinuousLinearMap.opNorm_le_bound`
- `IsSelfAdjoint.spectralRadius_eq_nnnorm` (C*-algebra only)
- `Matrix.IsHermitian.spectrum_real_eq_range_eigenvalues`

### Literature
- Horn & Johnson, "Matrix Analysis" (1985), Theorem 5.6.9

---

**Created**: October 14, 2025, 10:00 AM  
**Status**: Documented and ready for future work  
**Recommendation**: Move to other Phase 1 priorities
