# Remaining Axioms Analysis

**Date**: October 13, 2025 (Evening Session)  
**Current Axiom Count**: 30

---

## Axioms in RealSpecMathlib.lean

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

### 3. eigenvalue_le_opNorm (Line 195) ⭐
```lean
axiom eigenvalue_le_opNorm {n : Nat} [Fintype (Fin n)] [DecidableEq (Fin n)]
    (A : RealMatrixN n) (hA : Matrix.IsSymm A) (i : Fin n) :
    |hHerm.eigenvalues i| ≤ ‖A‖
```

**Purpose**: Each eigenvalue bounded by operator norm (helper for lambdaHead_eq_opNorm)

**Difficulty**: Medium  
**Priority**: High (completes lambdaHead_eq_opNorm)  
**Estimated Time**: 2-3 hours  
**Strategy**: Rayleigh quotient + Cauchy-Schwarz

---

### 4. opNorm_le_sup_eigenvalues (Line 232) ⭐
```lean
axiom opNorm_le_sup_eigenvalues {n : Nat} [Fintype (Fin n)] [DecidableEq (Fin n)] [Nonempty (Fin n)]
    (A : RealMatrixN n) (hA : Matrix.IsSymm A) :
    ‖A‖ ≤ lambdaHead A hA
```

**Purpose**: Operator norm bounded by supremum (helper for lambdaHead_eq_opNorm)

**Difficulty**: Hard  
**Priority**: High (completes lambdaHead_eq_opNorm)  
**Estimated Time**: 3-4 hours  
**Strategy**: Spectral decomposition + Parseval's identity

---

### 5. operator_norm_bound (Line 471)
```lean
axiom operator_norm_bound
  {n : Nat} (M : RealMatrixN n) (c : ℝ) (d : Nat)
  (h_entry : entrywiseBounded M c)
  (h_sparse : rowSparsity M d)
  (h_c_pos : c ≥ 0) :
  ∃ (norm_M : ℝ), norm_M ≤ c * Real.sqrt (n * d)
```

**Purpose**: Concrete bound on operator norm for sparse, bounded matrices

**Difficulty**: Medium-Hard  
**Priority**: Medium (useful for runtime bounds)  
**Estimated Time**: 3-4 hours  
**Strategy**: Use Cauchy-Schwarz and row-by-row analysis

---

### 6. powerIter_converges (Line 772)
```lean
axiom powerIter_converges
```

**Purpose**: Power iteration converges to dominant eigenvector

**Difficulty**: Hard  
**Priority**: Medium (important for runtime)  
**Estimated Time**: 5-7 hours  
**Strategy**: Requires spectral gap and convergence analysis

---

### 7. powerIter_normalized (Line 784)
```lean
axiom powerIter_normalized
```

**Purpose**: Power iteration maintains normalization

**Difficulty**: Easy-Medium  
**Priority**: Low (technical detail)  
**Estimated Time**: 1-2 hours  
**Strategy**: Direct calculation

---

### 8. powerIter_nonneg_eigenvalue (Line 793)
```lean
axiom powerIter_nonneg_eigenvalue
```

**Purpose**: Power iteration finds non-negative eigenvalue for non-negative matrices

**Difficulty**: Medium  
**Priority**: Low (follows from Perron-Frobenius)  
**Estimated Time**: 2-3 hours  
**Strategy**: Use Perron-Frobenius theorem

---

### 9. graininess_lipschitz (Line 831)
```lean
axiom graininess_lipschitz
```

**Purpose**: Graininess score is Lipschitz continuous

**Difficulty**: Medium  
**Priority**: Low (runtime property)  
**Estimated Time**: 2-3 hours  
**Strategy**: Direct calculation from definition

---

### 10. entropy_lipschitz (Line 841)
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

### Option 1: Complete lambdaHead_eq_opNorm (High Priority)
Prove axioms #3 and #4 to make lambdaHead_eq_opNorm a pure theorem.

**Pros**:
- Completes major theorem
- Reduces axiom count by 2
- High impact

**Cons**:
- Technically challenging
- May take 5-7 hours total

---

### Option 2: Prove powerIter_normalized (Quick Win)
Tackle axiom #7 for a quick, easy proof.

**Pros**:
- Easy proof
- Quick win (1-2 hours)
- Builds confidence

**Cons**:
- Low priority
- Less impactful

---

### Option 3: Remove Deprecated Axiom (Cleanup)
Remove or mark axiom #2 as deprecated since we have the new version.

**Pros**:
- Reduces axiom count by 1
- Clean up codebase
- Very quick (15 minutes)

**Cons**:
- Not a "real" proof
- Minimal learning value

---

### Option 4: Explore and Document (Strategic)
Don't prove anything yet, but explore mathlib for lemmas needed for axioms #3-5.

**Pros**:
- Low pressure
- Educational
- May find shortcuts

**Cons**:
- No immediate progress on axiom count

---

## My Recommendation

**Start with Option 3** (remove deprecated axiom) for a quick win, then **move to Option 4** (explore and document) to prepare for future work.

**Reasoning**:
1. We've had a long, productive session (6+ hours)
2. A quick win maintains momentum
3. Exploration prepares for next session
4. Avoid burnout from another long proof session

**Alternative**: If you're feeling energized, go straight for **Option 1** (complete lambdaHead_eq_opNorm).

---

## Summary Table

| # | Axiom | Difficulty | Priority | Time | Impact |
|---|-------|------------|----------|------|--------|
| 1 | embedToMatrix | N/A | Low | N/A | Design |
| 2 | weyl_..._mathlib | N/A | Very Low | 15min | Cleanup |
| 3 | eigenvalue_le_opNorm | Medium | **High** | 2-3h | **High** |
| 4 | opNorm_le_sup_eigenvalues | Hard | **High** | 3-4h | **High** |
| 5 | operator_norm_bound | Medium-Hard | Medium | 3-4h | Medium |
| 6 | powerIter_converges | Hard | Medium | 5-7h | Medium |
| 7 | powerIter_normalized | Easy-Medium | Low | 1-2h | Low |
| 8 | powerIter_nonneg_eigenvalue | Medium | Low | 2-3h | Low |
| 9 | graininess_lipschitz | Medium | Low | 2-3h | Low |
| 10 | entropy_lipschitz | Medium | Low | 2-3h | Low |

**Total estimated time to prove all**: ~25-35 hours

---

**Created**: October 13, 2025, 7:40 PM  
**Purpose**: Guide next work session  
**Status**: Ready for decision
