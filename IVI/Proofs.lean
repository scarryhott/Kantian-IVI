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

end IVI
