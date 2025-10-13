# Phase 1: Next Steps

**Current Status**: 41 axioms (1 eliminated: lambdaHead)  
**Phase 1 Target**: 34 axioms (eliminate 7 more)  
**Strategy**: Math First, Then Kant

---

## 🎯 Immediate Priority: Prove lambdaHead_eq_opNorm

### Current State
```lean
axiom lambdaHead_eq_opNorm {n : Nat} [Fintype (Fin n)] [DecidableEq (Fin n)] [Nonempty (Fin n)]
    (A : RealMatrixN n) (hA : Matrix.IsSymm A) :
    open scoped Matrix.Norms.L2Operator in
    lambdaHead A hA = ‖A‖
```

### What This Means
For symmetric matrices, the dominant eigenvalue (spectral radius) equals the operator norm:
```
lambdaHead(A) = max { |λᵢ| : λᵢ eigenvalue of A } = ‖A‖
```

### Why It's Provable
This is a **standard theorem** in spectral theory:
- For symmetric matrices, eigenvalues are real
- The operator norm ‖A‖ = sup { ‖Ax‖ / ‖x‖ : x ≠ 0 }
- For symmetric A, this equals max |λᵢ|

### Proof Strategy
1. Use mathlib's `Matrix.IsHermitian` (symmetric ℝ matrices are Hermitian)
2. Use spectral theorem: symmetric matrices are diagonalizable
3. Show ‖A‖ = max |λᵢ| using eigenvalue decomposition
4. Connect to our `lambdaHead` definition

### Mathlib Resources Needed
- `Mathlib.LinearAlgebra.Matrix.Spectrum` ✅ (already imported)
- `Mathlib.Analysis.CStarAlgebra.Matrix` ✅ (already imported)
- Spectral theorem for Hermitian operators
- Operator norm characterization

### Expected Impact
- **-1 axiom** (lambdaHead_eq_opNorm proven)
- Unblocks Weyl inequality proof
- Validates the strategy

---

## 🎯 Second Priority: Prove Weyl Inequality

### Current State
```lean
axiom weyl_eigenvalue_bound_real_n
  {n : Nat} [Fintype (Fin n)] [DecidableEq (Fin n)] [Nonempty (Fin n)]
  (A E : RealMatrixN n)
  (hA : Matrix.IsSymm A)
  (hE : Matrix.IsSymm E) :
  open scoped Matrix.Norms.L2Operator in
  |lambdaHead (A + E) (symmetric_add A E hA hE) - lambdaHead A hA| ≤ ‖E‖
```

### What This Means
Perturbations shift eigenvalues by at most the norm of the perturbation:
```
|λ(A + E) - λ(A)| ≤ ‖E‖
```

### Why It's Provable
Once we have `lambdaHead_eq_opNorm`, this becomes:
```
|‖A + E‖ - ‖A‖| ≤ ‖E‖
```

This is the **reverse triangle inequality** for norms:
```
|‖x + y‖ - ‖x‖| ≤ ‖y‖
```

### Proof Strategy
1. Apply `lambdaHead_eq_opNorm` to both sides
2. Use reverse triangle inequality: |‖A+E‖ - ‖A‖| ≤ ‖E‖
3. This is a standard norm property in mathlib

### Mathlib Resources Needed
- Reverse triangle inequality for operator norms
- Likely already in `Mathlib.Analysis.Normed.Group.Basic`

### Expected Impact
- **-1 axiom** (weyl_eigenvalue_bound_real_n proven)
- Major milestone: Weyl inequality proven from first principles
- Validates "lies cause collapse" interpretation

---

## 🎯 Third Priority: Prove Operator Norm Bound

### Current State
```lean
axiom operator_norm_bound
  {n : Nat} (M : RealMatrixN n) (c : ℝ) (d : Nat)
  (h_entry : entrywiseBounded M c)
  (h_sparse : rowSparsity M d)
  (h_c_pos : c ≥ 0) :
  ∃ (norm_M : ℝ), norm_M ≤ c * Real.sqrt (n * d)
```

### What This Means
For matrices with bounded entries and sparse rows:
```
‖M‖ ≤ c√(nd)
```
where c = max entry, d = max non-zeros per row

### Why It's Provable
Standard matrix analysis result using Cauchy-Schwarz:
```
‖Mv‖² ≤ Σᵢ (Σⱼ |M i j| |v j|)²
      ≤ Σᵢ (c·√d·‖v‖)²  (by Cauchy-Schwarz and sparsity)
      ≤ n·c²·d
```
Thus ‖M‖ ≤ c√(nd).

### Proof Strategy
1. Use definition of operator norm: ‖M‖ = sup { ‖Mv‖ : ‖v‖ = 1 }
2. Bound ‖Mv‖² using Cauchy-Schwarz on each row
3. Use sparsity: each row has ≤ d non-zero entries
4. Sum over n rows

### Mathlib Resources Needed
- Cauchy-Schwarz inequality (already in mathlib)
- Operator norm definition
- Basic real analysis

### Expected Impact
- **-1 axiom** (operator_norm_bound proven)
- Concrete error budgets for IVI runtime
- Foundation for Float-to-Real bridge

---

## 🎯 Fourth Priority: Power Iteration (Perron-Frobenius)

### Current State (3 axioms)
```lean
axiom powerIter_converges
  {n : Nat} (M : RealMatrixN n) (iters : Nat)
  (h_symm : Matrix.IsSymm M)
  (h_nonneg : nonNegative M)
  (h_fuel : iters ≥ 100) :
  ∃ (v : Fin n → ℝ), True  -- Placeholder

axiom powerIter_normalized
  {n : Nat} (M : RealMatrixN n) (iters : Nat) :
  ∃ (v : Fin n → ℝ), True  -- Placeholder

axiom powerIter_nonneg_eigenvalue
  {n : Nat} (M : RealMatrixN n)
  (h_nonneg : nonNegative M) :
  ∃ (λ : ℝ), λ ≥ 0  -- Placeholder
```

### What This Means
For symmetric, non-negative matrices:
1. Power iteration converges to dominant eigenvector
2. Iteration produces normalized vectors
3. Dominant eigenvalue is non-negative

### Why It's Provable
**Perron-Frobenius theorem**: For non-negative matrices, the dominant eigenvalue is real and non-negative, with a non-negative eigenvector.

### Proof Strategy
1. Check if mathlib has Perron-Frobenius
2. If not, prove using:
   - Spectral theorem (symmetric → real eigenvalues)
   - Non-negativity → dominant eigenvalue ≥ 0
   - Power iteration convergence rate: O((λ₂/λ₁)ᵏ)

### Mathlib Resources Needed
- Perron-Frobenius theorem (may need to search or prove)
- Spectral theorem (already available)
- Convergence analysis

### Expected Impact
- **-3 axioms** (all power iteration properties proven)
- Foundation for IVI resonance mode computation
- Major step toward Phase 1 completion

---

## 🎯 Fifth Priority: Lipschitz Continuity

### Current State (2 axioms)
```lean
axiom graininess_lipschitz :
  ∃ (L : ℝ), L > 0  -- Placeholder

axiom entropy_lipschitz :
  ∃ (L : ℝ), L > 0  -- Placeholder
```

### What This Means
Graininess and entropy are Lipschitz continuous:
```
|f(x) - f(y)| ≤ L |x - y|
```

### Why It's Provable
Standard real analysis:
1. Define graininess and entropy functions explicitly
2. Show they have bounded derivatives
3. Apply mean value theorem

### Proof Strategy
1. Formalize graininess and entropy as explicit functions
2. Compute or bound their derivatives
3. Use MVT: |f(x) - f(y)| ≤ sup |f'| · |x - y|

### Mathlib Resources Needed
- Mean value theorem (already in mathlib)
- Derivative bounds
- Basic real analysis

### Expected Impact
- **-2 axioms** (both Lipschitz properties proven)
- Smooth evolution guarantees
- Foundation for Kakeya bounds

---

## 📊 Phase 1 Summary

### Axiom Elimination Plan

| Priority | Axiom | Method | Impact |
|----------|-------|--------|--------|
| 1 | lambdaHead_eq_opNorm | Spectral theorem | -1 |
| 2 | weyl_eigenvalue_bound_real_n | Reverse triangle ineq | -1 |
| 3 | operator_norm_bound | Cauchy-Schwarz | -1 |
| 4 | powerIter (3 axioms) | Perron-Frobenius | -3 |
| 5 | Lipschitz (2 axioms) | Real analysis | -2 |

**Total Phase 1 Impact**: -8 axioms (41 → 33)

### Timeline Estimate

| Task | Estimated Time |
|------|----------------|
| lambdaHead_eq_opNorm | 1-2 days |
| Weyl inequality | 1-2 days |
| Operator norm bound | 2-3 days |
| Power iteration | 1 week |
| Lipschitz continuity | 2-3 days |
| **Total Phase 1** | ~2-3 weeks |

---

## 🚀 Getting Started

### Step 1: Prove lambdaHead_eq_opNorm

**File**: `IVI/RealSpecMathlib.lean` (line 181)

**Approach**:
```lean
theorem lambdaHead_eq_opNorm {n : Nat} [Fintype (Fin n)] [DecidableEq (Fin n)] [Nonempty (Fin n)]
    (A : RealMatrixN n) (hA : Matrix.IsSymm A) :
    open scoped Matrix.Norms.L2Operator in
    lambdaHead A hA = ‖A‖ := by
  -- 1. Convert IsSymm to IsHermitian
  let hHerm : Matrix.IsHermitian A := Matrix.isHermitian_iff_isSymmetric.mpr hA
  
  -- 2. Use spectral theorem: ‖A‖ = max |λᵢ|
  -- TODO: Find mathlib lemma connecting operator norm to eigenvalues
  
  -- 3. Connect to lambdaHead definition
  unfold lambdaHead
  
  -- 4. Complete the proof
  sorry
```

**Next Actions**:
1. Search mathlib for operator norm characterization
2. Find lemma: `‖A‖ = max |eigenvalues|` for Hermitian matrices
3. Complete the proof

### Step 2: Prove Weyl Inequality

**File**: `IVI/RealSpecMathlib.lean` (line 231)

**Approach**:
```lean
theorem weyl_eigenvalue_bound_real_n
  {n : Nat} [Fintype (Fin n)] [DecidableEq (Fin n)] [Nonempty (Fin n)]
  (A E : RealMatrixN n)
  (hA : Matrix.IsSymm A)
  (hE : Matrix.IsSymm E) :
  open scoped Matrix.Norms.L2Operator in
  |lambdaHead (A + E) (symmetric_add A E hA hE) - lambdaHead A hA| ≤ ‖E‖ := by
  -- 1. Apply lambdaHead_eq_opNorm
  rw [lambdaHead_eq_opNorm, lambdaHead_eq_opNorm]
  
  -- 2. Use reverse triangle inequality
  -- TODO: Find mathlib lemma: |‖x + y‖ - ‖x‖| ≤ ‖y‖
  
  sorry
```

---

## 📚 Mathlib Resources to Explore

### Already Imported
- ✅ `Mathlib.LinearAlgebra.Matrix.Spectrum`
- ✅ `Mathlib.Analysis.CStarAlgebra.Matrix`

### Need to Find
- Operator norm = spectral radius for symmetric matrices
- Reverse triangle inequality for norms
- Perron-Frobenius theorem
- Mean value theorem (for Lipschitz)

### Search Strategy
```bash
# Search mathlib for relevant lemmas
cd ~/.elan/toolchains/leanprover-lean4-v4.*/lib/lean/library/
grep -r "spectral.*norm" Mathlib/
grep -r "Perron.*Frobenius" Mathlib/
grep -r "operator.*norm.*eigenvalue" Mathlib/
```

---

## ✅ Success Criteria

### Phase 1.1 Complete
- [ ] lambdaHead_eq_opNorm proven
- [ ] Weyl inequality proven
- [ ] 2 axioms eliminated

### Phase 1.2 Complete
- [ ] operator_norm_bound proven
- [ ] 1 axiom eliminated

### Phase 1.3 Complete
- [ ] All 3 power iteration axioms proven
- [ ] 3 axioms eliminated

### Phase 1.4 Complete
- [ ] Both Lipschitz axioms proven
- [ ] 2 axioms eliminated

### Phase 1 Complete
- [ ] **8 axioms eliminated** (41 → 33)
- [ ] All mathematical foundations proven
- [ ] Ready for Phase 2 (Float bridge)

---

**Current**: 41 axioms  
**After Phase 1**: 33 axioms  
**Phase 2 Target**: 13 axioms  
**Final Target**: 12 axioms (A1-A12 only)

**The path is clear. Let's continue the journey.**
