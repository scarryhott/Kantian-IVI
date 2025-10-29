/-
  IVI/Core/Coherence.lean
  Coherence sampling along the I-axis using grain-safe subsets.

  Provides helpers to extract the nodes that remain grain-safe after each
  `resuperposeStep` and to compare their resonance spectra so we can map
  where coherence persists through time.
-/

import IVI.Core.Transform
import IVI.Collapse
import IVI.Harmonics
import IVI.Invariant

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open Classical
open Invariant

/-- Extract the nodes in a configuration that remain grain-safe individually. -/
@[simp] def grainSafeNodes (cfg : ICollapseCfg) (nodes : List DomainNode) :
    List DomainNode :=
  nodes.filter fun n => decide (cfg.grainSafe [n])

/-- Snapshot of I-axis coherence information at a particular step. -/
structure CoherenceSnapshot where
  /-- Step index (0 = initial layer before refinement). -/
  step : Nat
  /-- Nodes that remain grain-safe when considered locally. -/
  safeNodes : List DomainNode
  /-- Harmonic summary of the grain-safe subset resonance. -/
  spectrum : List Float
  /-- Graininess score of the grain-safe subset resonance. -/
  graininess : Float
  deriving Repr

/-- Pairwise comparison between consecutive coherence snapshots. -/
structure CoherenceComparison where
  fromStep : Nat
  toStep : Nat
  spectrumDelta : Float
  grainDelta : Float
  safeCountFrom : Nat
  safeCountTo : Nat
  deriving Repr

/-- Resonance matrix of the grain-safe nodes. -/
@[simp] def coherenceMatrix
    (cfg : ICollapseCfg) (nodes : List DomainNode) : List (List Float) :=
  resonanceMatrixW cfg.W nodes

/-- Harmonic summary (low-dimensional spectrum) of the grain-safe subset. -/
@[simp] def coherenceSpectrum
    (cfg : ICollapseCfg) (nodes : List DomainNode) (k : Nat := 4) : List Float :=
  harmonicSummary (coherenceMatrix cfg nodes) k

/-- Compute a single coherence snapshot for the provided node list. -/
@[simp] def buildSnapshot (cfg : ICollapseCfg) (step : Nat)
    (nodes : List DomainNode) (k : Nat := 4) : CoherenceSnapshot :=
  let safe := grainSafeNodes cfg nodes
  let matrix := coherenceMatrix cfg safe
  let spectrum := harmonicSummary matrix k
  let grain := graininessScore matrix
  { step := step, safeNodes := safe, spectrum := spectrum, graininess := grain }

/-- Run `resuperposeStep` repeatedly and collect coherence snapshots.

Returns `steps + 1` snapshots: step 0 (initial layer) through step `steps`,
with each subsequent snapshot taken after another resuperposition.
-/
@[simp] def resuperposeTrail (cfg : ICollapseCfg) (steps : Nat)
    (layer : FractalLayer) (k : Nat := 4) : List CoherenceSnapshot :=
  let rec go : Nat → Nat → FractalLayer → List CoherenceSnapshot
    | 0, idx, L =>
        [buildSnapshot cfg idx L.nodes k]
    | Nat.succ rest, idx, L =>
        let snap := buildSnapshot cfg idx L.nodes k
        snap :: go rest (Nat.succ idx) (resuperposeStep cfg L)
  go steps 0 layer

/-- Compare consecutive snapshots along a coherence trail. -/
@[simp] def trailComparisons :
    List CoherenceSnapshot → List CoherenceComparison
  | [] => []
  | _ :: [] => []
  | a :: b :: rest =>
      let diff := vectorMaxDiff a.spectrum b.spectrum
      let grain := Float.abs (b.graininess - a.graininess)
      { fromStep := a.step
      , toStep := b.step
      , spectrumDelta := diff
      , grainDelta := grain
      , safeCountFrom := a.safeNodes.length
      , safeCountTo := b.safeNodes.length } ::
        trailComparisons (b :: rest)

end IVI

