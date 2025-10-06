/-
  IVI/System.lean
  Systematic unity, closure conditions, and reflective invariants.
-/

import IVI.Core
import IVI.Operators
import IVI.Logic

namespace IVI

set_option autoImplicit true

open Classical

structure System (α : Type u) (τ : Type v) [InnerTime τ] where
  R    : Reciprocity α
  recs : List (Recognition α τ)

/-- Reflective invariant: no new rule behaviour emerges for `x`. -/
def invariantAgree {α : Type u} {τ : Type v} [InnerTime τ]
  (S : System α τ) (x : α) : Prop :=
  match S.recs with
  | []      => True
  | r :: rs => ∀ q ∈ rs, (r.rule.applies x) = (q.rule.applies x)

/-- Closure test: all SVOs cohere under IVI across the system. -/
def closedUnderIVI {α : Type u} {τ : Type v} [InnerTime τ]
  (S : System α τ) (xs : List (SVO α)) : Prop :=
  match xs with
  | [] => True
  | x :: tl =>
    (∀ y ∈ tl, ∀ r ∈ S.recs, VWM S.R r x y) ∧
    (∀ a ∈ tl, ∀ b ∈ tl, a ≠ b → ∀ r ∈ S.recs, VWM S.R r a b)

/-- Extract a harmonized representative when the list is IVI-closed. -/
def harmonizeIfClosed {α : Type u} {τ : Type v} [InnerTime τ]
  (S : System α τ) (xs : List (SVO α))
  (h : closedUnderIVI S xs) : Option (SVO α) :=
  match xs with
  | [] => none
  | x :: _ =>
    match S.recs with
    | [] => some x
    | _ :: _ => some x

end IVI
