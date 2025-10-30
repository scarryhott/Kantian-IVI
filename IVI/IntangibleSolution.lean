/-
  IVI/IntangibleSolution.lean
  Bundles verification (Understanding) with coherence persistence (Reason),
  exposing a witness for "intangibly solved" information.
-/

import IVI.TheoremsImproved
import IVI.Core.Coherence
import IVI.Fractal

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open Classical

/-- Predicate describing acceptable change between consecutive coherence snapshots. -/
@[simp] def coherenceWithin (εSpectrum εGrain : Float) (cmp : CoherenceComparison) : Prop :=
  cmp.spectrumDelta ≤ εSpectrum ∧ cmp.grainDelta ≤ εGrain

/--
Intangible solution witness: pairs a verification relativity certificate
with a coherence trail that remains within supplied thresholds.
-/
structure IntangibleSolution
    (cfg : ICollapseCfg) (base : FractalLayer)
    (εSpectrum εGrain : Float) where
  /-- Verification bundle (Understanding): global truth relative to local solution. -/
  witness : VerificationRelativity cfg base.nodes
  /-- Coherence snapshots produced by repeated resuperposition (Reason). -/
  snapshots : List CoherenceSnapshot
  /-- Every comparison along the trail respects the thresholds. -/
  stable :
    ∀ cmp ∈ trailComparisons snapshots,
      coherenceWithin εSpectrum εGrain cmp

namespace IntangibleSolution

/-- Access the local component of the verification witness. -/
@[simp] theorem local_solution
    {cfg : ICollapseCfg} {base : FractalLayer} {εσ εg : Float}
    (sol : IntangibleSolution cfg base εσ εg) :
    localSolution cfg base.nodes :=
  sol.witness.local_solution

/-- Access the global component of the verification witness. -/
@[simp] theorem global_truth
    {cfg : ICollapseCfg} {base : FractalLayer} {εσ εg : Float}
    (sol : IntangibleSolution cfg base εσ εg) :
    globalTruth cfg base.nodes :=
  sol.witness.global_truth

/-- Final coherence snapshot, if available. -/
@[simp] def finalSnapshot?
    {cfg : ICollapseCfg} {base : FractalLayer} {εσ εg : Float}
    (sol : IntangibleSolution cfg base εσ εg) : Option CoherenceSnapshot :=
  sol.snapshots.reverse.head?

/-- Build an intangible solution from an explicit coherence trail. -/
@[simp] def ofTrail
    {cfg : ICollapseCfg} {base : FractalLayer}
    {εσ εg : Float}
    (witness : VerificationRelativity cfg base.nodes)
    (snapshots : List CoherenceSnapshot)
    (hStable :
      ∀ cmp ∈ trailComparisons snapshots,
        coherenceWithin εσ εg cmp) :
    IntangibleSolution cfg base εσ εg :=
  { witness := witness
  , snapshots := snapshots
  , stable := hStable }

/-- Convenience constructor using `resuperposeTrail`. -/
@[simp] def ofResuperpose
    {cfg : ICollapseCfg} {εσ εg : Float}
    (steps : Nat)
    (layer : FractalLayer)
    (witness : VerificationRelativity cfg layer.nodes)
    (hStable :
      ∀ cmp ∈ trailComparisons (resuperposeTrail cfg steps layer),
        coherenceWithin εσ εg cmp) :
    IntangibleSolution cfg layer εσ εg :=
  ofTrail witness (resuperposeTrail cfg steps layer) hStable

/-- Stability predicate extracted from the solution. -/
@[simp] def stableComparisons
    {cfg : ICollapseCfg} {base : FractalLayer} {εσ εg : Float}
    (sol : IntangibleSolution cfg base εσ εg)
    (cmp : CoherenceComparison) : Prop :=
  cmp ∈ trailComparisons sol.snapshots ∧
    coherenceWithin εσ εg cmp

/-- No comparisons when the coherence trail has a single snapshot. -/
@[simp] theorem trailComparisons_singleton (snap : CoherenceSnapshot) :
    trailComparisons [snap] = [] :=
  rfl

/-- The zeroth resuperposition trail has no comparisons to check. -/
@[simp] theorem trailComparisons_resuperpose_zero
    (cfg : ICollapseCfg) (layer : FractalLayer) (k : Nat := 4) :
    trailComparisons (resuperposeTrail cfg 0 layer k) = [] := by
  simp [resuperposeTrail]

/-- Stability is trivial when the comparison list is empty. -/
@[simp] theorem stable_resuperpose_zero
    (cfg : ICollapseCfg) (layer : FractalLayer)
    (εσ εg : Float) :
    ∀ cmp ∈ trailComparisons (resuperposeTrail cfg 0 layer), coherenceWithin εσ εg cmp :=
by
  intro cmp h
  have hEmpty :
      trailComparisons (resuperposeTrail cfg 0 layer) = [] := by
    simpa using trailComparisons_resuperpose_zero cfg layer
  have : False := by simpa [hEmpty] using h
  exact False.elim this

end IntangibleSolution

end IVI
