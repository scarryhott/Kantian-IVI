# Phase 1 Status: Mathematical Foundations

**Strategy**: Math First, Then Kant (see `PROOF_STRATEGY.md`)

**Goal**: Prove all computational/analytic properties in ℝ using mathlib.

---

## Phase 1.1: Spectral Theory (Weyl Inequality)

### Current Status: 🚧 In Progress

**Target**: Replace Weyl axiom with mathlib-backed proof.

### What's Done ✅

1. **Mathlib Integration**
   - ✅ Added mathlib dependency to `lakefile.lean`
   - ✅ Aligned toolchain to mathlib's Lean version
   - ✅ Successfully fetched and built with mathlib

2. **Type Refactor**
   - ✅ Refactored `IVI/RealSpec.lean` to use mathlib's `ℝ`
   - ✅ Introduced `RealMatrixN n := Matrix (Fin n) (Fin n) ℝ`
   - ✅ Removed placeholder Real axioms

3. **Hermitian Specialization**
   - ✅ Tightened Weyl statement to symmetric (Hermitian) matrices
   - ✅ Added `A.IsSymmetric`, `E.IsSymmetric` hypotheses
   - ✅ Documented standard Weyl inequality for Hermitian matrices

4. **lambdaHead Definition**
   - ✅ Changed from `axiom` to `def`
   - ✅ Documented correct implementation path
   - ⚠️ Currently uses `Classical.choice ⟨0⟩` placeholder
   - 📋 TODO: Replace with `Finset.univ.sup' eigenvalues`

5. **Float-to-Real Bridge**
   - ✅ Created `toRealMatN {n} : List (List Float) → RealMatrixN n`
   - ✅ Defined `lambdaHead_float` for Float matrices
   - ✅ Scaffolded `weyl_error_budget_inf` for error-budget bridge

### What's Left 🚧

1. **Complete lambdaHead Implementation**
   - Replace `Classical.choice ⟨0⟩` with actual eigenvalue computation
   - Use mathlib's `Matrix.IsHermitian.eigenvalues` (when available)
   - Or implement via characteristic polynomial and spectral theorem

2. **Prove weyl_eigenvalue_bound_real_n**
   - Currently axiomatized
   - Need to prove using mathlib's Hermitian spectral theory
   - Standard result: |λᵢ(A + E) - λᵢ(A)| ≤ ‖E‖
   - Reference: Horn & Johnson, "Matrix Analysis" (1985), Theorem 6.3.5

3. **Wire the Bridge**
   - Connect `weyl_error_budget_inf` to proven `weyl_eigenvalue_bound_real_n`
   - Thread symmetry assumptions through bridge
   - Prove error-budget lemma from Real Weyl + approximation bounds

### Files Modified

- `lakefile.lean` - Added mathlib dependency
- `lean-toolchain` - Aligned to mathlib version
- `IVI/RealSpecMathlib.lean` - Hermitian Weyl scaffold
- `IVI/RealSpec.lean` - Refactored to mathlib types
- `IVI/SafeFloat.lean` - Removed `sorry` in `abs`
- `IVI/Theorems.lean` - Removed unsafe Float axiom dependency
- `IVI/WeylBounds.lean` - Removed deprecated Float axioms

### Axiom Count

**Before Phase 1.1**: 42 axioms (21 core + 21 RealSpec)

**Current**: 42 axioms (21 core + 21 RealSpec)
- `lambdaHead` changed from axiom to def (but uses placeholder)
- `weyl_eigenvalue_bound_real_n` still axiomatized (target for proof)

**After Phase 1.1 Complete**: 41 axioms (20 core + 21 RealSpec)
- `weyl_eigenvalue_bound_real_n` proven → -1 axiom

---

## Phase 1.2: Operator Norm Bounds

### Status: 📋 Pending

**Target**: Prove `‖M‖ ≤ c·d` for entrywise bounded, sparse matrices.

**Tasks**:
- Define entrywise bound: `∀ i j, |M i j| ≤ c`
- Define sparsity: `∀ i, (row i).nnz ≤ d`
- Prove operator norm bound using mathlib
- **Impact**: Concrete bounds for runtime matrices

**Estimated Time**: ~3 days

---

## Phase 1.3: Power Iteration Convergence

### Status: 📋 Pending

**Target**: Prove power iteration properties for symmetric nonnegative matrices.

**Tasks**:
- Prove `powerIter_converges` using Perron-Frobenius
- Prove `powerIter_normalized` from normalization definition
- Prove `powerIter_nonneg_eigenvalue` from Perron-Frobenius
- **Impact**: -3 axioms

**Estimated Time**: ~1 week

---

## Phase 1.4: Lipschitz Continuity

### Status: 📋 Pending

**Target**: Prove graininess and entropy are Lipschitz continuous.

**Tasks**:
- Prove `graininess_lipschitz` using standard real analysis
- Prove `entropy_lipschitz` using standard real analysis
- **Impact**: -2 axioms

**Estimated Time**: ~3 days

---

## Phase 1 Summary

### Total Impact
- **Axioms Removed**: 7 (1 Weyl + 3 power iteration + 2 Lipschitz + 1 T2_v3)
- **Axioms After Phase 1**: 35 (14 core + 21 RealSpec)

### Timeline
- **Phase 1.1**: ~1 week (in progress)
- **Phase 1.2**: ~3 days
- **Phase 1.3**: ~1 week
- **Phase 1.4**: ~3 days
- **Total Phase 1**: ~3 weeks

### Next Milestone
Complete Phase 1.1 by proving `weyl_eigenvalue_bound_real_n` from mathlib.

---

## Build Status

- ✅ `lake build` succeeds
- ✅ All files compile
- ✅ No errors, only benign lints
- ✅ Demo runs: `lake exe ivi-demo`

---

## References

- **Strategy**: `PROOF_STRATEGY.md`
- **Roadmap**: `PROOF_ROADMAP.md`
- **Status**: `HONEST_STATUS.md`
- **Theorems**: `THEOREM_INDEX.md`
- **Math Proofs**: `IVI/RealSpecMathlib.lean`, `IVI/RealSpec.lean`

---

**Last Updated**: 2025-10-11  
**Current Focus**: Phase 1.1 - Hermitian Weyl proof
