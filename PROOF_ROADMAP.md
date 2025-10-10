# Proof Completion Roadmap for Kantian-IVI

**Status**: The project compiles cleanly but relies on axiomatic foundations rather than derived proofs. This roadmap identifies gaps and proposes a path to full proof completeness.

---

## Executive Summary

### Current State
- ✅ **Compiles**: No `sorry` statements, builds successfully
- ⚠️ **Axiomatic**: Core theorems assert `True` or use tautologies (`h → h`)
- ⚠️ **Runtime checks**: Convergence/invariants verified computationally, not proven
- ⚠️ **Missing bounds**: Analytic inequalities (Lipschitz, spectral) not formally established

### What "Proof-Complete" Means
1. **Axiom layer**: Clearly distinguish permanent axioms from derivable theorems
2. **Theorems**: Replace tautologies with substantive derivations
3. **Analytic bounds**: Prove Kakeya contract inequalities from first principles
4. **Convergence**: Formally prove fixed-point and invariant properties
5. **Bridge completeness**: Prove Kant ⇄ IVI correspondence (soundness, completeness, minimality)

---

## Priority Levels

- **P0 (Critical)**: Closes the main verification loop; required for soundness
- **P1 (High)**: Strengthens core guarantees; needed for completeness claims
- **P2 (Medium)**: Improves rigor but system works without them
- **P3 (Low)**: Nice-to-have; philosophical or aesthetic improvements

---

## File-by-File Completion Checklist

### 1. `IVI/Pure.lean` — Kantian Axioms (A1–A12)

**Current State**: All axioms assert `True` via `trivial`. These are foundational assumptions, not derived results.

**Decision Required**: Which axioms are **permanent foundations** vs. **derivable from more primitive principles**?

#### Proposed Classification

**Permanent Axioms** (accept as foundational):
- **A3**: Unity of apperception — this is the transcendental ground
- **A4**: Noumenal limit — definitional boundary
- **A11**: Verification without collapse — meta-principle about IVI itself

**Potentially Derivable** (candidates for proof):
- **A1**: Inner time ordering
  - **P1**: Derive from `InnerTime` typeclass structure + monotonicity
  - **Proof sketch**: Show `InnerTime.before` is transitive and total
  
- **A2**: Categories bind judgment
  - **P1**: Derive from the `Category` structure in `IVI/Core.lean`
  - **Proof sketch**: Show every `SVO` construction involves categorical synthesis
  
- **A5**: Regulative ideas
  - **P2**: Derive from system closure properties
  - **Proof sketch**: Show `System.recs` convergence requires regulative unity
  
- **A6**: Schematism possible
  - **P1**: Derive from `SchematismEvidence` + `Will.selectSchema`
  - **Proof sketch**: Construct explicit schema-to-intuition bridge
  
- **A7**: Reciprocity (Community)
  - **P0**: Already constructive! Just needs witness extraction
  - **Action**: Prove `Reciprocity.symm` is derivable from resonance symmetry
  
- **A8**: Synthetic a priori validity
  - **P2**: Derive from `harmonize` + `VWM` closure
  - **Proof sketch**: Show closed IVI systems yield synthetic judgments
  
- **A9**: Practical aperture
  - **P3**: Keep as axiom (opens normative dimension)
  
- **A10**: Reflective judgment
  - **P2**: Derive from `Will.selectSchema` when no determinate rule applies
  
- **A12**: Demand for system
  - **P1**: Derive from `System.closedUnderIVI` necessity
  - **Proof sketch**: Show IVI verification requires systematic unity

#### Action Items

- [ ] **P0**: Document which axioms are permanent vs. derivable in `IVI/Pure.lean` header
- [ ] **P1**: Prove A7 (Reciprocity) from `communityPredicateA` symmetry
- [ ] **P1**: Prove A1 (Inner time) from `InnerTime` typeclass properties
- [ ] **P1**: Prove A6 (Schematism) from `SchematismEvidence` construction

---

### 2. `IVI/Theorems.lean` — Named Theorems (T1–T5)

**Current State**: All theorems are trivial tautologies or restatements.

#### T1: Universality of IVI
```lean
theorem T1_universality {α τ} [InnerTime τ] (rec : Recognition α τ) (x : α) :
  lawful rec x → lawful rec x := by intro h; exact h
```

**Gap**: This is a tautology. Should prove something substantive.

**P1 Proposal**: Prove that every domain verification factors through IVI operations:
```lean
theorem T1_universality {α τ} [InnerTime τ] (rec : Recognition α τ) (x : α) :
  lawful rec x → ∃ (svo : SVO α), svo.repr = x ∧ rec.rule.applies x
```

**Proof sketch**: 
- Use `Recognition.sound` to extract the rule witness
- Construct `SVO` from `x` via domain embedding
- Show `lawful` implies rule application

---

#### T2: Liminal Persistence (Non-Collapse)
```lean
theorem T2_liminal_persistence (cfg : ICollapseCfg) (nodes : List DomainNode) :
  cfg.grainSafe nodes → cfg.grainSafe nodes := by intro h; exact h
```

**Gap**: Tautology. Should prove non-collapse is preserved across steps.

**P0 Proposal**: Prove that IVI steps preserve grain safety:
```lean
theorem T2_liminal_persistence 
  (cfg : ICollapseCfg) (stepE : StepE) 
  (doms : List DomainSignature) (nodes : List DomainNode)
  (h : cfg.grainSafe nodes) :
  let (doms', nodes') := stepE doms nodes
  cfg.grainSafe nodes'
```

**Proof sketch**:
- Use `KakeyaBounds.buildContract` to extract grain bound
- Show `contract.grain_ok` implies `grainSafe` preservation
- Requires proving the Kakeya grain inequality (see §4 below)

---

#### T3: Reciprocity Topology
```lean
theorem T3_reciprocity_topology {α} (R : Reciprocity α) :
  (∀ {x y}, R.relates x y → R.relates y x) := by intro x y hxy; exact R.symm hxy
```

**Status**: ✅ This one is actually correct! It's just extracting the symmetry axiom.

**P2 Enhancement**: Prove stronger topological properties:
```lean
-- Reciprocity induces an equivalence relation when combined with reflexivity/transitivity
theorem reciprocity_generates_topology {α} (R : Reciprocity α) 
  (refl : ∀ x, R.relates x x) 
  (trans : ∀ {x y z}, R.relates x y → R.relates y z → R.relates x z) :
  -- R is an equivalence relation
  True  -- placeholder for equivalence class construction
```

---

#### T4: Practical Aperture Uniqueness
```lean
theorem T4_practical_aperture_unique {τ : Type u} [InnerTime τ] (s : Subject τ) :
  FromIThink.Thread.practicalStandpoint_proof (FromIThink.canonical τ s) :=
  FromIThink.Thread.practicalStandpoint_proof (FromIThink.canonical τ s)
```

**Gap**: This just restates the same term twice.

**P3 Proposal**: Prove uniqueness of the practical standpoint:
```lean
theorem T4_practical_aperture_unique {τ : Type u} [InnerTime τ] (s : Subject τ)
  (t₁ t₂ : FromIThink.Thread τ s) :
  t₁.practicalStandpoint t₁.iThinkWitness = t₂.practicalStandpoint t₂.iThinkWitness
```

**Note**: This may require strengthening the axiom layer or accepting it as foundational.

---

#### T5: Aesthetic Mediation
```lean
theorem T5_aesthetic_mediation {τ : Type u} [InnerTime τ] (s : Subject τ) :
  FromIThink.Thread.reflectiveJudgment (FromIThink.canonical τ s) :=
  FromIThink.Thread.reflectiveJudgment (FromIThink.canonical τ s)
```

**Gap**: Same restatement issue as T4.

**P2 Proposal**: Prove reflective judgment fills gaps in determinate cognition:
```lean
theorem T5_aesthetic_mediation {τ : Type u} [InnerTime τ] (s : Subject τ)
  (svo : SVO α) (recs : List (Recognition α τ))
  (h : ∀ rec ∈ recs, ¬rec.rule.applies svo.repr) :
  -- When no determinate rule applies, reflective judgment provides IVI
  ∃ (schema : SchemaId), Will.selectSchema {} svo = schema
```

---

### 3. `IVI/Invariant.lean` — Spectral Invariants & Convergence

**Current State**: Convergence is **runtime-checked** via `runUntilConverged`, not proven.

#### Critical Gaps

**P0**: Prove power iteration convergence
```lean
theorem powerIter_converges 
  (M : List (List Float)) 
  (h_symmetric : isSymmetric M)
  (h_nonneg : ∀ i j, 0 ≤ M[i][j])
  (iters : Nat) (eps : Float) :
  let (lam, v) := powerIter M iters eps
  -- lam approximates the dominant eigenvalue within eps
  ∃ (lam_true : Real), |lam - lam_true| ≤ eps
```

**Proof approach**: 
- Use Perron-Frobenius theorem (for nonnegative matrices)
- Show iteration contracts the error exponentially
- May require importing Real analysis or accepting as axiom

---

**P1**: Prove lambda-vector stability implies non-collapse
```lean
theorem lambdaVector_stable_implies_nonCollapse
  (W : Weighting) (cfg : NonCollapseCfg) 
  (nodes : List DomainNode)
  (h : lambdaHeadStable (lambdaVector cfg.levels W nodes) cfg.epsLambda) :
  nonCollapsePredicateA W cfg nodes nodes
```

**Proof sketch**:
- Show `lambdaHeadStable` implies self-similarity across scales
- Connect to `surpriseNonDecreasing` via entropy bounds
- Use existing `nonCollapse_of_heads_and_entropy` lemma

---

**P1**: Prove community predicate from reciprocity guard
```lean
theorem community_from_reciprocity
  (W : Weighting) (τ : Float) (R : Reciprocity Nat)
  (nodes : List DomainNode)
  (h : ∀ i j, i < nodes.length → j < nodes.length → 
       R.relates i j → τ ≤ (weightsFrom W nodes)[i][j]) :
  communityPredicateA W τ (some R) nodes
```

**Status**: Partially done via `community_from_guard`, needs strengthening.

---

### 4. `IVI/KakeyaBounds.lean` — Analytic Inequalities

**Current State**: Contracts are assembled from measured deltas, but **Lipschitz bounds are not proven**.

#### Critical Gaps

**P0**: Prove grain Lipschitz bound
```lean
theorem grain_lipschitz_bound
  (W : Weighting) (stepE : StepE)
  (doms : List DomainSignature) (nodes : List DomainNode)
  (L_grain : Float)  -- Lipschitz constant
  (h_lip : ∀ n₁ n₂ ∈ nodes, 
           |graininessScore (weightsFrom W [n₁]) - 
            graininessScore (weightsFrom W [n₂])| ≤ 
           L_grain * |n₁.state.time.theta - n₂.state.time.theta|) :
  let (doms', nodes') := stepE doms nodes
  let grainDiff := graininessScore (weightsFrom W nodes') - 
                   graininessScore (weightsFrom W nodes)
  |grainDiff| ≤ L_grain * θ_max
```

**Proof approach**:
- Derive from Laplacian smoothness properties
- Use `Harmonics.graininessScore` definition
- Connect to `DeltaPack.Δgrain` construction

---

**P0**: Prove entropy Lipschitz bound
```lean
theorem entropy_lipschitz_bound
  (W : Weighting) (stepE : StepE)
  (doms : List DomainSignature) (nodes : List DomainNode)
  (L_entropy : Float) :
  let (doms', nodes') := stepE doms nodes
  let entropyDiff := rowEntropy (weightsFrom W nodes') - 
                     rowEntropy (weightsFrom W nodes)
  |entropyDiff| ≤ L_entropy * θ_max
```

**Proof approach**:
- Use entropy continuity/Lipschitz properties
- May require log-Lipschitz lemmas
- Connect to `DeltaPack.Δentropy`

---

**P0**: Prove spectral Weyl bound
```lean
theorem spectral_weyl_bound
  (W : Weighting) (stepE : StepE)
  (doms : List DomainSignature) (nodes : List DomainNode)
  (kernelLip stepLip degBound : Float) :
  let (doms', nodes') := stepE doms nodes
  let lamDiff := spectralInvariantW W nodes' - spectralInvariantW W nodes
  |lamDiff| ≤ kernelLip * stepLip * θ_max * degBound
```

**Proof approach**:
- Use Weyl's eigenvalue perturbation theorem
- Show step induces bounded perturbation to resonance matrix
- This is the **key analytic result** for the entire system

**Note**: This may require:
- Importing spectral theory from mathlib, OR
- Accepting as axiom with clear documentation, OR
- Proving a simplified version for the specific matrix structure

---

### 5. `IVI/FixedPoint.lean` — Convergence Proofs

**Current State**: Fixed-point is **runtime-checked** via `runToFixedPoint`, not proven.

#### Critical Gaps

**P1**: Prove fixed-point existence under contraction
```lean
theorem fixed_point_exists
  (cfg : FixedCfg) (stepE : StepE)
  (seed : List DomainSignature) (d0 : List DomainSignature) (n0 : List DomainNode)
  (h_contract : ∀ doms nodes, 
    let (doms', nodes') := stepE doms nodes
    let lam := spectralInvariantW cfg.weighting nodes
    let lam' := spectralInvariantW cfg.weighting nodes'
    |lam' - lam| ≤ 0.9 * |lam - lam_fixed|)  -- contraction condition
  (fuel : Nat) (h_fuel : fuel ≥ some_bound) :
  let result := runToFixedPoint cfg stepE seed d0 n0
  IVIFixedPoint cfg seed result.lambda result.lambda result.domains result.nodes
```

**Proof approach**:
- Use Banach fixed-point theorem
- Show spectral invariant forms a complete metric space
- Prove contraction mapping property from Kakeya bounds

---

**P1**: Prove loop closure from fixed-point
```lean
theorem loop_closure_from_fixed_point
  (cfg : FixedCfg) (seed cur : List DomainSignature)
  (h_fixed : loopClosureErr seed cur ≤ cfg.epsLoopI) :
  -- cur is ε-close to seed in the domain signature metric
  ∀ i, i < seed.length → 
    |seed[i].timeShift - cur[i].timeShift| ≤ cfg.epsLoopI
```

**Proof sketch**: Unfold `loopClosureErr` definition and extract pointwise bounds.

---

### 6. `IVI/Bridge.lean` — Kant ⇄ IVI Correspondence

**Current State**: Bridge functions are defined, but **soundness/completeness/minimality are not proven**.

#### Soundness (Kant ⇒ IVI)

**P0**: Prove soundness theorem
```lean
theorem soundness_theorem
  (cfgInv : InvariantCfg) (stepE : StepE)
  (doms : List DomainSignature) (nodes : List DomainNode)
  (h_kant : -- Kantian axioms A1-A12 hold
    ∀ (s : Subject Nat), 
      FromIThink.Thread.apperception (FromIThink.canonical Nat s)) :
  -- IVI verification succeeds without collapse
  let props := soundness cfgInv stepE doms nodes
  props.nonCollapse ∧ props.community ∧ props.unityProgress
```

**Proof approach**:
- Use existing `soundnessUnity_from_weylBound` infrastructure
- Requires proving the Weyl bound (see §4)
- Connect Kantian unity to IVI lambda-stability

**Status**: Partially done! `soundnessUnity_from_weylAutoBudget` provides the structure.

**Action**: Prove the missing Weyl inequality to close the loop.

---

#### Completeness (IVI ⇒ Kant)

**P1**: Prove completeness theorem
```lean
theorem completeness_theorem
  (cfgInv : InvariantCfg) (stepE : StepE) (fuel : Nat)
  (doms : List DomainSignature) (nodes : List DomainNode)
  (h_ivi : -- IVI reaches fixed-point
    let run := completenessRun cfgInv stepE fuel doms nodes
    ∃ frame ∈ run.frames, 
      fixedPointPredicateA cfgInv.W cfgInv.tau cfgInv.Ridx 
        cfgInv.ncfg frame.bridge.witness.nextNodes) :
  -- Kantian recognitions can be reconstructed
  ∃ (rec : Recognition C3State Nat), 
    ∀ node ∈ nodes, lawful rec node.state
```

**Proof approach**:
- Show fixed-point implies community + self-similarity
- Construct `Recognition` from stable lambda-vector
- Use `SchematismEvidence` to build rule witnesses

---

#### Minimality

**P2**: Prove axiom necessity
```lean
-- For each axiom Ai, show that removing it breaks IVI
theorem minimality_A1_necessary :
  ¬(∃ (IVI_without_A1 : System α τ), 
    -- IVI works without inner time ordering
    ∀ nodes, closedUnderIVI IVI_without_A1 nodes)

theorem minimality_A7_necessary :
  ¬(∃ (IVI_without_reciprocity : System α τ),
    -- IVI works without reciprocity
    ∀ nodes, closedUnderIVI IVI_without_reciprocity nodes)
```

**Proof approach**:
- Construct counterexamples showing failure modes
- Use `minimality_inner_time`, `minimality_reciprocity` placeholders
- This is more philosophical; may accept as documented assumptions

---

### 7. `IVI/KantLimit.lean` — Limit Predicates

**Current State**: Predicates are defined but not proven to hold.

**P1**: Prove bounded intuition from grain bounds
```lean
theorem bounded_intuition_from_kakeya
  (cfgInv : InvariantCfg) (stepE : StepE)
  (doms : List DomainSignature) (nodes : List DomainNode)
  (τ : Float)
  (h_contract : 
    let bridge := soundnessBridge cfgInv stepE doms nodes
    bridge.contract.Cg ≤ τ) :
  let S := symmetriseLL (weightsFrom cfgInv.W nodes)
  boundedIntuition S τ
```

**Proof sketch**: Connect Kakeya grain bound to graininess score.

---

**P1**: Prove noumenal boundary from collapse-zero
```lean
theorem noumenal_boundary_from_noncollapse
  (K : KakeyaField)
  (h : K.collapseCfg.grainSafe K.nodes) :
  noumenalBoundary K
```

**Proof sketch**: Unfold `isCollapseZero` and `grainSafe` definitions.

---

## Dependency Graph

```
Priority 0 (Critical Path):
  1. Prove Weyl spectral bound (§4) 
     ↓
  2. Prove T2 non-collapse preservation (§2)
     ↓
  3. Prove soundness theorem (§6)
     ↓
  4. Close Kant ⇒ IVI loop

Priority 1 (Strengthening):
  - Prove A1, A6, A7, A12 from primitives (§1)
  - Prove T1 universality (§2)
  - Prove power iteration convergence (§3)
  - Prove fixed-point existence (§5)
  - Prove completeness theorem (§6)

Priority 2 (Rigor):
  - Prove grain/entropy Lipschitz bounds (§4)
  - Enhance T3 with topology (§2)
  - Prove Kant limit predicates (§7)

Priority 3 (Polish):
  - Prove T4, T5 uniqueness (§2)
  - Prove minimality theorems (§6)
```

---

## Recommended Next Steps

### Phase 1: Close the Critical Loop (P0)

1. **Prove or axiomatize the Weyl bound** (`IVI/KakeyaBounds.lean`)
   - Option A: Import spectral perturbation theory from mathlib
   - Option B: Accept as documented axiom with clear bounds
   - Option C: Prove simplified version for symmetric nonnegative matrices

2. **Strengthen T2** to prove non-collapse preservation
   - Use the Weyl bound from step 1
   - Connect to `grainSafe` predicate

3. **Complete soundness proof** in `IVI/Bridge.lean`
   - Use `soundnessUnity_from_weylBound` infrastructure
   - Verify all hypotheses are discharged

### Phase 2: Strengthen Foundations (P1)

4. **Derive A7 (Reciprocity)** from `communityPredicateA`
5. **Derive A1 (Inner time)** from `InnerTime` typeclass
6. **Derive A6 (Schematism)** from `SchematismEvidence`
7. **Prove T1 (Universality)** with substantive content
8. **Prove fixed-point existence** using contraction mapping

### Phase 3: Complete the Picture (P2-P3)

9. Prove grain/entropy Lipschitz bounds
10. Prove completeness theorem (IVI ⇒ Kant)
11. Document which axioms remain foundational
12. Add minimality counterexamples

---

## Acceptance Criteria

The project is **proof-complete** when:

- ✅ Every theorem in `IVI/Theorems.lean` has substantive content (not tautologies)
- ✅ The Weyl spectral bound is either proven or clearly documented as an axiom
- ✅ Soundness theorem (Kant ⇒ IVI) is proven from the axiom base
- ✅ Fixed-point convergence is proven (not just runtime-checked)
- ✅ Axioms in `IVI/Pure.lean` are classified as permanent vs. derivable
- ✅ At least 3 derivable axioms (A1, A6, A7) are proven from primitives
- ✅ All `InvariantProps` predicates have formal witnesses (not just Boolean checks)

---

## Notes on Proof Strategy

### Working with Floats vs. Reals

Many proofs require **real analysis** (continuity, Lipschitz bounds, spectral theory), but the implementation uses `Float`. Options:

1. **Dual representation**: Keep `Float` for computation, add `Real` versions for proofs
2. **Axiomatize Float properties**: Assert that `Float` operations approximate `Real` within ε
3. **Import mathlib**: Use `Real`, `Complex`, and spectral theory libraries

**Recommendation**: Start with option 2 (axiomatize Float-Real correspondence) for quick progress, migrate to option 3 (mathlib) for full rigor.

### Handling Noncomputable Definitions

Many functions are marked `noncomputable` (e.g., `powerIter`, `spectralInvariant`). This is fine for proofs—Lean can reason about them even if they can't be executed. Keep the computational versions for the demo executable.

### Incremental Approach

Don't try to prove everything at once. Suggested order:

1. **Pick one P0 item** (e.g., Weyl bound) and either prove or axiomatize it clearly
2. **Use it to prove one P1 item** (e.g., T2 non-collapse)
3. **Iterate**: Each proven theorem enables the next

---

## Conclusion

This roadmap provides a **concrete path from axiomatic scaffold to fully proven system**. The critical bottleneck is the **Weyl spectral bound** (§4)—once that's established (by proof or documented axiom), the rest of the soundness chain can be completed using the existing infrastructure in `IVI/Bridge.lean`.

The project has excellent **proof architecture** already in place. The task now is to fill the gaps systematically, starting with P0 items and working through P1-P3 as rigor demands.
