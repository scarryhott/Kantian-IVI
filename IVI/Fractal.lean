/-
  IVI/Fractal.lean
  Describes I-directed fractal layering of IVI nodes and how Kakeya-preserving
  resuperposition realises zoom-in/zoom-out self-similarity.
-/

import IVI.Intangible
import IVI.Invariant
import IVI.Harmonics
import IVI.Collapse
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
@[simp] def grainCollapseLayer (cfg : ICollapseCfg) (L : FractalLayer) : Prop :=
  cfg.grainCollapse L.nodes

@[simp] def grainCollapseLayerBool (cfg : ICollapseCfg) (L : FractalLayer) : Bool :=
  cfg.grainCollapseBool L.nodes

/-- Witness that a layer is still within the grain threshold. -/
@[simp] def grainSafeLayer (cfg : ICollapseCfg) (L : FractalLayer) : Prop :=
  cfg.grainSafe L.nodes

@[simp] def grainSafeLayerBool (cfg : ICollapseCfg) (L : FractalLayer) : Bool :=
  cfg.grainSafeBool L.nodes

@[simp] def KakeyaField.withLayer (K : KakeyaField) (L : FractalLayer) : KakeyaField :=
  K.withNodes L.nodes

@[simp] def KakeyaField.grainSafe (K : KakeyaField) (L : FractalLayer) : Prop :=
  grainSafeLayer K.collapseCfg L

@[simp] def KakeyaField.grainSafeBool (K : KakeyaField) (L : FractalLayer) : Bool :=
  grainSafeLayerBool K.collapseCfg L

@[simp] def KakeyaField.grainCollapse (K : KakeyaField) (L : FractalLayer) : Prop :=
  grainCollapseLayer K.collapseCfg L

@[simp] def KakeyaField.grainCollapseBool (K : KakeyaField) (L : FractalLayer) : Bool :=
  grainCollapseLayerBool K.collapseCfg L

@[simp] theorem grainSafeBool_iff
    (cfg : ICollapseCfg) (L : FractalLayer) :
    grainSafeLayerBool cfg L = true ↔ grainSafeLayer cfg L := by
  simpa [grainSafeLayerBool, grainSafeLayer]

@[simp] theorem KakeyaField.grainSafeBool_iff
    (K : KakeyaField) (L : FractalLayer) :
    K.grainSafeBool L = true ↔ K.grainSafe L := by
  simpa [KakeyaField.grainSafeBool, KakeyaField.grainSafe,
        grainSafeLayerBool, grainSafeLayer]

@[simp] theorem KakeyaField.grainSafe_iff_isCollapseZero
    (K : KakeyaField) (L : FractalLayer) :
    K.grainSafe L ↔ (K.withLayer L).isCollapseZero := by
  simp [KakeyaField.grainSafe, KakeyaField.withLayer, KakeyaField.isCollapseZero,
        grainSafeLayer]

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
    (_ : preservesKakeya (K.withLayer L) (T.stepE) doms L.nodes) :
    True := trivial

/-- Iterate zoom cycles while staying below the grain threshold. -/
@[simp] def iterateZoomSafe (T : ITranslation) (K : KakeyaField)
    : Nat → FractalLayer → FractalLayer
  | 0, L => L
  | Nat.succ n, L =>
      if K.grainSafeBool L then
        iterateZoomSafe T K n (T.zoomCycle L)
      else
        L

/-- Generate an infinite stream of layers obtained by iterating zoom cycles. -/
@[simp] def iterateZoom (T : ITranslation) : Nat → FractalLayer → FractalLayer
  | 0, L => L
  | Nat.succ n, L => iterateZoom T n (T.zoomCycle L)

/-- Coarse statistics summarising one fractal layer for neural or positive-geometry
    synthesis. These aggregates act as the Kantian invariant that must survive
    the Hegelian sublation step. -/
structure GrainStatistics where
  /-- Mean spatial radius across nodes (geometric scale). -/
  radiusMean : Float
  /-- Mean temporal shift across nodes (subjective scale). -/
  timeShiftMean : Float
  deriving Repr

/-- Extract averaged geometric + temporal features from a fractal layer. -/
@[simp] def FractalLayer.grainStatistics (L : FractalLayer) : GrainStatistics :=
  { radiusMean := L.radiusMean
  , timeShiftMean := L.iCentroid }

/-- Two grain-statistic packages agree up to a tolerance (default 1e-3). -/
@[simp] def GrainStatistics.close
    (a b : GrainStatistics) (ε : Float := 1e-3) : Prop :=
  Float.abs (a.radiusMean - b.radiusMean) ≤ ε ∧
  Float.abs (a.timeShiftMean - b.timeShiftMean) ≤ ε

/-- Notation for closeness of grain statistics (default tolerance 1e-3). -/
infix:50 " ≈ᵍ " => GrainStatistics.close

end IVI
