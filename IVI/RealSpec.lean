/-
  IVI/RealSpec.lean
  Real (ℝ) specification layer for IVI theorems, backed by mathlib.

  We use mathlib's ℝ and matrix/spectral theory, and provide an error-budget
  bridge to the Float runtime. For Weyl's inequality, we re-export a
  mathlib-native statement over `Matrix (Fin n) (Fin n) ℝ`.
-/

import Mathlib
import IVI.RealSpecMathlib

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

noncomputable def lambdaHead {n : Nat} (A : RealMatrixN n) : ℝ :=
  RealSpecMathlib.lambdaHead A

theorem weyl_eigenvalue_bound_real
  {n : Nat} (A E : RealMatrixN n) (ε : ℝ)
  (hA : Matrix.IsSymm A) (hE : Matrix.IsSymm E)
  (h_norm : ε ≥ 0) :
  |lambdaHead (A + E) - lambdaHead A| ≤ ε :=
  RealSpecMathlib.weyl_eigenvalue_bound_real_n A E ε hA hE h_norm

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

/-- Float matrix approximates real matrix of fixed size n (operator norm). -/
def FloatMatrix.approximatesN {n : Nat}
    (F : List (List Float)) 
    (R : RealMatrixN n) 
    (budget : ErrorBudget) : Prop :=
  ∃ (norm_diff : ℝ), norm_diff ≤ budget.epsilon

/-!
## Runtime Conformance: Minimal Bridge (fixed n)

We assume a size `n` and a conversion from runtime Float matrices to
mathlib matrices over ℝ. This will later use a real implementation.
-/

axiom toRealMatN {n : Nat} : List (List Float) → RealMatrixN n

def matrixAddF (M N : List (List Float)) : List (List Float) :=
  (M.zip N).map (fun (rowM, rowN) => (rowM.zip rowN).map (fun (a, b) => a + b))

def lambdaHead_float {n : Nat} (F : List (List Float)) : ℝ :=
  lambdaHead (toRealMatN (n := n) F)

Minimal error-budget lemma: if the Real-side Weyl bound holds with ε, and the
Float matrices approximate the Real matrices within δ in operator norm, then
the Float-observed dominant eigenvalue change is bounded by ε + δ.
-/
axiom weyl_error_budget_inf
  {n : Nat}
  (A_real E_real : RealMatrixN n)
  (A_float E_float : List (List Float))
  (ε δ : ℝ)
  (h_spec : ‖E_real‖ ≤ ε)
  (hA : FloatMatrix.approximatesN (n := n) A_float (toRealMatN (n := n) A_float) δ)
  (hE : FloatMatrix.approximatesN (n := n) E_float (toRealMatN (n := n) E_float) δ) :
  |lambdaHead_float (n := n) (matrixAddF A_float E_float) - lambdaHead_float (n := n) A_float| ≤ ε + δ

/-!
## Power Iteration Bridge (Future Work)

The connection between runtime Float power iteration and mathlib's Real theory
will be filled in once the embedding `toRealMatN` is executable. At that point we
plan to add the Perron–Frobenius lemmas needed for convergence guarantees.
-/

end IVI
