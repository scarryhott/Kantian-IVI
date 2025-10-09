/-
  IVI/Relax.lean
  Converts equality witnesses from `KakeyaContract` + `DeltaPack` into
  relaxed (inequality) predicates with configurable slack.
-/

import IVI.KakeyaBounds
import IVI.Bounds

namespace IVI

open KakeyaBounds

/-- Inequality form for the graininess delta with optional slack. -/
@[simp] def grain_ok_LE (Cg θMax dGrain εg : Float) : Prop :=
  dGrain ≤ Cg * θMax + εg

/-- Inequality form for the entropy delta with optional slack. -/
@[simp] def entropy_ok_LE (Ce θMax dH εe : Float) : Prop :=
  dH ≥ - (Ce * θMax) - εe

/-- Inequality form for the λ-head delta with optional slack. -/
@[simp] def lambda_ok_LE (Cl θMax dLam εl : Float) : Prop :=
  dLam ≤ Cl * θMax + εl

/-- Configuration for the relaxed inequalities. -/
structure RelaxCfg where
  εg : Float := 0.0
  εe : Float := 0.0
  εl : Float := 0.0
  deriving Repr, Inhabited

/-- Bundle the three relaxed predicates into a single statement. -/
@[simp] def relaxedHolds
    (C : KakeyaContract) (d : DeltaPack) (R : RelaxCfg := {}) : Prop :=
  grain_ok_LE C.Cg d.θMax d.grainDiff R.εg ∧
  entropy_ok_LE C.Ce d.θMax d.entropyDiff R.εe ∧
  lambda_ok_LE C.Cl d.θMax d.lambdaDiff R.εl

end IVI
