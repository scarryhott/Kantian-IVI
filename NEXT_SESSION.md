# Next Session Kickoff — October 15, 2025

**Last Session**: Eliminated `operator_norm_bound` and finished all helper lemmas for `lambdaHead_eq_opNorm`.  
**Current Focus**: Launch Phase 1.3 — power iteration convergence.

---

## Snapshot

| Metric | Value |
|--------|-------|
| Axioms | 28 |
| Theorems | 123 |
| Build | ✅ |
| Phase 1 Progress | 3 / 8 milestones complete |

---

## Primary Objective

Define the normalized power-iteration step and gather the lemmas needed to prove `powerIter_converges`.

---

## Agenda

1. **Survey mathlib tools**  
   - Eigenbasis manipulation for Hermitian matrices  
   - Convergence lemmas for sequences of vectors  
   - Normalization helpers (`normalize`, `WithLp`)  

2. **Define the iteration**  
   - Implement `powerIterStep M v := normalize (Matrix.toEuclideanCLM M v)` (with safeguards for zero vectors)  
   - Set up iterates via `Nat.iterate` or explicit recursion  

3. **Document missing lemmas**  
   - Geometric decay for non-dominant eigencomponents  
   - Continuity of normalization  
   - Any needed spectral-gap inequalities  

4. **Update project trackers**  
   - `LEMMAS_NEEDED.md` for pending lemmas  
   - `PRIORITY_1_PROGRESS.md` / session notes with findings  

---

## Backup Tasks (if time remains)

1. Retire `weyl_eigenvalue_bound_real_mathlib` (legacy axiom).  
2. Outline `powerIter_normalized` and `powerIter_nonneg_eigenvalue`.  
3. Sketch how power iteration feeds into Phase 2 runtime analysis.

---

## Useful Commands

```bash
# Build entire project
lake build

# Search existing power-iteration references
rg "powerIter" -n IVI

# Inspect core lemmas
#check Matrix.toEuclideanCLM
#check OrthonormalBasis
```
