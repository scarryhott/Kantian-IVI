/-
  IVI/PositiveGeometry.lean
  Encodes the Hegelian sublation step: fractal layers (thesis), their
  zoomed counterpart (antithesis), and the positive-geometry synthesis.
-/

import IVI.NeuralGeometry

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open Intangible

/-- Add two direction triples. -/
@[simp] def addDir3 (a b : Dir3) : Dir3 :=
  { x := a.x + b.x, y := a.y + b.y, z := a.z + b.z }

/-- Zero vector in `Dir3`. -/
@[simp] def zeroDir3 : Dir3 :=
  { x := 0.0, y := 0.0, z := 0.0 }

/-- Aggregate the normals from a neural layer into one orientation. -/
@[simp] def orientationFromNeural (layer : List NeuralGrain) : Dir3 :=
  let sum :=
    layer.foldl (fun acc grain => addDir3 acc (dir3OfVec grain.normal)) zeroDir3
  normaliseDir3 sum

/-- Canonical positive-geometry cell produced by sublation. -/
structure PositiveCell where
  support : List DomainNode
  orientation : Dir3
  weight : Float
  activationProfile : List Float
  deriving Repr

/-- Dialectical witness tying together thesis, antithesis, and synthesis. -/
structure SublationWitness where
  thesis : FractalLayer
  antithesis : FractalLayer
  neuralLayer : List NeuralGrain
  positive : PositiveCell
  grainInvariant : Prop
  deriving Repr

/-- Assemble a positive-geometry cell from a neuralised layer. -/
@[simp] def assemblePositiveCell
    (support : FractalLayer) (layer : List NeuralGrain) : PositiveCell :=
  let baseWeight := layer.foldl (fun acc grain => acc + grain.activation) 0.0
  let fallback := Float.ofNat layer.length
  let weight := if baseWeight == 0.0 then fallback else baseWeight
  { support := support.nodes
  , orientation := orientationFromNeural layer
  , weight := weight
  , activationProfile := layer.map (fun grain => grain.activation) }

/-- Instantiate the sublation package for one fractal layer. -/
@[simp] def sublateLayer
    (T : ITranslation) (K : KakeyaField) (L : FractalLayer) : SublationWitness :=
  let thesis := L
  let antithesis := T.zoomCycle L
  let neural := thesis.neuralise K
  let positive := assemblePositiveCell antithesis neural
  let invariant := K.grainSafe thesis ∧ K.grainSafe antithesis
  { thesis := thesis
  , antithesis := antithesis
  , neuralLayer := neural
  , positive := positive
  , grainInvariant := invariant }

/-- Sublation succeeds when grain statistics match and Kakeya invariants hold. -/
@[simp] def SublationWitness.valid (w : SublationWitness) : Prop :=
  w.grainInvariant ∧
    w.thesis.grainStatistics ≈ᵍ w.antithesis.grainStatistics

/-- The positive orientation respects every Kakeya direction (weak alignment). -/
@[simp] def SublationWitness.alignedWith
    (w : SublationWitness) (K : KakeyaField) : Prop :=
  ∀ dir ∈ K.dirs, Float.abs (dirDot w.positive.orientation dir) ≤ 1.0

/-- Convenience wrapper returning only the positive-geometry synthesis. -/
@[simp] def ITranslation.positiveSynthesis
    (T : ITranslation) (K : KakeyaField) (L : FractalLayer) : PositiveCell :=
  (sublateLayer T K L).positive

end IVI
