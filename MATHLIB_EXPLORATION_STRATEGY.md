# Mathlib Exploration Strategy for lambdaHead_eq_opNorm

**Goal**: Prove that for symmetric matrices, `lambdaHead A = ‖A‖` (spectral radius = operator norm)

---

## What We Need to Find in Mathlib

### 1. Operator Norm for Matrices

**What we're looking for**:
- Definition of operator norm for matrices: `‖A‖ = sup { ‖Ax‖ / ‖x‖ : x ≠ 0 }`
- Already imported: `Mathlib.Analysis.CStarAlgebra.Matrix`
- Scope: `Matrix.Norms.L2Operator`

**Status**: ✅ Available (we're already using it in the axiom statement)

### 2. Spectral Radius Definition

**What we're looking for**:
- `spectralRadius A = sup { |λ| : λ is eigenvalue of A }`
- For Hermitian matrices, this should equal the operator norm

**Potential locations**:
- `Mathlib.Analysis.CStarAlgebra.Spectrum`
- `Mathlib.Topology.Algebra.Module.Basic`
- May need to define ourselves from eigenvalues

### 3. Spectral Theorem for Hermitian Matrices

**What we know**:
- ✅ `Matrix.IsHermitian.eigenvalues : Fin n → ℝ` exists
- ✅ Symmetric real matrices are Hermitian: `Matrix.isHermitian_iff_isSymmetric`

**What we need**:
- Theorem: For Hermitian A, `‖A‖ = max { |eigenvalues A i| : i }`
- This is the **key connection** we need

### 4. Reverse Triangle Inequality

**For Weyl inequality**:
- `|‖A + E‖ - ‖A‖| ≤ ‖E‖`
- Should be in `Mathlib.Analysis.Normed.Group.Basic`

---

## Strategy 1: Search Mathlib Documentation

### Online Resources
1. **Mathlib4 docs**: https://leanprover-community.github.io/mathlib4_docs/
2. **Search for**: "spectral radius", "operator norm", "Hermitian"
3. **Look in**:
   - `Mathlib.Analysis.CStarAlgebra.*`
   - `Mathlib.LinearAlgebra.Matrix.Spectrum`
   - `Mathlib.Analysis.NormedSpace.*`

### Key Theorems to Find
- `Matrix.IsHermitian.norm_eq_spectralRadius` (or similar)
- `spectralRadius_eq_sup_eigenvalues` (or similar)
- Connection between C*-algebra norm and matrix operator norm

---

## Strategy 2: Define Spectral Radius Ourselves

If mathlib doesn't have the direct connection, we can:

### Step 1: Define Spectral Radius
```lean
noncomputable def spectralRadius {n : Nat} [Fintype (Fin n)] [DecidableEq (Fin n)]
    (A : RealMatrixN n) (hA : Matrix.IsSymm A) : ℝ :=
  let hHerm : Matrix.IsHermitian A := Matrix.isHermitian_iff_isSymmetric.mpr hA
  Finset.univ.sup' (Finset.univ_nonempty (α := Fin n)) (fun i => |hHerm.eigenvalues i|)
```

**Note**: This is exactly our `lambdaHead` definition!

### Step 2: Prove spectralRadius = opNorm

This requires showing:
```lean
theorem spectralRadius_eq_opNorm {n : Nat} [Fintype (Fin n)] [DecidableEq (Fin n)] [Nonempty (Fin n)]
    (A : RealMatrixN n) (hA : Matrix.IsSymm A) :
    open scoped Matrix.Norms.L2Operator in
    spectralRadius A hA = ‖A‖
```

**Proof sketch**:
1. Use spectral theorem: A = QΛQ^T where Λ is diagonal with eigenvalues
2. Show ‖A‖ = ‖Λ‖ (norm preserved by orthogonal transformation)
3. Show ‖Λ‖ = max |λᵢ| (norm of diagonal matrix)
4. Conclude ‖A‖ = spectralRadius A

---

## Strategy 3: Use C*-Algebra Theory

Mathlib has C*-algebra infrastructure. For Hermitian elements:

### Key Facts
1. In a C*-algebra, Hermitian elements have real spectrum
2. For Hermitian a, `‖a‖ = spectralRadius(a)`
3. Matrices form a C*-algebra

### What to Search For
- `CStarAlgebra` instances for matrices
- Hermitian element properties in C*-algebras
- Connection to spectral radius

---

## Strategy 4: Incremental Proof Path

If we can't find the full theorem, build it incrementally:

### Lemma 1: Eigenvalue Bound
```lean
lemma eigenvalue_le_opNorm {n : Nat} [Fintype (Fin n)] [DecidableEq (Fin n)]
    (A : RealMatrixN n) (hA : Matrix.IsSymm A) (i : Fin n) :
    open scoped Matrix.Norms.L2Operator in
    let hHerm : Matrix.IsHermitian A := Matrix.isHermitian_iff_isSymmetric.mpr hA
    |hHerm.eigenvalues i| ≤ ‖A‖
```

**Proof idea**: If v is eigenvector with eigenvalue λ, then ‖Av‖ = |λ|‖v‖, so |λ| ≤ ‖A‖.

### Lemma 2: Supremum Bound
```lean
lemma sup_eigenvalues_le_opNorm {n : Nat} [Fintype (Fin n)] [DecidableEq (Fin n)] [Nonempty (Fin n)]
    (A : RealMatrixN n) (hA : Matrix.IsSymm A) :
    open scoped Matrix.Norms.L2Operator in
    lambdaHead A hA ≤ ‖A‖
```

**Proof**: Follows from Lemma 1 and properties of supremum.

### Lemma 3: Reverse Inequality
```lean
lemma opNorm_le_sup_eigenvalues {n : Nat} [Fintype (Fin n)] [DecidableEq (Fin n)] [Nonempty (Fin n)]
    (A : RealMatrixN n) (hA : Matrix.IsSymm A) :
    open scoped Matrix.Norms.L2Operator in
    ‖A‖ ≤ lambdaHead A hA
```

**Proof idea**: Use spectral decomposition. For any v, write v in eigenvector basis, show ‖Av‖ ≤ (max |λᵢ|)‖v‖.

### Main Theorem
```lean
theorem lambdaHead_eq_opNorm : lambdaHead A hA = ‖A‖ := by
  apply le_antisymm
  · exact sup_eigenvalues_le_opNorm A hA
  · exact opNorm_le_sup_eigenvalues A hA
```

---

## Strategy 5: Ask the Community

If stuck, we can:
1. Post on Lean Zulip (https://leanprover.zulipchat.com/)
2. Search Zulip archives for "spectral radius" or "operator norm"
3. Check if someone has already proven this

---

## Immediate Next Steps

### 1. Search Mathlib Docs (30 min)
- Look for `spectralRadius`, `IsHermitian.norm`, `CStarAlgebra`
- Check if the theorem already exists

### 2. If Found: Use It (1 hour)
- Import the right module
- Apply the theorem
- Remove axiom ✅

### 3. If Not Found: Build Incrementally (1-2 days)
- Prove Lemma 1: eigenvalue_le_opNorm
- Prove Lemma 2: sup_eigenvalues_le_opNorm
- Prove Lemma 3: opNorm_le_sup_eigenvalues
- Combine into main theorem

### 4. Document and Test (1 hour)
- Update AXIOM_ELIMINATION_LOG.md
- Update PHASE_1_STATUS.md
- Verify build succeeds
- Commit with clear message

---

## Expected Challenges

### Challenge 1: Eigenvector Basis
- Need to show eigenvectors form an orthonormal basis
- Mathlib should have this for Hermitian matrices
- Search for `IsHermitian.eigenvectorBasis`

### Challenge 2: Operator Norm Definition
- Need to work with the actual definition of ‖·‖
- May need to unfold `norm` and work with supremum
- Check `Mathlib.Analysis.NormedSpace.OperatorNorm`

### Challenge 3: Type Class Issues
- Operator norm requires inner product space structure
- Need to ensure all instances are properly set up
- May need explicit `open scoped` declarations

---

## Success Criteria

### Minimal Success
- [ ] Prove `lambdaHead_eq_opNorm` (even with `sorry` in sub-lemmas)
- [ ] Remove axiom from code
- [ ] Build succeeds

### Full Success
- [ ] Prove `lambdaHead_eq_opNorm` with complete proof
- [ ] All sub-lemmas proven
- [ ] No `sorry` statements
- [ ] Documentation updated
- [ ] -1 axiom (41 → 40)

---

## Timeline

- **Search phase**: 30 min - 1 hour
- **Implementation**: 1-2 days (depending on what we find)
- **Testing & documentation**: 1 hour
- **Total**: 1-3 days

---

## Resources

### Mathlib Documentation
- https://leanprover-community.github.io/mathlib4_docs/
- Search: "spectral", "Hermitian", "operator norm"

### Lean Zulip
- https://leanprover.zulipchat.com/
- #mathlib channel
- #new members channel

### References
- Horn & Johnson, "Matrix Analysis" (1985)
- Theorem: For Hermitian A, ‖A‖ = max |λᵢ|
- Standard result in functional analysis

---

**Next Action**: Start with Strategy 1 (search mathlib docs) for 30 minutes, then decide on Strategy 2 or 3.
