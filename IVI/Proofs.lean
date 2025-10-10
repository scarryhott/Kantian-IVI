/-
  IVI/Proofs.lean
  Small, fully-proven lemmas that strengthen your core without mathlib.
  No sorry, no axioms; all results use your existing abstractions.
-/

import IVI.Core
import IVI.Logic
import IVI.Operators
import IVI.System

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open Classical

variable {α : Type u} {τ : Type v} [InnerTime τ]

/-- `VWM` is symmetric provided `Reciprocity` is symmetric. -/
theorem VWM_symm
  (R : Reciprocity α) (rec : Recognition α τ)
  (x y : SVO α)
  : VWM R rec x y → VWM R rec y x := by
  intro h
  rcases h with ⟨hR, hx, hy⟩
  refine And.intro ?_ ?_
  · exact R.symm hR
  · exact And.intro hy hx

/-- `VWM` is reflexive when the base relation and rule witness the subject. -/
theorem VWM_refl
  (R : Reciprocity α) (rec : Recognition α τ)
  (x : SVO α)
  (hR : R.relates x.repr x.repr)
  (hx : rec.rule.applies x.repr)
  : VWM R rec x x := by
  exact ⟨hR, hx, hx⟩

/-- The bridge lemma in both directions, as a named theorem. -/
@[simp] theorem compatible_iff_VWM
  (R : Reciprocity α) (rec : Recognition α τ)
  (x y : SVO α)
  : compatible R rec x y ↔ VWM R rec x y := by
  -- definitionally equal in this codebase; keep as a simp lemma for ergonomics
  rfl

/-- `harmonize` always succeeds on a singleton input. -/
@[simp] theorem harmonize_singleton
  (R : Reciprocity α) (rec : Recognition α τ) (x : SVO α)
  : harmonize R rec [x] = some x := by
  unfold harmonize
  have h₁ : (∀ y : SVO α, y ∈ ([] : List (SVO α)) → compatible R rec x y) := by
    intro y hy; cases hy
  have h₂ : (∀ a : SVO α, a ∈ ([] : List (SVO α)) → ∀ b : SVO α,
      b ∈ ([] : List (SVO α)) → a ≠ b → compatible R rec a b) := by
    intro a ha; cases ha
  exact if_pos ⟨h₁, h₂⟩

/-- `Resuperpose` succeeds on a singleton and returns the head with the expected note. -/
@[simp] theorem Resuperpose_singleton
  (R : Reciprocity α) (rec : Recognition α τ) (x : SVO α)
  : Resuperpose R rec [x] =
      some { merged := x, note := "resuperposed (abstract unity established)" } := by
  unfold Resuperpose
  have h₁ : (∀ y : SVO α, y ∈ ([] : List (SVO α)) → VWM R rec x y) := by
    intro y hy; cases hy
  have h₂ : (∀ a : SVO α, a ∈ ([] : List (SVO α)) → ∀ b : SVO α,
      b ∈ ([] : List (SVO α)) → a ≠ b → VWM R rec a b) := by
    intro a ha; cases ha
  exact
    if_pos ⟨h₁, h₂⟩

/-- Building closure incrementally:
    if a list is IVI-closed and a new element is compatible with all its members,
    the cons-list remains pairwise-IVI-closed. -/
theorem closedUnderIVI_cons
  (R : Reciprocity α) (rec : Recognition α τ)
  {xs : List (SVO α)} {x : SVO α}
  (hpair : xs.Pairwise (fun a b => VWM R rec a b))
  (hall  : ∀ a ∈ xs, VWM R rec x a)
  : (x :: xs).Pairwise (fun a b => VWM R rec a b) := by
  apply List.Pairwise.cons
  · intro b hb
    exact hall b hb
  · exact hpair

/-- `compatible` inherits the symmetry of the underlying `Reciprocity`. -/
theorem compatible_symm
  (R : Reciprocity α) (rec : Recognition α τ)
  (x y : SVO α)
  : compatible R rec x y → compatible R rec y x := by
  intro h
  have hVWM : VWM R rec x y := (VWM_iff_compatible R rec x y).mp h
  exact (VWM_iff_compatible R rec y x).mpr (VWM_symm R rec x y hVWM)

/-- Pulls out the head-side compatibility guaranteed by `closedUnderIVI`. -/
theorem closedUnderIVI_head_rel
  (S : System α τ)
  {x : SVO α} {xs : List (SVO α)}
  (h : closedUnderIVI S (x :: xs))
  {rec : Recognition α τ}
  (hRec : rec ∈ S.recs)
  {y : SVO α}
  (hy : y ∈ xs) :
  VWM S.R rec x y := by
  rcases h with ⟨hHead, _⟩
  exact hHead y hy rec hRec

/-- Pulls out the tail-side compatibility guaranteed by `closedUnderIVI`. -/
theorem closedUnderIVI_tail_rel
  (S : System α τ)
  {x : SVO α} {xs : List (SVO α)}
  (h : closedUnderIVI S (x :: xs))
  {rec : Recognition α τ}
  (hRec : rec ∈ S.recs)
  {a b : SVO α}
  (ha : a ∈ xs) (hb : b ∈ xs)
  (hne : a ≠ b) :
  VWM S.R rec a b := by
  rcases h with ⟨_, hTail⟩
  exact hTail a ha b hb hne rec hRec

/-- Harmonization over a closed nonempty list always returns the head representative. -/
@[simp] theorem harmonizeIfClosed_cons
  (S : System α τ)
  (x : SVO α) (xs : List (SVO α))
  (h : closedUnderIVI S (x :: xs)) :
  harmonizeIfClosed S (x :: xs) h = some x := by
  cases S.recs with
  | nil => simp [harmonizeIfClosed]
  | cons _ _ => simp [harmonizeIfClosed]

/-- Harmonization over the empty list produces no representative. -/
@[simp] theorem harmonizeIfClosed_nil
  (S : System α τ)
  (h : closedUnderIVI S ([] : List (SVO α))) :
  harmonizeIfClosed S [] h = none := by
  simp [harmonizeIfClosed]

end IVI
