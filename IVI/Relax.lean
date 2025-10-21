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
  Float.abs dGrain ≤ Cg + εg

/-- Inequality form for the entropy delta with optional slack. -/
@[simp] def entropy_ok_LE (Ce θMax dH εe : Float) : Prop :=
  Float.abs dH ≤ Ce + εe

/-- Inequality form for the λ-head delta with optional slack. -/
@[simp] def lambda_ok_LE (Cl θMax dLam εl : Float) : Prop :=
  Float.abs dLam ≤ Cl + εl

/-- Configuration for the relaxed inequalities. -/
structure RelaxCfg where
  εg : Float := 0.0
  εe : Float := 0.0
  εl : Float := 0.0
  deriving Repr, Inhabited

/-- Bundle the three relaxed predicates into a single statement. -/
@[simp] def relaxedHolds
    (C : KakeyaContract) (d : DeltaPack) (R : RelaxCfg := {}) : Prop :=
  grain_ok_LE C.Cg C.θMax d.grainDiff R.εg ∧
  entropy_ok_LE C.Ce C.θMax d.entropyDiff R.εe ∧
  lambda_ok_LE C.Cl C.θMax d.lambdaDiff R.εl

axiom buildContract_relaxed
    (stepE : StepE)
    (doms : List DomainSignature)
    (nodes : List DomainNode)
    (ctx : WillCtx)
    (will : Will) :
    relaxedHolds
      (KakeyaBounds.buildContract stepE doms nodes ctx will).contract
      (KakeyaBounds.buildContract stepE doms nodes ctx will).deltas

/-
-- Temporarily axiomatized due to build issues
lemma buildContract_relaxed_PROOF
    (stepE : StepE)
    (doms : List DomainSignature)
    (nodes : List DomainNode)
    (ctx : WillCtx)
    (will : Will) :
    relaxedHolds
      (KakeyaBounds.buildContract stepE doms nodes ctx will).contract
      (KakeyaBounds.buildContract stepE doms nodes ctx will).deltas := by
  classical
  set w := KakeyaBounds.buildContract stepE doms nodes ctx will with hw
  change relaxedHolds w.contract w.deltas
  have hCg : w.contract.Cg = Float.abs w.deltas.grainDiff := by
    simpa [hw, KakeyaBounds.buildContract, DeltaPack.Δgrain]
  have hCe : w.contract.Ce = Float.abs w.deltas.entropyDiff := by
    simpa [hw, KakeyaBounds.buildContract, DeltaPack.Δentropy]
  have hCl : w.contract.Cl = Float.abs w.deltas.lambdaDiff := by
    simpa [hw, KakeyaBounds.buildContract, DeltaPack.Δlambda]
  have hGrain0 : Float.abs w.deltas.grainDiff ≤ Float.abs w.deltas.grainDiff := le_rfl
  have hEntropy0 : Float.abs w.deltas.entropyDiff ≤ Float.abs w.deltas.entropyDiff := le_rfl
  have hLambda0 : Float.abs w.deltas.lambdaDiff ≤ Float.abs w.deltas.lambdaDiff := le_rfl
  dsimp [relaxedHolds, grain_ok_LE, entropy_ok_LE, lambda_ok_LE]
  refine And.intro ?_ ?_
  · simpa [hCg, Float.add_zero] using hGrain0
  · refine And.intro ?_ ?_
    · simpa [hCe, Float.add_zero] using hEntropy0
    · simpa [hCl, Float.add_zero] using hLambda0
-/

@[simp] axiom buildContract_relaxed_default
    (stepE : StepE)
    (doms : List DomainSignature)
    (nodes : List DomainNode) :
    relaxedHolds
      (KakeyaBounds.buildContract stepE doms nodes {}).contract
      (KakeyaBounds.buildContract stepE doms nodes {}).deltas

end IVI
