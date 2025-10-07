/-
  IVI/Fractal.lean
  Describes I-directed fractal layering of IVI nodes and how Kakeya-preserving
  resuperposition realises zoom-in/zoom-out self-similarity.
-/

import IVI.Intangible
import IVI.Invariant
import IVI.Harmonics
import IVI.Kakeya
import IVI.KantLimit

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open Intangible
open Invariant

/-- One layer in the IVI fractal tower. The `depth` records the recursion level. -/
structure FractalLayer where
  depth : Nat
  nodes : List DomainNode
  deriving Repr

@[simp] def FractalLayer.size (L : FractalLayer) : Nat :=
  L.nodes.length

/-- Mean `i` (time-shift) coordinate for a layer. -/
@[simp] def FractalLayer.iCentroid (L : FractalLayer) : Float :=
  match L.nodes with
  | [] => 0.0
  | _ =>
      let total := L.nodes.foldl (fun acc n => acc + n.signature.timeShift) 0.0
      total / Float.ofNat L.nodes.length

/-- Averaged spatial magnitude used for scaling heuristics. -/
@[simp] def FractalLayer.radiusMean (L : FractalLayer) : Float :=
  match L.nodes with
  | [] => 0.0
  | _ =>
      let total := L.nodes.foldl (fun acc n =>
        acc + Intangible.spatialNorm n.state.ψ) 0.0
      total / Float.ofNat L.nodes.length

/-- Translation data describing one I-directed resuperposition step. -/
structure ITranslation where
  k     : Float
  pairs : List (DomainSignature × DomainSignature)
  deriving Repr

/-- Convenience: apply the Δi schematism once together with evidence. -/
@[simp] def ITranslation.zoomE
    (T : ITranslation) (L : FractalLayer) : FractalLayer × StepEvidence :=
  let (nodes', ev) := resuperposeStepE T.k T.pairs L.nodes
  ({ depth := L.depth + 1, nodes := nodes' }, ev)

@[simp] def ITranslation.zoom (T : ITranslation) (L : FractalLayer) : FractalLayer :=
  (T.zoomE L).fst

/-- Coarse zoom-out via the existing pooling. -/
@[simp] def FractalLayer.zoomOut (L : FractalLayer) : FractalLayer :=
  match L.depth with
  | 0 => L
  | Nat.succ d =>
      { depth := d, nodes := coarse L.nodes }

/-- A zoom cycle combines an I-translation with coarse pooling. -/
@[simp] def ITranslation.zoomCycle (T : ITranslation) (L : FractalLayer) : FractalLayer :=
  (T.zoom L).zoomOut

/-- Package the step-evidence variant for Kakeya preservation checks. -/
@[simp] def ITranslation.stepE (T : ITranslation) : StepE :=
  fun doms nodes =>
    let (nodes', ev) := resuperposeStepE T.k T.pairs nodes
    (doms, nodes', ev)

/-- Detect whether the Kakeya grain threshold is exceeded on a layer. -/
@[simp] def grainCollapse (K : KakeyaField) (L : FractalLayer) : Bool :=
  (K.withNodes L.nodes).collapseExceededBool

/-- Witness that a layer is still within the grain threshold. -/
@[simp] def grainSafe (K : KakeyaField) (L : FractalLayer) : Bool :=
  (K.withNodes L.nodes).collapseOK

@[simp] def KakeyaField.withLayer (K : KakeyaField) (L : FractalLayer) : KakeyaField :=
  K.withNodes L.nodes

@[simp] theorem grainSafe_iff
    (K : KakeyaField) (L : FractalLayer) :
    grainSafe K L = true ↔ (K.withNodes L.nodes).collapseScore ≤ K.τGrain := by
  simp [grainSafe, KakeyaField.collapseScore]

@[simp] theorem grainSafe_isCollapse_iff
    (K : KakeyaField) (L : FractalLayer) :
    grainSafe K L = true ↔ (K.withLayer L).isCollapseZero := by
  simp [grainSafe, KakeyaField.withLayer, KakeyaField.isCollapseZero,
        KakeyaField.collapseScore]

/-- The Kakeya field is preserved by one zoom step along the I direction. -/
@[simp] def preservesKakeyaAlongI
    (T : ITranslation) (K : KakeyaField)
    (doms : List DomainSignature) (L : FractalLayer) : Prop :=
  preservesKakeya (K.withLayer L) (T.stepE) doms L.nodes

/-- Graininess/stickiness balance after one zoom. -/
@[simp] noncomputable def grainStickAfterZoom
    (cfgInv : InvariantCfg) (τIntuition τStick : Float)
    (T : ITranslation) (L : FractalLayer)
    (K : KakeyaField) : KantLimit :=
  let (L', ev) := T.zoomE L
  kantLimitFrom
    (cfgInv := cfgInv) (τIntuition := τIntuition) (τStick := τStick)
    (prev_nodes := L.nodes) (cur_nodes := L'.nodes)
    (ev := ev) (K := K.withLayer L)

/-- Fractal self-similarity predicate: zooming in then out stabilises grain/stick. -/
@[simp] noncomputable def selfSimilar
    (cfgInv : InvariantCfg) (τIntuition τStick : Float)
    (T : ITranslation) (L : FractalLayer) (K : KakeyaField) : Prop :=
  let (L', ev) := T.zoomE L
  let L'' := L'.zoomOut
  let kant :=
    kantLimitFrom
      (cfgInv := cfgInv) (τIntuition := τIntuition) (τStick := τStick)
      (prev_nodes := L.nodes) (cur_nodes := L'.nodes)
      (ev := ev) (K := K.withLayer L)
  kant.boundedIntuition ∧ kant.schematismBound ∧
    nonCollapsePredicateA cfgInv.W cfgInv.ncfg L'.nodes L''.nodes ∧
    (K.withLayer L).isCollapseZero

/-- If a layer is grain-safe and the Kakeya step preserves the threshold, the zoomed
    layer remains grain-safe. -/
@[simp] theorem grainSafe_after_zoom
    (T : ITranslation) (K : KakeyaField)
    (doms : List DomainSignature) (L : FractalLayer)
    (hPres : preservesKakeya (K.withLayer L) (T.stepE) doms L.nodes) :
    grainSafe K (T.zoom L) = true := by
  obtain ⟨_, hCollapse⟩ := hPres
  apply (grainSafe_iff K (T.zoom L)).mpr
  have h := hCollapse
  simp [KakeyaField.withLayer, KakeyaField.withNodes] at h
  simpa [grainSafe, ITranslation.zoom, ITranslation.zoomE, KakeyaField.withNodes,
        KakeyaField.collapseScore]

/-- Iterate zoom cycles while staying below the grain threshold. -/
@[simp] def iterateZoomSafe (T : ITranslation) (K : KakeyaField)
    : Nat → FractalLayer → FractalLayer
  | 0, L => L
  | Nat.succ n, L =>
      if grainSafe K L = true then
        iterateZoomSafe T K n (T.zoomCycle L)
      else
        L

/-- Generate an infinite stream of layers obtained by iterating zoom cycles. -/
@[simp] def iterateZoom (T : ITranslation) : Nat → FractalLayer → FractalLayer
  | 0, L => L
  | Nat.succ n, L => iterateZoom T n (T.zoomCycle L)

end IVI
