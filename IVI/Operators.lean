/-
  IVI/Operators.lean
  Pure operators corresponding to IVI actions, formulated abstractly.
  Enhanced to connect with reusable logic helpers.
-/

import IVI.Core
import IVI.Logic

namespace IVI

set_option autoImplicit true

open Classical

noncomputable section

variable {α : Type u} {τ : Type v} [InnerTime τ]

/-- Verify-without-measurement: relate two SVOs via reciprocity and rule. -/
def VWM
  (R : Reciprocity α)
  (rec : Recognition α τ)
  (x y : SVO α)
: Prop :=
  R.relates x.repr y.repr ∧ rec.rule.applies x.repr ∧ rec.rule.applies y.repr

/-- `VWM` coincides with the reusable `compatible` predicate. -/
@[simp] theorem VWM_iff_compatible
    (R : Reciprocity α) (rec : Recognition α τ)
    (x y : SVO α) :
    VWM R rec x y ↔ compatible R rec x y :=
  Iff.rfl

/-- Encode (schematize) an SVO along inner time without collapse. -/
def Encode
  (rec : Recognition α τ)
  (t : τ)
  (x : SVO α)
: SVO α :=
  { repr := rec.schema.tick t x.repr, status := x.status }

/-- Result of a resuperposition step (deductive closure). -/
structure ResuperposeResult (α : Type u) where
  merged : SVO α
  note   : String := "resuperposed"

/-- Resuperpose: fold relational structure back into recognition without measurement. -/
def Resuperpose
  (R : Reciprocity α) (rec : Recognition α τ)
  (xs : List (SVO α))
: Option (ResuperposeResult α) :=
  match xs with
  | []      => none
  | x :: tl =>
    if (∀ y, y ∈ tl → VWM R rec x y) ∧
       (∀ a, a ∈ tl → ∀ b, b ∈ tl → a ≠ b → VWM R rec a b) then
      some { merged := x
            , note := "resuperposed (abstract unity established)" }
    else
      none

/-- Rotate inner time (self-affection) by a delta. -/
def RotateInnerTime
  (rec : Recognition α τ) (Δ : τ) (x : SVO α)
: SVO α :=
  Encode rec Δ x

/-- Convenience predicate bundling an IVI compatibility check. -/
def IVICompatiblePair
  (R : Reciprocity α) (J : IVIJudgment α τ)
  (x y : SVO α)
: Prop :=
  VWM R J.ctx x y

/-- If a list is closed under pairwise VWM, every sublist remains closed. -/
theorem closed_sublist
    {R : Reciprocity α} {rec : Recognition α τ}
    {xs ys : List (SVO α)}
    (h : ys.Sublist xs)
    (hpair : xs.Pairwise (fun a b => VWM R rec a b)) :
    ys.Pairwise (fun a b => VWM R rec a b) :=
  hpair.sublist h

end

end IVI
