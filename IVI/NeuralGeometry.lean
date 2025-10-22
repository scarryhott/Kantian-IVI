/-
  IVI/NeuralGeometry.lean
  Refines Kakeya grains with neural activation data and packages the
  fractal zoom dynamics as a learnable hierarchy.
-/

import IVI.Fractal
import IVI.Kakeya.Core
import IVI.EntropicGravity

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open Intangible
open EntropicGravity

/-- Directional connection between grains, indexed by domain signature. -/
structure NeuralConnection where
  signature : DomainSignature
  weight : Float
  deriving Repr

/-- Kakeya grain upgraded with neural activation metadata. -/
structure NeuralGrain extends EntropicGravity.KakeyaGrain where
  activation : Float := 0.0
  bias : Float := 0.0
  inputs : List NeuralConnection := []
  outputs : List NeuralConnection := []
  deriving Repr

/-- Convert a `C3Vec` into a real direction triple. -/
@[simp] def dir3OfVec (v : C3Vec) : Dir3 :=
  { x := v.r1, y := v.r2, z := v.r3 }

/-- Safe blend between two spatial directions. -/
@[simp] def blendDir (a b : C3Vec) (t : Float) : C3Vec :=
  { r1 := a.r1 + t * (b.r1 - a.r1)
  , i1 := a.i1 + t * (b.i1 - a.i1)
  , r2 := a.r2 + t * (b.r2 - a.r2)
  , i2 := a.i2 + t * (b.i2 - a.i2)
  , r3 := a.r3 + t * (b.r3 - a.r3)
  , i3 := a.i3 + t * (b.i3 - a.i3) }

/-- Gaussian tuning curve measuring how well a grain aligns with an input direction. -/
@[simp] def NeuralGrain.activationResponse (g : NeuralGrain) (inputDirection : C3Vec) : Float :=
  let alignment := Intangible.angleBetween g.normal inputDirection
  let variance := 2.0 * g.thickness * g.thickness
  let variance := if variance ≤ 1e-9 then 1e-9 else variance
  Float.exp (-(alignment * alignment) / variance)

/-- Update a grain's activation in response to a probe direction. -/
@[simp] def NeuralGrain.withActivation (g : NeuralGrain) (inputDirection : C3Vec) : NeuralGrain :=
  let act := g.activationResponse inputDirection
  { g with activation := act }

/-- Lift a domain node into the neural geometry perspective. -/
@[simp] def NeuralGrain.fromDomainNode
    (n : DomainNode) (tubeCount : Nat := 1) (widthScale : Float := 1.0) : NeuralGrain :=
  let radius := Intangible.spatialNorm n.state.ψ
  let safeTubeCount := if tubeCount = 0 then 1 else tubeCount
  let safeWidthScale := if widthScale ≤ 1e-6 then 1.0 else widthScale
  let thickness :=
    if radius ≤ 1e-6 then 1e-6 else radius / Float.ofNat 10
  let width :=
    safeWidthScale * Float.sqrt (radius + 1.0)
  { center := n.state.ψ
  , normal := n.signature.axis
  , thickness := thickness
  , width := width
  , tube_count := safeTubeCount
  , activation := 0.0
  , bias := n.signature.timeShift
  , inputs := []
  , outputs := [] }

/-- Assemble a neural layer from a fractal layer + Kakeya field metadata. -/
@[simp] def FractalLayer.neuralise (L : FractalLayer) (K : KakeyaField) : List NeuralGrain :=
  let tubeCount := if K.dirs.length = 0 then 1 else K.dirs.length
  let widthScale := Float.sqrt (Float.ofNat tubeCount)
  L.nodes.map fun node =>
    NeuralGrain.fromDomainNode node (tubeCount := tubeCount) (widthScale := widthScale)

/-- Forward propagate an input direction through a stack of neuralised layers. -/
@[simp] def forwardPropagate (layers : List (List NeuralGrain)) (input : C3Vec) : List Float :=
  layers.foldl
    (fun acc layer =>
      acc ++ layer.map (fun grain => grain.activationResponse input))
    []

/-- Adjust a grain's preferred normal towards a target direction (simple Hebbian step). -/
@[simp] def updateGrainOrientation
    (g : NeuralGrain) (targetDirection : C3Vec) (learningRate : Float) : NeuralGrain :=
  let lr := if learningRate ≤ 0.0 then 0.0 else learningRate
  let cur := Intangible.normaliseDir g.normal
  let tgt := Intangible.normaliseDir targetDirection
  let blended := blendDir cur tgt lr
  { g with normal := Intangible.normaliseDir blended }

/-- The neural hierarchy has learned scale invariance when zoom cycles preserve statistics. -/
@[simp] def learnsScaleInvariance
    (T : ITranslation) (layers : List FractalLayer) : Prop :=
  ∀ L, L ∈ layers →
    let L' := T.zoomCycle L
    L.grainStatistics ≈ᵍ L'.grainStatistics

end IVI
