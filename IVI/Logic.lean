/-
  IVI/Logic.lean
  Strengthen Recognition with reusable predicates; small laws for Reciprocity;
  generic compatibility helpers (still measurement-free).
-/

import IVI.Core

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open Classical

noncomputable section

variable {α : Type u} {τ : Type v} [InnerTime τ]

/-- A recognition lawfulness predicate you can refine per domain. -/
def lawful (rec : Recognition α τ) (x : α) : Prop :=
  rec.rule.applies x

/-- Compatible wrt a recognition and reciprocity: related + lawful on both sides. -/
def compatible (R : Reciprocity α) (rec : Recognition α τ)
  (x y : SVO α) : Prop :=
  R.relates x.repr y.repr ∧ lawful rec x.repr ∧ lawful rec y.repr

/-- Reflexive compatibility when a reflexive closure and lawfulness witness are provided. -/
def compatible_refl_on
  (R : Reciprocity α) (rec : Recognition α τ)
  (hRefl : ∀ a : α, R.relates a a)
  (x : SVO α)
  (hx : lawful rec x.repr)
  : compatible R rec x x :=
by
  exact ⟨hRefl x.repr, hx, hx⟩

/-- Harmonize: if a finite nonempty list is pairwise compatible, we can select a representative
    SVO as “harmonized” without committing to any empirical magnitude. -/
def harmonize (R : Reciprocity α) (rec : Recognition α τ)
  (xs : List (SVO α)) : Option (SVO α) :=
  match xs with
  | []      => none
  | x :: tl =>
    if (∀ y, y ∈ tl → compatible R rec x y) ∧
       (∀ a, a ∈ tl → ∀ b, b ∈ tl → a ≠ b → compatible R rec a b) then
      some x
    else
      none

end

end IVI
