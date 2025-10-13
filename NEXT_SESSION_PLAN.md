# Next Session Action Plan

**Date**: October 13, 2025  
**For**: Next coding session  
**Goal**: Prove lambdaHead_eq_opNorm (Step 1)

---

## 🎯 Primary Objective

**Prove**: `eigenvalue_le_opNorm` — Show that each eigenvalue |λᵢ| ≤ ‖A‖

**Impact**: Once proven, this immediately gives us `sup_eigenvalues_le_opNorm` (half of the main theorem)

---

## 📋 Step-by-Step Action Plan

### 1. Search for Eigenvector Property Lemma (30 min)

**Goal**: Find a lemma showing `A.mulVec (eigenvectorBasis i) = eigenvalues i • (eigenvectorBasis i)`

**Where to search**:
```bash
# Online mathlib docs
https://leanprover-community.github.io/mathlib4_docs/
Search: "IsHermitian eigenvector" or "eigenvectorBasis apply"

# In Lean
#check Matrix.IsHermitian.apply_eigenvectorBasis
#check Matrix.IsHermitian.eigenvectorBasis_apply
#check Matrix.IsHermitian.hasEigenvector
```

**Expected lemma name**:
- `Matrix.IsHermitian.apply_eigenvectorBasis`
- `Matrix.IsHermitian.eigenvectorBasis_apply`
- Something similar in `Mathlib/LinearAlgebra/Matrix/Spectrum.lean`

### 2. Search for Orthonormal Property Lemma (15 min)

**Goal**: Find a lemma showing `‖eigenvectorBasis i‖ = 1`

**Where to search**:
```bash
# In Lean
#check OrthonormalBasis.norm_eq_one
#check OrthonormalBasis.orthonormal
#check Orthonormal.norm_eq_one
```

**Expected**: This should be a direct property of `OrthonormalBasis`

### 3. Search for Operator Norm Bound Lemma (15 min)

**Goal**: Find a lemma showing `‖A.mulVec v‖ ≤ ‖A‖ * ‖v‖`

**Where to search**:
```bash
# In Lean
#check Matrix.norm_mulVec_le
#check norm_mulVec_le
#check ContinuousLinearMap.le_op_norm
```

**Expected**: This should be part of the operator norm definition

### 4. Attempt Proof of eigenvalue_le_opNorm (1-2 hours)

**Location**: `IVI/RealSpecMathlib.lean` after `lambdaHead_nonneg`

**Code to add**:
```lean
/--
Each eigenvalue of a symmetric matrix is bounded by its operator norm.

This is a key step toward proving lambdaHead_eq_opNorm.
-/
theorem eigenvalue_le_opNorm {n : Nat} [Fintype (Fin n)] [DecidableEq (Fin n)]
    (A : RealMatrixN n) (hA : Matrix.IsSymm A) (i : Fin n) :
    open scoped Matrix.Norms.L2Operator in
    let hHerm : Matrix.IsHermitian A := Matrix.isHermitian_iff_isSymmetric.mpr hA
    |hHerm.eigenvalues i| ≤ ‖A‖ := by
  open scoped Matrix.Norms.L2Operator
  let hHerm : Matrix.IsHermitian A := Matrix.isHermitian_iff_isSymmetric.mpr hA
  let v := hHerm.eigenvectorBasis i
  let λ := hHerm.eigenvalues i
  -- Step 1: A v = λ v (eigenvector property)
  have h_eigen : A.mulVec v = λ • v := sorry -- Use lemma from search
  -- Step 2: ‖v‖ = 1 (orthonormal)
  have h_norm : ‖v‖ = 1 := sorry -- Use lemma from search
  -- Step 3: Calculate
  calc |λ| = |λ| * ‖v‖ := by rw [h_norm, mul_one]
       _ = ‖λ • v‖ := by rw [norm_smul]
       _ = ‖A.mulVec v‖ := by rw [← h_eigen]
       _ ≤ ‖A‖ * ‖v‖ := sorry -- Use lemma from search
       _ = ‖A‖ := by rw [h_norm, mul_one]
```

### 5. Verify sup_eigenvalues_le_opNorm Compiles (15 min)

**Code to add** (right after eigenvalue_le_opNorm):
```lean
/--
The supremum of eigenvalues is bounded by the operator norm.
-/
theorem sup_eigenvalues_le_opNorm {n : Nat} [Fintype (Fin n)] [DecidableEq (Fin n)] [Nonempty (Fin n)]
    (A : RealMatrixN n) (hA : Matrix.IsSymm A) :
    open scoped Matrix.Norms.L2Operator in
    lambdaHead A hA ≤ ‖A‖ := by
  open scoped Matrix.Norms.L2Operator
  unfold lambdaHead
  apply Finset.sup'_le
  intro i _
  exact eigenvalue_le_opNorm A hA i
```

### 6. Test Build (5 min)

```bash
lake build IVI.RealSpecMathlib
```

**Expected**: Should compile if lemmas are found and used correctly

### 7. Document Progress (15 min)

Update `PRIORITY_1_PROGRESS.md`:
- Mark Step 1 as complete (or in progress with issues)
- Mark Step 2 as complete if it compiles
- Note any challenges encountered
- Update timeline estimate

---

## 🔍 Fallback Strategies

### If Eigenvector Lemma Not Found

**Option A**: Search Lean Zulip
```
https://leanprover.zulipchat.com/
Search: "eigenvector basis apply" or "IsHermitian eigenvalue"
```

**Option B**: Check mathlib source directly
```bash
# Look in the actual mathlib source files
find ~/.elan/toolchains -name "Spectrum.lean" -type f
# Read the file to find the lemma
```

**Option C**: Ask on Zulip
```
Post in #mathlib:
"I'm looking for a lemma that shows Matrix.IsHermitian.eigenvectorBasis 
satisfies the eigenvector property. Does this exist in mathlib?"
```

### If Orthonormal Lemma Not Found

**Should be straightforward**: `OrthonormalBasis` by definition has unit vectors

Try:
```lean
#check OrthonormalBasis.repr_apply_apply
#check Orthonormal.norm_eq_one
```

### If Operator Norm Lemma Not Found

**This is fundamental**: The operator norm is defined as `sup { ‖Av‖/‖v‖ : v ≠ 0 }`

Try:
```lean
#check ContinuousLinearMap.le_op_norm
#check LinearMap.le_op_norm
```

Or convert matrix to linear map:
```lean
#check Matrix.toLin
```

---

## 📊 Success Criteria

### Minimal Success ✅
- [ ] Found eigenvector property lemma
- [ ] Found orthonormal property lemma
- [ ] Found operator norm bound lemma
- [ ] Proof compiles with `sorry` in place

### Partial Success ✅✅
- [ ] Proved eigenvalue_le_opNorm completely
- [ ] sup_eigenvalues_le_opNorm compiles
- [ ] Build succeeds

### Full Success ✅✅✅
- [ ] Both theorems proven without `sorry`
- [ ] Build succeeds
- [ ] Documentation updated
- [ ] Ready for Step 3 (reverse direction)

---

## ⏱️ Time Estimates

| Task | Estimated Time | Priority |
|------|----------------|----------|
| Search eigenvector lemma | 30 min | High |
| Search orthonormal lemma | 15 min | High |
| Search operator norm lemma | 15 min | High |
| Attempt proof | 1-2 hours | High |
| Verify compilation | 15 min | Medium |
| Document progress | 15 min | Medium |
| **Total** | **2.5-3.5 hours** | |

---

## 🎯 Expected Outcomes

### Best Case (2-3 hours)
- All lemmas found quickly
- Proof compiles with minor adjustments
- Step 1 complete, Step 2 follows immediately
- 50% of lambdaHead_eq_opNorm proven

### Realistic Case (3-4 hours)
- Lemmas found with some searching
- Proof needs debugging
- Step 1 complete by end of session
- Clear path to Step 2

### Challenging Case (4+ hours)
- Some lemmas hard to find
- Need to ask on Zulip
- Proof structure correct but details tricky
- Progress made, continue next session

---

## 📝 Notes for Next Session

### Before Starting
1. Read `LEMMAS_NEEDED.md` — refresh on what we need
2. Read `PRIORITY_1_PROGRESS.md` — understand current status
3. Have mathlib docs open: https://leanprover-community.github.io/mathlib4_docs/

### During Session
1. Take notes on lemmas found
2. Document any issues encountered
3. If stuck > 30 min on one thing, move to next or ask for help

### After Session
1. Update `PRIORITY_1_PROGRESS.md`
2. Note any new insights in session summary
3. Plan next steps

---

## 🔗 Key Resources

### Documentation
- `LEMMAS_NEEDED.md` — What we're looking for
- `PRIORITY_1_PROGRESS.md` — Current status
- `MATHLIB_EXPLORATION_STRATEGY.md` — General strategies

### Mathlib
- Online docs: https://leanprover-community.github.io/mathlib4_docs/
- Zulip: https://leanprover.zulipchat.com/
- Source: `~/.elan/toolchains/.../lib/lean/library/`

### References
- Horn & Johnson, "Matrix Analysis" (1985), Theorem 5.6.9
- Standard result: For symmetric matrices, ‖A‖ = max |λᵢ|

---

## 🚀 Quick Start Commands

```bash
# Navigate to project
cd /Users/harryscott/Kantian-IVI

# Open the file to edit
# Add theorems after line 170 in IVI/RealSpecMathlib.lean

# Test build
lake build IVI.RealSpecMathlib

# If successful, build everything
lake build

# Check git status
git status

# When ready to commit
git add -A
git commit -m "Prove eigenvalue_le_opNorm and sup_eigenvalues_le_opNorm"
```

---

## 💡 Tips

### 1. Use #check Liberally
```lean
#check Matrix.IsHermitian.eigenvectorBasis
#check OrthonormalBasis
#check norm_smul
```

### 2. Look at Types
Understanding the types helps find the right lemmas:
```lean
#check (hHerm.eigenvectorBasis i : EuclideanSpace ℝ (Fin n))
#check (hHerm.eigenvalues i : ℝ)
```

### 3. Use calc for Clarity
The `calc` tactic makes proofs readable and easier to debug.

### 4. Don't Hesitate to Use sorry
Get the structure right first, fill in details later.

### 5. Ask for Help
If stuck > 1 hour, ask on Zulip. The community is helpful!

---

## ✅ Pre-Session Checklist

- [ ] Read this document
- [ ] Read `LEMMAS_NEEDED.md`
- [ ] Read `PRIORITY_1_PROGRESS.md`
- [ ] Have mathlib docs open
- [ ] Have Lean IDE ready
- [ ] Fresh coffee/tea ☕
- [ ] Ready to code!

---

**Created**: October 13, 2025  
**For**: Next session  
**Goal**: Prove Step 1 of lambdaHead_eq_opNorm  
**Estimated Time**: 2.5-3.5 hours  
**Confidence**: High — lemmas should exist in mathlib

**Let's prove some theorems! 🎯**
