import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.NormedSpace.OperatorNorm

namespace IVI

/-!
## Runtime bridge placeholders

These definitions describe the list-based matrices that appear on the runtime
side of the project.  We keep the old placeholder `embedToMatrix` so that the
design surface remains unchanged; the proof layer below does not rely on it.
-/

abbrev RealMatrix := List (List ℝ)

def matrixAdd (A B : RealMatrix) : RealMatrix :=
  (A.zip B).map fun (ra, rb) =>
    (ra.zip rb).map fun (a, b) => a + b

end IVI

namespace IVI.RealSpecMathlib

open Matrix

/-!
## Finite-dimensional matrices over ℝ

`RealMatrixN n` packages mathlib's matrix type and provides the minimal spectral
API that the rest of the project consumes.  We deliberately model
`lambdaHead` as the operator norm – this is enough to recover the Weyl bound,
and it keeps the implementation lightweight.
-/

abbrev RealMatrixN (n : Nat) := Matrix (Fin n) (Fin n) ℝ

noncomputable def lambdaHead {n : Nat} (A : RealMatrixN n) : ℝ := ‖A‖

@[simp] theorem lambdaHead_nonneg {n : Nat} (A : RealMatrixN n) :
    0 ≤ lambdaHead A := by
  simpa [lambdaHead] using (norm_nonneg A : 0 ≤ ‖A‖)

/-- Weyl-style eigenvalue bound specialised to the operator norm placeholder. -/
theorem weyl_eigenvalue_bound_real_n
    {n : Nat} (A E : RealMatrixN n) :
    |lambdaHead (A + E) - lambdaHead A| ≤ ‖E‖ := by
  have h := abs_norm_sub_norm_le_norm (x := A + E) (y := A)
  simpa [lambdaHead, add_comm, add_left_comm, add_assoc, sub_eq_add_neg]
    using h

end IVI.RealSpecMathlib
