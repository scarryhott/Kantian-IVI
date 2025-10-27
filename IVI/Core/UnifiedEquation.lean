/-
  IVI/Core/UnifiedEquation.lean

  Minimal abstractions for the unified IVI equation

    S_{t+1} = K (Q(t) ∘ F (S_t))
    dS/dt  = Q(t) (F S) - λ ∇K(S)

  These definitions stay intentionally lightweight: they capture the operator
  interface without committing to a concrete state space. Projects can refine
  them by supplying instances, metrics, and analytic properties.
-/

import Mathlib.Data.Real.Basic

namespace IVI

/-- Metric information for an IVI state space. -/
structure IState (S : Type _) where
  dist : S → S → ℝ
  complete : Prop

/-- Fractal expansion operator. -/
structure Fractal (S : Type _) where
  run : S → S
  lipschitz : Prop := True
  monotone : Prop := True

/-- Quaternion (or symmetry) flow operator. -/
structure QFlow (S : Type _) where
  run : ℝ → S → S
  isometry : Prop := True

/-- Kakeya-style coherence projection. -/
structure Kakeya (S : Type _) where
  run : S → S
  nonexpansive : Prop := True
  idempotent : Prop := True

/-- Bundle the discrete-time dynamics. -/
structure IVIDynamics (S : Type _) where
  fractal : Fractal S
  flow : QFlow S
  kakeya : Kakeya S

namespace IVIDynamics

/-- Discrete IVI step: expand → guide → flatten. -/
def step {S} (dyn : IVIDynamics S) (t : ℝ) (s : S) : S :=
  dyn.kakeya.run (dyn.flow.run t (dyn.fractal.run s))

end IVIDynamics

/-- Continuous-time data: adds the λ parameter and a Kakeya gradient. -/
structure IVIDynamicsODE (S : Type _) extends IVIDynamics S where
  lambda : ℝ
  gradK : S → S

/-- Flattening data returned by `IVIDynamicsODE.flattening`. -/
structure Flattening (S : Type _) where
  weight : ℝ
  direction : S

namespace IVIDynamicsODE

/-- Right-hand side of the growth term Q(t) ∘ F. -/
def growth {S} (dyn : IVIDynamicsODE S) (t : ℝ) (s : S) : S :=
  dyn.flow.run t (dyn.fractal.run s)

/--
Flattening contribution λ ∇K(S).  The caller subtracts this from `growth`
when assembling the full differential equation.
-/
def flattening {S} (dyn : IVIDynamicsODE S) (s : S) : Flattening S :=
  { weight := dyn.lambda, direction := dyn.gradK s }

end IVIDynamicsODE

end IVI
