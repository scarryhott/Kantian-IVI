# Remaining Axioms Analysis

**Date**: October 14, 2025 (Evening Session)  
**Current Axiom Count**: 28

---

## Axioms in RealSpecMathlib.lean

*Update (Oct 14): `eigenvalue_le_opNorm` and `opNorm_le_sup_eigenvalues` are now theorems, so they are omitted from the active list below.*

### 1. embedToMatrix (Line 30)
```lean
axiom embedToMatrix : RealMatrix → (Σ (n : Nat), Matrix (Fin n) (Fin n) Real)
```

**Purpose**: Bridge between project's `RealMatrix` (List(List ℝ)) and mathlib's `Matrix (Fin n) (Fin n) ℝ`

**Difficulty**: Hard (requires architectural decision)  
**Priority**: Low (can defer)  
**Estimated Time**: N/A (design decision, not proof)

---

### 2. weyl_eigenvalue_bound_real_mathlib (Line 57)
```lean
axiom weyl_eigenvalue_bound_real_mathlib
```

**Purpose**: Legacy Weyl bound for old type system

**Difficulty**: N/A (deprecated)  
**Priority**: Very Low (we have `weyl_eigenvalue_bound_real_n` proven!)  
**Action**: Should be removed or marked deprecated

---

### 3. powerIter_converges (Line 772)
```lean
axiom powerIter_converges
```

**Purpose**: Power iteration converges to dominant eigenvector

**Difficulty**: Hard  
**Priority**: Medium (important for runtime)  
**Estimated Time**: 5-7 hours  
**Strategy**: Requires spectral gap and convergence analysis

---

### 4. powerIter_normalized (Line 784)
```lean
axiom powerIter_normalized
```

**Purpose**: Power iteration maintains normalization

**Difficulty**: Easy-Medium  
**Priority**: Low (technical detail)  
**Estimated Time**: 1-2 hours  
**Strategy**: Direct calculation

---

### 5. powerIter_nonneg_eigenvalue (Line 793)
```lean
axiom powerIter_nonneg_eigenvalue
```

**Purpose**: Power iteration finds non-negative eigenvalue for non-negative matrices

**Difficulty**: Medium  
**Priority**: Low (follows from Perron-Frobenius)  
**Estimated Time**: 2-3 hours  
**Strategy**: Use Perron-Frobenius theorem

---

### 6. graininess_lipschitz (Line 831)
```lean
axiom graininess_lipschitz
```

**Purpose**: Graininess score is Lipschitz continuous

**Difficulty**: Medium  
**Priority**: Low (runtime property)  
**Estimated Time**: 2-3 hours  
**Strategy**: Direct calculation from definition

---

### 7. entropy_lipschitz (Line 841)
```lean
axiom entropy_lipschitz
```

**Purpose**: Entropy is Lipschitz continuous

**Difficulty**: Medium  
**Priority**: Low (runtime property)  
**Estimated Time**: 2-3 hours  
**Strategy**: Direct calculation from definition

---

## Recommended Next Steps

### Option 1: Retire the Deprecated Weyl Axiom (Cleanup)
Delete or fully deprecate `weyl_eigenvalue_bound_real_mathlib` now that the proven theorem is in place.

**Pros**:
- Reduces technical debt immediately
- Quick (15–20 minutes) and low-risk

**Cons**:
- No new mathematical insight
- Minor impact on overall plan

---

### Option 2: Prep for Power Iteration (Exploratory)
Audit the hypotheses needed for `powerIter_converges` and `powerIter_normalized`, listing required lemmas.

**Pros**:
- Clarifies Phase 1.3 scope
- Guides future lemma search

**Cons**:
- No immediate reduction in axiom count
- Still requires follow-up proof sessions

---

## My Recommendation

Start with **Option 2**: gather the lemmas required for power iteration and draft the iteration definition. Use any spare time for the cleanup task (Option 1).

---

## Summary Table

| # | Axiom | Difficulty | Priority | Time | Impact |
|---|-------|------------|----------|------|--------|
| 1 | embedToMatrix | N/A | Low | N/A | Design |
| 2 | weyl_..._mathlib | N/A | Very Low | 15min | Cleanup |
| 3 | powerIter_converges | Hard | **High** | 5-7h | **High** |
| 4 | powerIter_normalized | Easy-Medium | Medium | 1-2h | Medium |
| 5 | powerIter_nonneg_eigenvalue | Medium | Medium | 2-3h | Medium |
| 6 | graininess_lipschitz | Medium | Low | 2-3h | Low |
| 7 | entropy_lipschitz | Medium | Low | 2-3h | Low |

**Total estimated time to prove all**: ~12-20 hours

---

**Created**: October 13, 2025, 7:40 PM  
**Purpose**: Guide next work session  
**Status**: Ready for decision
