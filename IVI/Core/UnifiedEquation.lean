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
import Mathlib.Data.Real.Sqrt

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

/-
Auxiliary invariants that mirror the Lightmatter diagnostic checks.
-/

/-- Positive spectral values (λ > 0) used for the spacetime-duality invariant. -/
def SpectrumValue := { λ : ℝ // 0 < λ }

@[simp] lemma spectrum_duality (λ : SpectrumValue) :
    (λ : ℝ) * (λ : ℝ)⁻¹ = (1 : ℝ) := by
  have hλ : (λ : ℝ) ≠ 0 := ne_of_gt λ.property
  simpa [hλ] using mul_inv_cancel hλ

/-- Kakeya sheet deviation δ = 1 - j · ℓ². -/
def sheetDelta (j ℓ : ℝ) : ℝ := 1 - j * ℓ ^ 2

/-- Local sheet time law t(ℓ) = √m · ℓ² (requires m ≥ 0). -/
def tLocal (m ℓ : ℝ) : ℝ := Real.sqrt m * ℓ ^ 2

/--
Using the local sheet time (`tLocal`) eliminates the deviation (δ = 0).
We require m > 0 and ℓ ≠ 0 so that the algebraic manipulations are well-defined.
-/
lemma sheetDelta_zero_of_local_time
    {m ℓ : ℝ} (hm : 0 < m) (hℓ : ℓ ≠ 0) :
    sheetDelta (m * ℓ ^ 2 / (tLocal m ℓ) ^ 2) ℓ = 0 := by
  have hm0 : 0 ≤ m := hm.le
  have hℓ2 : ℓ ^ 2 ≠ 0 := pow_ne_zero _ hℓ
  have hden : tLocal m ℓ ≠ 0 := by
    unfold tLocal
    have hsqrt : Real.sqrt m ≠ 0 := by
      exact ne_of_gt (Real.sqrt_pos.mpr hm)
    have : ℓ ^ 2 ≠ 0 := hℓ2
    exact mul_ne_zero hsqrt this
  have ht_sq :
      (tLocal m ℓ) ^ 2 = m * ℓ ^ 4 := by
        unfold tLocal
        have hsqrt : (Real.sqrt m) ^ 2 = m := by
          simpa [pow_two] using Real.mul_self_sqrt hm0
        have hpow :
            (ℓ ^ 2) ^ 2 = ℓ ^ 4 := by
              simpa [pow_mul] using pow_mul ℓ 2 2
        simp [pow_two, mul_comm, mul_left_comm, mul_assoc, hsqrt, hpow]
  have hℓ4 : ℓ ^ 4 ≠ 0 := pow_ne_zero 4 hℓ
  have hden_sq : (tLocal m ℓ) ^ 2 ≠ 0 := by
    simpa [ht_sq] using mul_ne_zero (ne_of_gt hm) hℓ4
  calc
    sheetDelta (m * ℓ ^ 2 / (tLocal m ℓ) ^ 2) ℓ
        = 1 - (m * ℓ ^ 2 / (tLocal m ℓ) ^ 2) * ℓ ^ 2 := rfl
    _ = 1 - (m * ℓ ^ 2 * ℓ ^ 2) / (tLocal m ℓ) ^ 2 := by
          simp [mul_assoc, mul_comm, mul_left_comm, pow_two]
    _ = 1 - (m * ℓ ^ 4) / (tLocal m ℓ) ^ 2 := by
          simp [pow_two, mul_comm, mul_left_comm, mul_assoc]
    _ = 1 - (tLocal m ℓ) ^ 2 / (tLocal m ℓ) ^ 2 := by
          simpa [ht_sq]
    _ = 1 - 1 := by
          simp [div_self hden_sq]
    _ = 0 := by norm_num

/-- Lightweight lapse scalar (mirrors the Python computation). -/
def lapseScalar (Φ εgrain εflat F G : ℝ) : ℝ :=
  1 + 2 * Φ - εgrain * F + εflat * G

lemma lapseScalar_pos_of_bound
    {Φ εgrain εflat F G lower : ℝ}
    (hlower : 0 < lower)
    (hle : lower ≤ lapseScalar Φ εgrain εflat F G) :
    0 < lapseScalar Φ εgrain εflat F G :=
  lt_of_lt_of_le hlower hle

end IVI
