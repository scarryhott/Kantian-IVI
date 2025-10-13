# Next Work: Complete lambdaHead_eq_opNorm

**Goal**: Prove the two helper axioms to make lambdaHead_eq_opNorm a pure theorem

---

## Current Status

### What We Have ✅

```lean
theorem lambdaHead_eq_opNorm : lambdaHead A hA = ‖A‖ := by
  apply le_antisymm
  · exact sup_eigenvalues_le_opNorm A hA  -- ✅ PROVEN
  · exact opNorm_le_sup_eigenvalues A hA  -- ⏳ Axiom (TODO)
```

**Dependencies**:
1. `sup_eigenvalues_le_opNorm` — ✅ PROVEN (uses `eigenvalue_le_opNorm` axiom)
2. `opNorm_le_sup_eigenvalues` — ⏳ Axiom (needs proof)

### What We Need ⏳

Two helper axioms to prove:

#### 1. eigenvalue_le_opNorm
```lean
axiom eigenvalue_le_opNorm {n : Nat} [Fintype (Fin n)] [DecidableEq (Fin n)]
    (A : RealMatrixN n) (hA : Matrix.IsSymm A) (i : Fin n) :
    open scoped Matrix.Norms.L2Operator in
    let hHerm : Matrix.IsHermitian A := Matrix.isHermitian_iff_isSymmetric.mpr hA
    |hHerm.eigenvalues i| ≤ ‖A‖
```

**Proof strategy**: Use Rayleigh quotient and Cauchy-Schwarz

#### 2. opNorm_le_sup_eigenvalues
```lean
axiom opNorm_le_sup_eigenvalues {n : Nat} [Fintype (Fin n)] [DecidableEq (Fin n)] [Nonempty (Fin n)]
    (A : RealMatrixN n) (hA : Matrix.IsSymm A) :
    open scoped Matrix.Norms.L2Operator in
    ‖A‖ ≤ lambdaHead A hA
```

**Proof strategy**: Use spectral decomposition and Parseval's identity

---

## Proof Plan for eigenvalue_le_opNorm

### Approach

Use the fact that for an eigenvector v with eigenvalue λ:
- A v = λ v
- ‖v‖ = 1 (orthonormal basis)
- |λ| = ‖A v‖ ≤ ‖A‖ ‖v‖ = ‖A‖

### Lemmas Needed

1. **Eigenvector property**: 
   - `Matrix.IsHermitian.eigenvalues_eq` or similar
   - Shows relationship between A, v, and λ

2. **Orthonormal property**:
   - `hHerm.eigenvectorBasis.orthonormal.1 i : ‖hHerm.eigenvectorBasis i‖ = 1`
   - ✅ Already confirmed this works

3. **Operator norm bound**:
   - Need: `‖A.mulVec v‖ ≤ ‖A‖ * ‖v‖`
   - Search for matrix operator norm lemmas

### Implementation Steps

1. Convert eigenvector basis element to appropriate type
2. Apply eigenvector property
3. Use norm calculation
4. Apply operator norm bound
5. Simplify using ‖v‖ = 1

---

## Proof Plan for opNorm_le_sup_eigenvalues

### Approach

For any vector w:
- Decompose: w = Σᵢ cᵢ vᵢ (eigenvector basis)
- Apply A: A w = Σᵢ cᵢ λᵢ vᵢ
- Bound norm: ‖A w‖² = Σᵢ |cᵢ|² |λᵢ|² ≤ (max |λᵢ|)² Σᵢ |cᵢ|² = (max |λᵢ|)² ‖w‖²
- Therefore: ‖A‖ ≤ max |λᵢ| = lambdaHead A

### Lemmas Needed

1. **Orthonormal decomposition**:
   - How to express w in eigenvector basis
   - Likely `OrthonormalBasis.repr` or similar

2. **Parseval's identity**:
   - `‖w‖² = Σᵢ |cᵢ|²` for orthonormal basis
   - Should exist in mathlib

3. **Linearity of matrix multiplication**:
   - `A.mulVec (Σᵢ cᵢ vᵢ) = Σᵢ cᵢ (A.mulVec vᵢ)`
   - Standard property

4. **Operator norm characterization**:
   - `‖A‖ = sup { ‖A v‖ / ‖v‖ : v ≠ 0 }`
   - Or equivalent formulation

---

## Recommended Approach

### Option 1: Prove Both (Ambitious)
- Time estimate: 4-6 hours
- Requires deep dive into mathlib
- May encounter type issues

### Option 2: Prove eigenvalue_le_opNorm First (Pragmatic)
- Time estimate: 2-3 hours
- Simpler of the two
- Shows progress
- Leaves harder one for later

### Option 3: Document and Move On (Strategic)
- Time estimate: 30 minutes
- Focus on other Phase 1 priorities
- Come back when we have more experience
- Maintain momentum

---

## My Recommendation

**Option 2**: Prove `eigenvalue_le_opNorm` first

**Reasoning**:
1. It's the simpler of the two
2. Shows concrete progress
3. Builds confidence with mathlib
4. Reduces axiom count by 1
5. The harder proof can wait

**Timeline**:
- Next session: 2-3 hours on `eigenvalue_le_opNorm`
- If successful: Great! Move to next priority
- If stuck: Document issues, move on, come back later

---

## Alternative: Move to Priority 2

Since `lambdaHead_eq_opNorm` is already a theorem (just with helper axioms), we could:

1. **Declare victory** on Priority 1 structure
2. **Move to Priority 2**: Weyl inequality
3. **Come back** to prove helpers when we have more experience

**Pros**:
- Maintains momentum
- Diversifies work
- May learn techniques applicable to helpers

**Cons**:
- Leaves work incomplete
- Helper axioms remain

---

## Decision Point

**What would you like to do?**

A. **Prove eigenvalue_le_opNorm** (2-3 hours, concrete progress)
B. **Prove both helpers** (4-6 hours, complete the theorem)
C. **Move to Priority 2** (maintain momentum, come back later)
D. **Something else** (your call!)

---

**Current State**: Build succeeds, all documentation complete, ready for next phase

**Confidence**: High for Option A, Medium for Option B, High for Option C
