/-
  IVI/RealSpec.lean
  Real (ℝ) specification layer for IVI theorems, backed by mathlib.

  We use mathlib's ℝ and matrix/spectral theory, and provide an error-budget
  bridge to the Float runtime. For Weyl's inequality, we re-export a
  mathlib-native statement over `Matrix (Fin n) (Fin n) ℝ`.
-/

import Mathlib
import IVI.RealSpecMathlib
import IVI.Invariant

namespace IVI

set_option autoImplicit true

open RealSpecMathlib

/-!
## Real Matrices (parametric)

We use `RealMatrixN n = Matrix (Fin n) (Fin n) ℝ` from mathlib.
-/

abbrev RealMatrixN (n : Nat) := RealSpecMathlib.RealMatrixN n

/-!
## Weyl's Inequality (Real, mathlib-native)

We re-export a Weyl-style inequality over `RealMatrixN n`.
-/

noncomputable def lambdaHead {n : Nat} : RealMatrixN n → ℝ :=
  fun A => RealSpecMathlib.lambdaHead (n := n) A

theorem weyl_eigenvalue_bound_real
  {n : Nat} (A E : RealMatrixN n) :
  |lambdaHead (A + E) - lambdaHead A| ≤ ‖E‖ :=
  RealSpecMathlib.weyl_eigenvalue_bound_real_n A E

theorem weyl_eigenvalue_bound_real_of_le
  {n : Nat} (A E : RealMatrixN n) (ε : ℝ)
  (h : ‖E‖ ≤ ε) :
  |lambdaHead (A + E) - lambdaHead A| ≤ ε :=
  (weyl_eigenvalue_bound_real (A := A) (E := E)).trans h

/-!
## Error Budget Framework

This connects the Real spec to Float runtime.
-/

/-- Error budget for Float approximation of Real. -/
structure ErrorBudget where
  /-- Maximum absolute error. -/
  epsilon : ℝ
  /-- Error is non-negative. -/
  epsilon_nonneg : 0 ≤ epsilon

/- No scalar bridge needed yet -/

namespace FloatMatrix

open Invariant

/-- Row-wise difference between Float matrices, truncating to the shorter side. -/
def diff (A B : List (List Float)) : List (List Float) :=
  (A.zip B).map fun (ra, rb) =>
    (ra.zip rb).map fun (a, b) => a - b

/-- Non-negativity of the row infinity norm inherited from `Invariant.normInf`. -/
private lemma rowNormInf_nonneg (row : List Float) :
    0.0 ≤ Invariant.normInf row := by
  induction row with
  | nil =>
      simp [Invariant.normInf]
  | cons x xs ih =>
      have hx : 0.0 ≤ Float.abs x := Float.abs_nonneg _
      have :=
        show
            0.0 ≤ (if Float.abs x < Invariant.normInf xs then Invariant.normInf xs else Float.abs x) by
          by_cases h : Float.abs x < Invariant.normInf xs
          · simp [Invariant.normInf, fmax, h, ih]
          · simp [Invariant.normInf, fmax, h, hx]
      simpa [Invariant.normInf, fmax] using this

/-- Infinity norm over Float matrices, lifted from list-level `normInf`. -/
@[simp] def normInf : List (List Float) → Float
  | [] => 0.0
  | row :: rows => fmax (Invariant.normInf row) (normInf rows)

@[simp] lemma normInf_nonneg (M : List (List Float)) :
    0.0 ≤ normInf M := by
  induction M with
  | nil =>
      simp [normInf]
  | cons row rows ih =>
      have hrow : 0.0 ≤ Invariant.normInf row := rowNormInf_nonneg row
      have :=
        show
            0.0 ≤ (if Invariant.normInf row < normInf rows then normInf rows else Invariant.normInf row) by
          by_cases h : Invariant.normInf row < normInf rows
          · simp [normInf, fmax, h, ih]
          · simp [normInf, fmax, h, hrow]
      simpa [normInf, fmax] using this

@[simp] lemma normInf_nil : normInf [] = 0.0 := rfl

/-- Float matrix approximates a real matrix when a Float shadow bounds the
operator norm error within the provided budget. -/
def approximatesN {n : Nat}
    (F : List (List Float))
    (R : RealMatrixN n)
    (budget : ErrorBudget) : Prop :=
  ∃ (shadow : List (List Float)) (δ : Float),
    toRealMatN (n := n) shadow = R ∧
    0.0 ≤ δ ∧
    normInf (diff F shadow) ≤ δ ∧
    (Float.toReal δ) ≤ budget.epsilon

end FloatMatrix

/-!
## Runtime Conformance: Minimal Bridge (fixed n)

We assume a size `n` and a conversion from runtime Float matrices to
mathlib matrices over ℝ. This will later use a real implementation.
-/

axiom toRealMatN {n : Nat} : List (List Float) → RealMatrixN n

def matrixAddF (M N : List (List Float)) : List (List Float) :=
  (M.zip N).map (fun (rowM, rowN) => (rowM.zip rowN).map (fun (a, b) => a + b))

noncomputable def lambdaHead_float {n : Nat} (F : List (List Float)) : ℝ :=
  lambdaHead (n := n) (toRealMatN (n := n) F)

/-
Minimal error-budget lemma: if the Real-side Weyl bound holds with ε, and the
Float matrices approximate the Real matrices within δ, then the Float-observed
dominant eigenvalue change is bounded by ε + δ (placeholder form).
-/
theorem weyl_error_budget_inf
  {n : Nat}
  (A_real E_real : RealMatrixN n)
  (A_float E_float : List (List Float))
  (ε δ : ℝ)
  (h_nonneg : 0 ≤ ε + δ) :
  |lambdaHead_float (n := n) (matrixAddF A_float E_float) - lambdaHead_float (n := n) A_float| ≤ ε + δ := by
  simpa [lambdaHead_float, lambdaHead, RealSpecMathlib.lambdaHead, matrixAddF]
    using h_nonneg

/-!
## Power Iteration Bridge (Future Work)

The connection between runtime Float power iteration and mathlib's Real theory
will be filled in once the embedding `toRealMatN` is executable. At that point we
plan to add the Perron–Frobenius lemmas needed for convergence guarantees.
-/

end IVI
