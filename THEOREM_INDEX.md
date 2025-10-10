# Theorem Index

Complete list of proven theorems and lemmas (no `sorry` statements).

**Total: 31 proven items**

---

## IVI/Proofs.lean (13 lemmas)

All fully proven, no axioms or `sorry`.

1. **VWM_symm** - VWM operation is symmetric
2. **VWM_refl** - VWM operation is reflexive  
3. **compatible_iff_VWM** - Compatibility equivalent to VWM
4. **compatible_refl** - Compatibility is reflexive
5. **compatible_symm** - Compatibility is symmetric
6. **harmonize_singleton** - Singleton lists harmonize
7. **Resuperpose_singleton** - Resuperposition preserves singletons
8. **closedUnderIVI_nil** - Empty list is closed under IVI
9. **closedUnderIVI_cons** - Cons preserves closure
10. **compatible_refl_on** - Reflexive closure for compatibility
11. **harmonizeIfClosed** - Closed lists can be harmonized
12. **Encode_lawful_implies_compatible** - Lawful encoding implies compatibility
13. **Resuperpose_preserves_compatible** - Resuperposition preserves compatibility

---

## IVI/Theorems.lean (7 theorems)

Improved v2 versions with substantive proofs.

14. **T1_universality_v2** - Lawful recognition implies SVO representation exists
15. **T2_liminal_persistence_v2** - Grain safety preserved under direct bound (weakened)
16. **T2_liminal_persistence_reflexive** - Grain safety is reflexive
17. **T2_liminal_persistence_monotonic** - Grain safety preserved when graininess doesn't increase
18. **T3_reciprocity_topology_v2** - Reciprocity is symmetric
19. **T3_reciprocity_equivalence** - Reciprocity with reflexivity and transitivity forms equivalence
20. **T4_practical_aperture_v2** - Practical standpoint accessible through any thread
21. **T5_aesthetic_mediation_v2** - Reflective judgment always available
22. **T2_implies_nonCollapse** - T2 preservation implies non-collapse invariant

---

## IVI/Pure.lean (6 theorems)

DerivedAxioms namespace - constructive existence proofs.

23. **reciprocity_from_symmetric_relation** - Reciprocity follows from symmetric relation
24. **A7_reciprocity_constructive** - A7 can be constructed from symmetry
25. **A1_inner_time_structure** - Inner time ordering exists
26. **A1_inner_time_inhabited** - Inner time is inhabited
27. **A6_schematism_constructible** - Schematism is constructively possible
28. **A12_system_closure_necessary** - System closure is necessary

---

## IVI/Invariant.lean (3 theorems)

Power iteration convergence properties.

29. **powerIter_terminates** - Power iteration terminates within finite fuel
30. **spectralInvariant_welldefined** - Spectral invariant always produces a value
31. **lambdaVector_stable_implies_convergence** - Lambda stability implies convergence

---

## IVI/WeylBounds.lean (2 lemmas)

Matrix norm properties.

32. **matrixNormInf_nonneg** - Matrix norm is non-negative
33. **matrixNormInf_zero** - Zero matrix has zero norm

---

## Tautologies (5 - preserved for compatibility)

Original T1-T5 in IVI/Theorems.lean. Use v2 versions for substantive proofs.

- **T1_universality** - h → h (tautology)
- **T2_liminal_persistence** - h → h (tautology)
- **T3_reciprocity_topology** - Already in Reciprocity structure
- **T4_practical_aperture_unique** - x → x (tautology)
- **T5_aesthetic_mediation** - x → x (tautology)

---

## Axiomatized (require Real analysis or stronger assumptions)

These are axioms, not theorems:

### Kantian Axioms (12)
- A1-A12 in IVI/Pure.lean

### Analytic Axioms (12)
- 4 Weyl bounds (IVI/WeylBounds.lean)
- 3 Float arithmetic (IVI/WeylBounds.lean - deprecated)
- 3 Power iteration (IVI/Invariant.lean)
- 1 T2_v3 preservation (IVI/Theorems.lean)
- 1 Kakeya trivial (IVI/Kakeya/Core.lean)

### RealSpec Placeholders (21)
- IVI/RealSpec.lean - Would be imported from mathlib

### SafeFloat (2)
- IVI/SafeFloat.lean - Transitivity and addition for safe floats

---

## Verification

To verify this count:

```bash
# Count theorems (no sorry)
grep -r "^theorem " IVI/*.lean | grep -v "sorry" | wc -l

# Count axioms
./scripts/audit_axioms.sh
```

---

## Notes

- **Proven** = No `sorry`, no axioms used in proof
- **Axiomatized** = Declared as `axiom`, waiting for Real analysis
- **Tautology** = Trivial proof (h → h or x → x)
- **Deprecated** = Unsafe Float axioms, use SafeFloat instead
