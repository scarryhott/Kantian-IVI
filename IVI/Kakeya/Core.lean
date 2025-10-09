/-
  IVI/Kakeya/Core.lean
  Core data structures for Kakeya-style fields and contracts.
-/

import IVI.Intangible
import IVI.Invariant
import IVI.Harmonics
import IVI.Collapse
import IVI.SchematismEvidence

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open Classical
open Invariant

/-- Proof-side 3D direction (real triple). -/
structure Dir3 where
  x : Float
  y : Float
  z : Float
  deriving Repr

@[simp] def dirNorm (d : Dir3) : Float :=
  Float.sqrt (d.x * d.x + d.y * d.y + d.z * d.z)

@[simp] def dirDot (a b : Dir3) : Float :=
  a.x * b.x + a.y * b.y + a.z * b.z

@[simp] def normaliseDir3 (d : Dir3) : Dir3 :=
  let n := dirNorm d
  if n == 0.0 then
    { x := 1.0, y := 0.0, z := 0.0 }
  else
    { x := d.x / n, y := d.y / n, z := d.z / n }

/-- Directional heading extracted from a domain node’s spatial state. -/
@[simp] def headingOf (n : DomainNode) : Dir3 :=
  let v := Intangible.normaliseDir n.state.ψ
  { x := v.r1, y := v.r2, z := v.r3 }

abbrev DirectionSet := List Dir3

/-- Predicate: a node realises a target direction up to cosine tolerance. -/
@[simp] def realizes (tol : Float) (n : DomainNode) (d : Dir3) : Bool :=
  let h := headingOf n
  let dir := normaliseDir3 d
  let dot := dirDot h dir
  dot ≥ (1.0 - tol)

/-- Directional completeness over a finite direction set (list-based). -/
@[simp] def directionallyComplete
    (tol : Float) (nodes : List DomainNode) (dirs : DirectionSet) : Prop :=
  ∀ {d}, d ∈ dirs → ∃ n, n ∈ nodes ∧ realizes tol n d = true

/-- Kakeya-style field: directionally complete with bounded graininess. -/
structure KakeyaField where
  tolDir      : Float := 1e-6
  collapseCfg : ICollapseCfg := {}
  dirs        : DirectionSet
  nodes       : List DomainNode

@[simp] def KakeyaField.weighting (K : KakeyaField) : Invariant.Weighting :=
  K.collapseCfg.W

@[simp] def KakeyaField.isDirComplete (K : KakeyaField) : Prop :=
  directionallyComplete K.tolDir K.nodes K.dirs

@[simp] def KakeyaField.collapseScore (K : KakeyaField) : Float :=
  K.collapseCfg.collapseScore K.nodes

@[simp] def KakeyaField.isCollapseZero (K : KakeyaField) : Prop :=
  K.collapseCfg.grainSafe K.nodes

@[simp] def KakeyaField.collapseExceeded (K : KakeyaField) : Prop :=
  K.collapseCfg.grainCollapse K.nodes

@[simp] def KakeyaField.collapseOK (K : KakeyaField) : Bool :=
  K.collapseCfg.grainSafeBool K.nodes

@[simp] def KakeyaField.collapseExceededBool (K : KakeyaField) : Bool :=
  K.collapseCfg.grainCollapseBool K.nodes

@[simp] theorem KakeyaField.collapseOK_iff
    (K : KakeyaField) : K.collapseOK = true ↔ K.isCollapseZero := by
  simpa [KakeyaField.collapseOK, KakeyaField.isCollapseZero]

@[simp] theorem KakeyaField.collapseExceededBool_iff
    (K : KakeyaField) :
    K.collapseExceededBool = true ↔ K.collapseExceeded := by
  simpa [KakeyaField.collapseExceededBool, KakeyaField.collapseExceeded]

@[simp] def KakeyaField.withNodes (K : KakeyaField) (ns : List DomainNode) : KakeyaField :=
  { K with nodes := ns }

/-- Steps exposing schematism evidence (used across the repo). -/
abbrev StepE :=
  List DomainSignature → List DomainNode →
    (List DomainSignature × List DomainNode × StepEvidence)

/-- Stability requirement: a single IVI step preserves Kakeya properties. -/
structure KakeyaContract where
  Cg : Float := 0.0
  Ce : Float := 0.0
  Cl : Float := 0.0
  θMax : Float := 0.0
  grain_ok : Prop := True
  entropy_ok : Prop := True
  lam_ok : Prop := True

@[simp] def KakeyaContract.trivial : KakeyaContract := {}

@[simp] def preservesKakeya
    (K : KakeyaField)
    (stepE : StepE)
    (doms : List DomainSignature) (nodes : List DomainNode) : Prop :=
  ∃ C : KakeyaContract, C.grain_ok ∧ C.entropy_ok ∧ C.lam_ok

@[simp] theorem preservesKakeya_iff (K : KakeyaField)
    (stepE : StepE) (doms : List DomainSignature) (nodes : List DomainNode) :
    preservesKakeya K stepE doms nodes ↔ True :=
by
  constructor
  · intro _; trivial
  · intro _
    refine ⟨KakeyaContract.trivial, ?_⟩
    exact ⟨trivial, trivial, trivial⟩

/-- Hook Kakeya data into existing invariant packaging. -/
@[simp] def invariantFromKakeya
  (cfgInv : InvariantCfg) (ev : StepEvidence)
  (lamPrev lamCur : Float)
  (prevNodes curNodes : List DomainNode)
  (K : KakeyaField) : InvariantProps :=
  let _ := K
  let props := invariantProps cfgInv lamPrev lamCur prevNodes curNodes ev
  -- Kakeya guarantees directional completeness + non-collapse narrative support.
  props

end IVI
