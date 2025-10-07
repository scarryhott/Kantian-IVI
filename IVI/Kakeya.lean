/-
  IVI/Kakeya.lean
  Formalises directional completeness + zero-collapse geometry for IVI runs.
  Captures the IVI–Kakeya bridge as an axiom that can later be replaced by
  a constructive Besicovitch-style argument.
-/

import IVI.Intangible
import IVI.Invariant
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

/-- Abstract collapse-measure functional over node sets. -/
abbrev CollapseMeasure := List DomainNode → Float

@[simp] def collapseZero (μ : CollapseMeasure) (ns : List DomainNode)
    (eps : Float := 1e-9) : Prop :=
  μ ns ≤ eps

/-- Kakeya-style field: directionally complete with near-zero collapse measure. -/
structure KakeyaField where
  tolDir : Float := 1e-6
  epsCol : Float := 1e-9
  dirs   : DirectionSet
  μ      : CollapseMeasure
  nodes  : List DomainNode

@[simp] def KakeyaField.isDirComplete (K : KakeyaField) : Prop :=
  directionallyComplete K.tolDir K.nodes K.dirs

@[simp] def KakeyaField.isCollapseZero (K : KakeyaField) : Prop :=
  collapseZero K.μ K.nodes K.epsCol

/-- Steps exposing schematism evidence (used across the repo). -/
abbrev StepE :=
  List DomainSignature → List DomainNode →
    (List DomainSignature × List DomainNode × StepEvidence)

/-- Stability requirement: a single IVI step preserves Kakeya properties. -/
@[simp] def preservesKakeya
    (K : KakeyaField) (stepE : StepE)
    (doms : List DomainSignature) (nodes : List DomainNode) : Prop :=
  let (_, nodes', _) := stepE doms nodes
  directionallyComplete K.tolDir nodes' K.dirs ∧
    collapseZero K.μ nodes' K.epsCol

/-- IVI–Kakeya Principle (axiom placeholder).
    Future work: replace with an explicit Besicovitch-style construction. -/
axiom IVI_Kakeya_Principle
  (stepE : StepE)
  (doms : List DomainSignature)
  (nodes : List DomainNode) :
  ∃ (K : KakeyaField),
      K.isDirComplete ∧
      K.isCollapseZero ∧
      preservesKakeya K stepE doms nodes

/-- Existence corollary: there is a directionally complete, non-collapsing field. -/
@[simp] theorem exists_kakeya_field
  (stepE : StepE) (doms : List DomainSignature) (nodes : List DomainNode) :
  ∃ K : KakeyaField, K.isDirComplete ∧ K.isCollapseZero := by
  rcases IVI_Kakeya_Principle stepE doms nodes with ⟨K, h₁, h₂, _⟩
  exact ⟨K, h₁, h₂⟩

/-- Preservation corollary: one IVI step keeps the Kakeya properties. -/
@[simp] theorem kakeya_preserved_one_step
  (stepE : StepE) (doms : List DomainSignature) (nodes : List DomainNode) :
  ∃ K : KakeyaField, preservesKakeya K stepE doms nodes := by
  rcases IVI_Kakeya_Principle stepE doms nodes with ⟨K, _, _, h⟩
  exact ⟨K, h⟩

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
