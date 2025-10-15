# Priority 1 Progress — `lambdaHead_eq_opNorm`

**Date**: October 14, 2025  
**Status**: ✅ COMPLETE  
**Outcome**: `lambdaHead A hA = ‖A‖` is now a fully proven theorem in `IVI/RealSpecMathlib.lean`.

---

## Achievements

- Proved all helper lemmas:
  - `eigenvalue_le_opNorm`
  - `opNorm_le_sup_eigenvalues`
  - `operator_norm_bound` (quantitative bound via `mulVec_norm_sq_le`)
- Upgraded `lambdaHead_eq_opNorm` from axiom-backed skeleton to complete theorem.
- Used the results to certify `weyl_eigenvalue_bound_real_n` and remove the operator-norm axiom.
- Updated documentation and comments to reflect the new status.

**Build**: `lake build` passes (only benign lint warnings).

---

## Impact

- Spectral norm ↔ dominant eigenvalue equivalence established.
- Phase 1.2 (operator-norm bounds) now has its core theorem.
- Remaining spectral axioms reduced to quantitative/runtime statements.

---

## Next Focus

1. Begin Phase 1.3 by formalizing power iteration (convergence + normalization lemmas).
2. Prepare for Phase 1.4 Lipschitz properties once power iteration is settled.
3. Document how the spectral results integrate with runtime guarantees (`NEXT_WORK.md`).

---

## Notes

- Mathlib lemmas leveraged: Parseval (`OrthonormalBasis.sum_sq_norm_inner_right`), `Matrix.l2_opNorm_mulVec`, adjoint facts for Hermitian matrices.
- The project now has a clean spectral backbone ready for Phase 1.3.
