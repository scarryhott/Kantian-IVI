# Proof Strategy: Math First, Then Kant

**Core Principle**: Build mathematical foundations first, then extend to Kantian transcendental layer.

---

## Why This Order?

### 1. **Math proofs are easier**
- Standard spectral theory, matrix analysis, real analysis
- Well-established in mathlib
- Clear proof obligations, no philosophical interpretation needed

### 2. **Kant layer builds on math**
- Kantian axioms (A1-A12) are transcendental foundations
- The *computational* aspects (Weyl bounds, spectral invariants, power iteration) are pure mathematics
- Once math is proven, Kantian interpretation is a clean layer on top

### 3. **Separation of concerns**
- **Math layer** (`IVI/RealSpec.lean`, `IVI/RealSpecMathlib.lean`):
  - Prove in ℝ using mathlib
  - Weyl inequality, operator norms, spectral theory
  - No Kantian concepts needed
- **Runtime layer** (`IVI/WeylBounds.lean`, `IVI/Invariant.lean`):
  - Float approximations with error budgets
  - Bridge to ℝ proofs via `toRealMatN`
- **Kantian layer** (`IVI/Pure.lean`, `IVI/Theorems.lean`):
  - Transcendental axioms A1-A12
  - Theorems T1-T5 using proven math + Kantian axioms

---

## Implementation Roadmap

### Phase 1: Mathematical Foundations (Current Priority)

**Goal**: Prove all computational/analytic properties in ℝ using mathlib.

#### 1.1 Spectral Theory (Weyl Inequality)
- **File**: `IVI/RealSpecMathlib.lean`
- **Tasks**:
  - Define `lambdaHead {n} (A : RealMatrixN n)` for symmetric matrices
  - Prove `weyl_eigenvalue_bound_real_n`:
    - For `A.IsSymmetric`, `E.IsSymmetric`, `‖E‖ ≤ ε`
    - Show `|λ₁(A + E) - λ₁(A)| ≤ ε`
  - Use mathlib's Hermitian spectral theory
- **Impact**: Replaces 1 axiom with proven theorem

#### 1.2 Operator Norm Bounds
- **File**: `IVI/RealSpecMathlib.lean`
- **Tasks**:
  - Prove `‖M‖ ≤ c·d` for entrywise bounded, sparse matrices
  - Use mathlib's operator norm characterization
- **Impact**: Concrete bounds for runtime matrices

#### 1.3 Power Iteration Convergence
- **File**: `IVI/RealSpecMathlib.lean`
- **Tasks**:
  - Prove convergence for symmetric nonnegative matrices
  - Use Perron-Frobenius theorem from mathlib
  - Prove normalization and non-negativity properties
- **Impact**: Replaces 3 axioms (`powerIter_converges`, `powerIter_normalized`, `powerIter_nonneg_eigenvalue`)

#### 1.4 Lipschitz Continuity
- **File**: `IVI/RealSpecMathlib.lean`
- **Tasks**:
  - Prove graininess is Lipschitz continuous
  - Prove entropy is Lipschitz continuous
  - Use standard real analysis
- **Impact**: Replaces 2 axioms (`graininess_lipschitz`, `entropy_lipschitz`)

**Phase 1 Result**: ~7 axioms replaced with proven theorems, all in ℝ.

---

### Phase 2: Float-to-Real Bridge

**Goal**: Connect Float runtime to ℝ proofs with error budgets.

#### 2.1 Conversion Functions
- **File**: `IVI/RealSpec.lean`
- **Tasks**:
  - Implement `toRealMatN {n} : List (List Float) → RealMatrixN n`
  - Prove conversion preserves structure (addition, etc.)
  - Define error budget framework

#### 2.2 Error Budget Lemmas
- **File**: `IVI/RealSpec.lean`
- **Tasks**:
  - Prove `weyl_error_budget_inf`:
    - If ℝ-side Weyl holds with ε
    - And Float approximates ℝ within δ
    - Then Float-observed |Δλ| ≤ ε + δ
  - Similar lemmas for other properties

#### 2.3 SafeFloat Migration
- **File**: `IVI/SafeFloat.lean`, runtime files
- **Tasks**:
  - Replace all Float uses with SafeFloat
  - Remove deprecated Float axioms entirely
  - Ensure NaN/infinity safety

**Phase 2 Result**: Runtime validated against ℝ proofs, no unsafe Float axioms.

---

### Phase 3: Kantian Layer (After Math is Proven)

**Goal**: Extend proven math to Kantian transcendental framework.

#### 3.1 Kantian Axioms (By Design)
- **File**: `IVI/Pure.lean`
- **Status**: Keep as axioms (A1-A12)
- **Rationale**: These are transcendental foundations, not mathematical theorems

#### 3.2 Kantian Theorems (T1-T5)
- **File**: `IVI/Theorems.lean`
- **Tasks**:
  - T1 (Universality): Uses proven recognition logic + A1-A12
  - T2 (Liminal Persistence): Uses proven Weyl + Kakeya bounds + A11
  - T3 (Reciprocity): Uses proven symmetry + A7
  - T4 (Practical Aperture): Uses proven convergence + A9
  - T5 (Aesthetic Mediation): Uses proven judgment + A10

#### 3.3 Kakeya Bounds
- **File**: `IVI/Kakeya/Core.lean`
- **Tasks**:
  - Strengthen `grain_ok` from `Prop := True` to quantitative `≤ bound`
  - Use proven Lipschitz continuity from Phase 1
  - Prove T2_v3 (currently axiomatized)

**Phase 3 Result**: Kantian theorems proven from math + transcendental axioms.

---

## Current Status (2025-10-11)

### ✅ Completed
- Mathlib integrated (lakefile, toolchain aligned)
- `IVI/RealSpecMathlib.lean` created with mathlib types
- `IVI/RealSpec.lean` refactored to use `RealMatrixN n := Matrix (Fin n) (Fin n) ℝ`
- Hermitian (symmetric) Weyl statement prepared
- Float→ℝ bridge scaffolded (`toRealMatN`, `lambdaHead_float`, `weyl_error_budget_inf`)
- SafeFloat wrapper created (NaN/infinity guards)
- Unsafe Float axioms removed

### 🚧 In Progress (Phase 1.1)
- Define `lambdaHead` for symmetric matrices
- Prove `weyl_eigenvalue_bound_real_n` using mathlib Hermitian spectral theory

### 📋 Next Steps
1. **Finish Phase 1.1** (Weyl proof) — ~1 week
2. **Phase 1.2** (Operator norm bounds) — ~3 days
3. **Phase 1.3** (Power iteration) — ~1 week
4. **Phase 1.4** (Lipschitz continuity) — ~3 days
5. **Phase 2** (Float bridge) — ~2 weeks
6. **Phase 3** (Kantian layer) — ~1 month

**Total to full proof**: ~2-3 months focused work.

---

## Axiom Reduction Roadmap

| Phase | Axioms Removed | Axioms Remaining | Notes |
|-------|----------------|------------------|-------|
| **Current** | 0 | 42 (21 core + 21 RealSpec) | Starting point |
| **Phase 1** | -7 | 35 (14 core + 21 RealSpec) | Math proofs in ℝ |
| **Phase 2** | -21 | 14 (14 core) | RealSpec proven from mathlib |
| **Phase 3** | -1 | 13 (13 core) | T2_v3 proven |
| **Target** | -9 total | 12 (Kantian only) | A1-A12 remain by design |

**Final state**: 12 Kantian axioms (transcendental foundations) + 0 mathematical axioms.

---

## Why This Works

### Mathematical Clarity
- ℝ proofs are standard, well-understood
- Mathlib provides the tools
- No philosophical interpretation needed during proof

### Clean Separation
- **Math layer**: Pure mathematics, no Kant
- **Bridge layer**: Error budgets, Float↔ℝ
- **Kant layer**: Transcendental interpretation of proven math

### Maintainability
- Math proofs are stable (mathlib updates)
- Kantian layer is isolated
- Changes to Kant don't break math proofs

### Verifiability
- Math proofs are machine-checked
- Error budgets are quantitative
- Kantian claims rest on proven foundations

---

## Key Insight

**The computational aspects of the Kantian-IVI system are pure mathematics.**

- Spectral invariants, Weyl bounds, power iteration, operator norms — these are not Kantian concepts.
- They are mathematical tools used to *implement* Kantian ideas computationally.
- Therefore: prove the math first, then show how it realizes Kantian principles.

**This is the path to honest, verifiable, maintainable formal verification of transcendental philosophy.**

---

## References

- **Math proofs**: `IVI/RealSpecMathlib.lean`, `IVI/RealSpec.lean`
- **Runtime bridge**: `IVI/WeylBounds.lean`, `IVI/Invariant.lean`, `IVI/SafeFloat.lean`
- **Kantian layer**: `IVI/Pure.lean`, `IVI/Theorems.lean`
- **Current status**: `HONEST_STATUS.md`, `THEOREM_INDEX.md`
- **Roadmap**: `PROOF_ROADMAP.md`, `NEXT_STEPS.md`

---

**Status**: Phase 1.1 in progress (Hermitian Weyl proof)  
**Next milestone**: Replace Weyl axiom with mathlib proof (~1 week)
