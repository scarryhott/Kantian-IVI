# Priority 1 Progress — `lambdaHead_eq_opNorm`

**Date**: October 14, 2025  
**Status**: ✅ COMPLETE  
**Outcome**: `lambdaHead A hA = ‖A‖` is now a fully proven theorem in `IVI/RealSpecMathlib.lean`.

---

## Achievements

- Proved both helper lemmas:
  - `eigenvalue_le_opNorm`
  - `opNorm_le_sup_eigenvalues`
- Upgraded `lambdaHead_eq_opNorm` from axiom-backed skeleton to complete theorem.
- Used the result to certify `weyl_eigenvalue_bound_real_n`.
- Updated documentation and comments to reflect the new status.

**Build**: `lake build` passes (only benign lint warnings).

---

## Impact

- Spectral norm ↔ dominant eigenvalue equivalence established.
- Phase 1.2 (operator-norm bounds) now has its core theorem.
- Remaining spectral axioms reduced to quantitative/runtime statements.

---

## Next Focus

1. Prove `operator_norm_bound` (quantitative estimate for sparse matrices).
2. Continue eliminating Phase 1 axioms (power iteration + Lipschitz properties).
3. Document how the new spectral results integrate with runtime guarantees.

See `NEXT_WORK.md` for the detailed plan on `operator_norm_bound`.

---

## Notes

- Mathlib lemmas leveraged: Parseval (`OrthonormalBasis.sum_sq_norm_inner_right`), `Matrix.l2_opNorm_mulVec`, adjoint facts for Hermitian matrices.
- The project now has a clean spectral backbone ready for Phase 1.3.
