# Next Steps for Proof Completion

## What Was Delivered

✅ **`PROOF_ROADMAP.md`** - Comprehensive 44KB roadmap with:
- File-by-file gap analysis
- Specific theorems to prove with proof sketches
- Priority levels (P0-P3) and dependency graph
- Acceptance criteria for "proof-complete"

✅ **`PROOF_STATUS.md`** - Quick reference showing:
- Current status of all files
- Axiom classification (permanent vs. derivable)
- Testing & validation status

✅ **`IVI/WeylBounds.lean`** - Starter file with:
- Axiomatized Weyl spectral bound
- Grain/entropy Lipschitz bounds
- Infrastructure for soundness loop

✅ **All files compile** - No `sorry` in original codebase

---

## Immediate Action Items

### Option A: Accept Current State (Recommended for Now)

**Status**: System is **computationally sound** with documented axioms

**What this means**:
- Runtime checks validate all properties dynamically
- Axioms are clearly documented in `IVI/WeylBounds.lean`
- System works for practical applications
- Philosophical foundations are explicit

**Action**: Update README to reference `PROOF_STATUS.md` and `PROOF_ROADMAP.md`

### Option B: Pursue Full Proof Completeness

**Critical Path** (follow in order):

#### 1. Decide on Weyl Bound (P0 - Critical)

**Three options**:

**A. Accept as Axiom** (Current approach)
```lean
-- In IVI/WeylBounds.lean (already done)
axiom weyl_eigenvalue_bound : 
  Float.abs (lambda' - lambda) ≤ matrixNormInf (matrixDiff M' M)
```
- ✅ Fastest path forward
- ✅ Clearly documented with mathematical references
- ⚠️ Requires accepting one foundational analytic axiom

**B. Import mathlib and Prove**
```bash
# Add to lakefile.lean
require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git"
```
- ✅ Fully rigorous
- ⚠️ Significant work (spectral theory is complex)
- ⚠️ Adds large dependency

**C. Prove Simplified Version**
- Prove for symmetric nonnegative matrices only
- Use power iteration convergence
- Still requires real analysis

**Recommendation**: Start with Option A, migrate to B/C if needed

#### 2. Strengthen T2 (P0 - Critical)

**File**: `IVI/Theorems.lean`

**Current**:
```lean
theorem T2_liminal_persistence (cfg : ICollapseCfg) (nodes : List DomainNode) :
  cfg.grainSafe nodes → cfg.grainSafe nodes
```

**Target**:
```lean
theorem T2_liminal_persistence 
  (cfg : ICollapseCfg) (stepE : StepE) 
  (doms : List DomainSignature) (nodes : List DomainNode)
  (h : cfg.grainSafe nodes) :
  let result := stepE doms nodes
  cfg.grainSafe result.2.1
```

**Proof approach**:
1. Use `grain_bound_from_step` from `IVI/WeylBounds.lean`
2. Show contract bound implies grain safety
3. Connect to `KakeyaBounds.buildContract`

#### 3. Complete Soundness (P0 - Critical)

**File**: `IVI/Bridge.lean`

**Current**: Infrastructure exists (`soundnessUnity_from_weylBound`)

**Target**: Prove full soundness theorem
```lean
theorem soundness_complete
  (cfgInv : InvariantCfg) (stepE : StepE)
  (doms : List DomainSignature) (nodes : List DomainNode) :
  let props := soundness cfgInv stepE doms nodes
  props.nonCollapse ∧ props.community ∧ props.unityProgress
```

**Proof approach**:
1. Use Weyl bound from step 1
2. Use T2 from step 2  
3. Connect to existing `soundnessUnity_from_weylAutoBudget`

---

## Priority 1 Items (After P0)

### Derive Kantian Axioms

**A7 (Reciprocity)** - Easiest, already constructive:
```lean
-- Prove from communityPredicateA symmetry
theorem reciprocity_from_community
  (W : Weighting) (nodes : List DomainNode) (τ : Float) :
  communityPredicateA W τ none nodes →
  ∃ (R : Reciprocity Nat), ∀ i j, R.relates i j → R.relates j i
```

**A1 (Inner Time)** - Derive from typeclass:
```lean
-- Strengthen InnerTime with totality
class InnerTime (τ : Type u) where
  before : τ → τ → Prop
  total : ∀ t₁ t₂, before t₁ t₂ ∨ t₁ = t₂ ∨ before t₂ t₁
```

**A6 (Schematism)** - Derive from evidence construction:
```lean
-- Show SchematismEvidence is always constructible
theorem schematism_from_evidence :
  ∀ (stepE : StepE) (doms : List DomainSignature) (nodes : List DomainNode),
    ∃ (ev : StepEvidence), True
```

### Improve Theorems

**T1 (Universality)** - Add substance:
```lean
theorem T1_universality_substantive
  {α τ} [InnerTime τ] (rec : Recognition α τ) (x : α)
  (h : lawful rec x) :
  ∃ (svo : SVO α), svo.repr = x ∧ rec.rule.applies x
```

**T3 (Reciprocity Topology)** - Already correct, just enhance:
```lean
-- Add equivalence relation properties
theorem T3_reciprocity_equivalence
  {α} (R : Reciprocity α)
  (refl : ∀ x, R.relates x x)
  (trans : ∀ {x y z}, R.relates x y → R.relates y z → R.relates x z) :
  -- R is an equivalence relation
  ...
```

---

## Priority 2-3 Items

See `PROOF_ROADMAP.md` sections for:
- Power iteration convergence
- Fixed-point existence proofs
- Completeness theorem (IVI ⇒ Kant)
- Minimality counterexamples

---

## Practical Workflow

### Week 1: Foundation
- [ ] Review `PROOF_ROADMAP.md` completely
- [ ] Decide on Weyl bound approach (A/B/C)
- [ ] If Option A: Document acceptance in project README
- [ ] If Option B: Add mathlib dependency and start spectral theory import

### Week 2: Critical Path
- [ ] Implement chosen Weyl bound approach
- [ ] Prove T2 (non-collapse preservation)
- [ ] Connect to soundness theorem

### Week 3: Strengthening
- [ ] Derive A7 (Reciprocity)
- [ ] Derive A1 (Inner Time)
- [ ] Improve T1 (Universality)

### Week 4+: Completeness
- [ ] Prove power iteration convergence
- [ ] Prove fixed-point existence
- [ ] Complete IVI ⇒ Kant direction

---

## Testing Strategy

### After Each Proof

```bash
# Build the specific file
lake build IVI.YourFile

# Build everything
lake build

# Run demo to ensure nothing broke
lake exe ivi-demo
```

### Regression Testing

Keep `IVI/Proofs.lean` as a test suite - all lemmas should remain proven.

---

## Documentation Updates

### When Completing Proofs

1. Update `PROOF_STATUS.md` - change ⚠️ to ✅
2. Update `PROOF_ROADMAP.md` - mark items complete
3. Add proof to appropriate file (not a new file)
4. Document any new axioms clearly

### When Accepting Axioms

1. Document in `IVI/WeylBounds.lean` with:
   - Mathematical reference (paper/theorem name)
   - Why it's foundational
   - What it enables

2. Update `PROOF_STATUS.md` axiom inventory

---

## Common Pitfalls

### ❌ Don't Do This

- **Don't** create new files for every proof (use existing structure)
- **Don't** weaken existing proven lemmas
- **Don't** delete tests
- **Don't** mix Float and Real without clear coercion strategy

### ✅ Do This

- **Do** use `sorry` as placeholder while developing proof structure
- **Do** test after each change
- **Do** document axioms clearly
- **Do** follow existing proof style in `IVI/Proofs.lean`

---

## Getting Help

### Stuck on Proof?

1. Check `PROOF_ROADMAP.md` for proof sketch
2. Look at similar proofs in `IVI/Proofs.lean`
3. Use `sorry` to structure proof, then fill in pieces
4. Check Lean 4 documentation for tactic usage

### Compilation Errors?

1. Check imports are correct
2. Verify types match exactly
3. Use `#check` to inspect terms
4. Look at error message carefully (Lean 4 errors are usually precise)

---

## Success Criteria

### Minimal (Option A)
- ✅ Weyl bound documented as axiom
- ✅ T2 proven using Weyl bound
- ✅ Soundness theorem connected
- ✅ All files compile
- ✅ Demo runs

### Full (Option B)
- ✅ All of Minimal
- ✅ Weyl bound proven from mathlib
- ✅ A1, A6, A7 derived
- ✅ T1, T3 improved
- ✅ Fixed-point proven
- ✅ Completeness theorem proven

---

## Current Status Summary

**Compiles**: ✅ Yes  
**Runs**: ✅ Yes  
**Computationally Sound**: ✅ Yes  
**Formally Proven**: ⚠️ Partially (see `PROOF_STATUS.md`)  
**Path Forward**: ✅ Clear (this document + roadmap)

**Recommendation**: Accept current state as computationally sound with documented axioms, then pursue full proofs incrementally following the P0 → P1 → P2 priority order.

---

## Questions to Answer

Before proceeding, decide:

1. **Weyl bound**: Axiom (A), mathlib proof (B), or simplified proof (C)?
2. **Timeline**: Immediate full proofs, or incremental over time?
3. **Scope**: Minimal soundness only, or full completeness?
4. **Dependencies**: Accept mathlib, or stay dependency-free?

**My recommendation**: 
- Weyl bound: **Option A** (axiom)
- Timeline: **Incremental**
- Scope: **Minimal first** (P0 items), then expand
- Dependencies: **Stay lean** (no mathlib unless needed)

This gives you a working, documented system now, with a clear path to full rigor later.
