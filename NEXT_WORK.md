# Next Work: Power Iteration (Phase 1.3)

**Goal**: Start eliminating the power-iteration axioms in `IVI/RealSpecMathlib.lean`, beginning with the convergence statement.

---

## Where We Stand ✅

- `operator_norm_bound` is now a proven theorem (no axiom).
- All helper lemmas for `lambdaHead_eq_opNorm` are discharged.
- Remaining Phase 1 spectral axioms:
  1. `embedToMatrix` — structural (low priority)
  2. `powerIter_converges`, `powerIter_normalized`, `powerIter_nonneg_eigenvalue`
  3. Lipschitz axioms for graininess / entropy (Phase 1.4)

---

## Immediate Target

`powerIter_converges` (Phase 1.3): formalize that the normalized power iteration converges to the dominant eigenvector when the spectral gap assumptions hold.

---

## Kickoff Plan

1. **Collect Mathlib lemmas**  
   - eigenvalue/eigenvector properties for real symmetric (Hermitian) matrices  
   - spectral radius versus operator norm (already available)  
   - convergence criteria for sequences defined by linear operators

2. **Define the iteration**  
   - Formalize the normalized iterate `v_{k+1} := normalize (M · v_k)`  
   - Ensure normalization side-conditions are encoded without introducing partial functions

3. **State convergence hypotheses**  
   - Symmetric matrix with a unique maximal eigenvalue  
   - Non-zero initial vector with a component in the dominant eigen-direction

4. **Outline proof strategy**  
   - Express iterates in the eigenbasis  
   - Track ratio of dominant component versus others  
   - Use geometric decay to show convergence in norm

5. **Document blockers**  
   - Any missing lemmas (e.g. normalized vector estimates) go into `LEMMAS_NEEDED.md`

---

## Stretch Ideas

1. Characterize rate of convergence (linear, tied to spectral gap).  
2. Prepare supporting lemmas for `powerIter_nonneg_eigenvalue` (monotonicity for non-negative matrices).  
3. Map requirements onto later Phase 2 runtime bounds once the iteration is formalized.

---

Let’s begin by surveying existing mathlib support for power iteration and by drafting the iteration definitions. Once the preliminary lemmas are staged, we can attempt the convergence proof directly.***
