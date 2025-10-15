# Next Session Kickoff — October 14, 2025

**Last Session**: Completed proofs of `eigenvalue_le_opNorm` and `opNorm_le_sup_eigenvalues`.  
**Current Focus**: Shift from spectral equivalence to quantitative bounds.

---

## Snapshot

| Metric | Value |
|--------|-------|
| Axioms | 29 |
| Theorems | 122 |
| Build | ✅ |
| Phase 1 Progress | 3 / 8 milestones underway |

---

## Primary Objective

**Prove `operator_norm_bound`** in `IVI/RealSpecMathlib.lean`:

> Sparse (`rowSparsity M d`) and entrywise-bounded (`entrywiseBounded M c`) matrices have operator norm ≤ `c √(n * d)`.

This removes the remaining high-impact axiom in the spectral-norm section and supports later runtime guarantees.

---

## Session Plan

1. **Understand Definitions**  
   - Expand `entrywiseBounded` and `rowSparsity`.  
   - Identify existing lemmas (search `rg "rowSparsity"`).

2. **Derive Row Norm Bound**  
   - Lemma goal: `‖row i‖₂ ≤ c * √d`.  
   - Use cardinality bound + Cauchy-Schwarz.

3. **Bound `‖M v‖` Globally**  
   - Apply row bounds and sum of squares.  
   - Conclude `‖M v‖ ≤ c * √(n * d) * ‖v‖`.

4. **Wrap Up**  
   - Instantiate witness `norm_M := ‖M‖`.  
   - Provide inequality using `ContinuousLinearMap.opNorm_le_bound`.

5. **Verify & Document**  
   - Run `lake build IVI.RealSpecMathlib`.  
   - Update `STATUS.md`, `NEXT_WORK.md` if complete.  
   - Record blocking lemmas if not finished.

---

## Backup Tasks (if main goal finishes early)

1. Remove deprecated `weyl_eigenvalue_bound_real_mathlib`.  
2. Draft lemma list for `powerIter_converges`.  
3. Update `LEMMAS_NEEDED.md` with any gaps discovered.

---

## Useful Commands

```bash
# Focused build
lake build IVI.RealSpecMathlib

# Search for sparsity lemmas
rg "rowSparsity" -n

# Inspect definitions in Lean
#check entrywiseBounded
#check rowSparsity
```

---

## References

- `NEXT_WORK.md` — detailed plan for the operator norm bound.  
- `REMAINING_AXIOMS_ANALYSIS.md` — updated priority list.  
- `PRIORITY_1_PROGRESS.md` — summary of completed spectral work.
