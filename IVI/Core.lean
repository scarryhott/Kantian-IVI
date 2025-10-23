/-
  IVI/Core.lean
  Minimal primitives for IVI “from pure reason.”
-/

namespace IVI

set_option autoImplicit true

/-- Kantian Modality (status of a claim). -/
inductive Modality
| possible
| actual
| necessary
  deriving DecidableEq, Repr

/-- Kantian category families (renamed to avoid clashes). -/
inductive CategoryQuantity
| unity | plurality | totality
  deriving DecidableEq, Repr

inductive CategoryQuality
| reality | negation | limitation
  deriving DecidableEq, Repr

inductive CategoryRelation
| inherence | causality | community
  deriving DecidableEq, Repr

inductive CategoryModality
| possibility | actuality | necessity
  deriving DecidableEq, Repr

/-- Minimal inner-time class: provides a preorder capturing Kantian inner time. -/
class InnerTime (τ : Type u) : Type u where
  /-- Reflexive ordering capturing "before or at" in inner time. -/
  before : τ → τ → Prop
  /-- Reflexivity of the inner-time ordering. -/
  refl   : ∀ t, before t t
  /-- Transitivity of the inner-time ordering. -/
  trans  : ∀ {a b c}, before a b → before b c → before a c

/-- Intuition bundle (forms available to a subject). -/
structure Intuition (τ : Type u) [InnerTime τ] : Type u where
  time : τ
  deriving Repr

/-- A rule (concept) as a recognitional constraint. -/
structure Rule (α : Type u) : Type u where
  applies : α → Prop

/-- A schema is the time-determination that lets a rule address appearances. -/
structure Schema (α : Type u) (τ : Type v) [InnerTime τ] : Type (max u v) where
  tick : τ → α → α

/-- Subjectively viewed object (object-for-a-subject). -/
structure SVO (α : Type u) : Type u where
  repr   : α
  status : IVI.Modality
  deriving Repr

/-- Recognition records the pure structure of IVI verification. -/
structure Recognition (α : Type u) (τ : Type v) [InnerTime τ] : Type (max u v) where
  rule   : Rule α
  schema : Schema α τ
  sound  : ∀ x, rule.applies x → True

/-- An IVI judgment pairs an SVO with a recognition context. -/
structure IVIJudgment (α : Type u) (τ : Type v) [InnerTime τ] : Type (max u v) where
  svo  : SVO α
  ctx  : Recognition α τ

/-- Reciprocity (“Community”) as a symmetric relation. -/
structure Reciprocity (α : Type u) : Type u where
  relates : α → α → Prop
  symm    : ∀ {x y}, relates x y → relates y x

end IVI
