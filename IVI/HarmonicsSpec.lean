/-
  IVI/HarmonicsSpec.lean
  Proof-side contract for graininess-style quantities.
  These axioms/lemmas act as a shim so constructive Kakeya arguments can
  proceed without expanding the full Float-based implementation. They can be
  discharged later against the concrete definitions in `IVI/Harmonics`.
-/

import IVI.Harmonics

namespace IVI

set_option autoImplicit true

/-- Graininess is non-negative. -/
axiom graininessScore_nonneg (S : List (List Float)) :
  0.0 ≤ graininessScore S

/-- Symmetrising does not increase graininess. -/
axiom graininessScore_symm_le
  (M : List (List Float)) :
  graininessScore (symmetriseLL M) ≤ graininessScore M

/-- Lipschitz-style stability for graininess under small perturbations. -/
axiom graininessScore_lipschitz
  (Cg : Float)
  (S₁ S₂ : List (List Float)) :
  (∀ row₁ ∈ S₁, ∀ row₂ ∈ S₂, Float.abs (row₁.foldl (·+·) 0.0 - row₂.foldl (·+·) 0.0) ≤ Cg) →
  Float.abs (graininessScore S₁ - graininessScore S₂) ≤ Cg

/-- Simplified additivity upper bound for merged graininess. -/
axiom graininessScore_merge_le
  (S₁ S₂ : List (List Float)) :
  graininessScore (S₁ ++ S₂) ≤ graininessScore S₁ + graininessScore S₂

end IVI

