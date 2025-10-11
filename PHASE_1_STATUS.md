# Phase 1 Status: Mathematical Foundations

**Strategy**: Math First, Then Kant (see `PROOF_STRATEGY.md`)

**Goal**: Prove all computational/analytic properties in ℝ using mathlib.

---

## Phase 1.1: Spectral Theory (Weyl Inequality)

### Current Status: 🚧 In Progress

**Target**: Replace Weyl axiom with mathlib-backed proof.
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

### Status: ✅ Scaffolded

**Target**: Prove `‖M‖ ≤ c√(nd)` for entrywise bounded, sparse matrices.

**What's Done**:
- ✅ Defined `entrywiseBounded`: `∀ i j, |M i j| ≤ c`
- ✅ Defined `rowSparsity`: `∀ i, (row i).nnz ≤ d`
- ✅ Axiomatized `operator_norm_bound`: `‖M‖ ≤ c√(nd)`
- ✅ Documented application to IVI resonance matrices

**What's Left**:
- 🚧 Prove using Gershgorin circle theorem or direct norm calculation
- 🚧 Replace axiom with theorem

**Impact**: Concrete error budgets for Float computations

**Estimated Time**: ~3 days

---

## Phase 1.3: Power Iteration Convergence

### Status: ✅ Scaffolded

**Target**: Prove power iteration properties for symmetric nonnegative matrices.

**What's Done**:
- ✅ Defined `nonNegative`: `∀ i j, M i j ≥ 0`
- ✅ Axiomatized `powerIter_converges` (Perron-Frobenius)
- ✅ Axiomatized `powerIter_normalized` (normalization by construction)
- ✅ Axiomatized `powerIter_nonneg_eigenvalue` (λ₁ ≥ 0)
- ✅ Documented application to IVI resonance modes

**What's Left**:
- 🚧 Prove using Perron-Frobenius theorem from mathlib
- 🚧 Replace 3 axioms with theorems

**Impact**: -3 axioms when proven

**Estimated Time**: ~1 week

---

## Phase 1.4: Lipschitz Continuity

### Status: ✅ Scaffolded

**Target**: Prove graininess and entropy are Lipschitz continuous.

**What's Done**:
- ✅ Axiomatized `graininess_lipschitz`
- ✅ Axiomatized `entropy_lipschitz`
- ✅ Documented application to Kakeya bounds and liminal persistence (A11)

**What's Left**:
- 🚧 Prove using standard real analysis
- 🚧 Replace 2 axioms with theorems

**Impact**: -2 axioms when proven

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
