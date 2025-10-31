/-
  IVI/FloatSpec.lean
  Placeholder lemmas capturing the intent of transferring analytic (real)
  bounds down to `Float`.  These are axiomatically stated today so that the
  plumbing compiles; replace them with constructive proofs once a concrete
  Float→ℝ story is available.
-/

namespace IVI

@[simp] def ulpBudget (x : Float) : Float := Float.abs x * Float.abs (1e-7)

/-- Stub: treat a `Float` as if it were already a real-valued quantity.  For our
numeric wrappers we simply reuse the original value. -/
@[simp] def toReal (x : Float) : Float := x

private lemma ulpBudget_nonneg (R : Float) : 0 ≤ ulpBudget R := by
  have h₁ : 0 ≤ Float.abs R := Float.abs_nonneg _
  have h₂ : 0 ≤ Float.abs (1e-7) := Float.abs_nonneg _
  simpa [ulpBudget] using mul_nonneg h₁ h₂

/-- Inequality transfer from a "real" bound to a Float bound with a small
ulp-budget slack. -/
theorem float_transfer_le
  (r R : Float) (h : r ≤ R) : toReal r ≤ toReal R + ulpBudget R := by
  have hBudget : 0 ≤ ulpBudget R := ulpBudget_nonneg R
  have h' : R ≤ R + ulpBudget R := by
    simpa using le_add_of_nonneg_right hBudget
  simpa [toReal] using le_trans h h'

/-- Transfer an absolute error bound to an additive Float bound with a small
ulp-budget slack. -/
theorem float_transfer_abs_le
  (r R ε : Float) (h : Float.abs (r - R) ≤ ε) :
    toReal r ≤ toReal R + (ε + ulpBudget R) := by
  have hBudget : 0 ≤ ulpBudget R := ulpBudget_nonneg R
  have h₁ : r ≤ R + ε := by
    have hbound : r - R ≤ ε := (abs_le.mp h).2
    simpa [sub_eq_add_neg, add_comm, add_left_comm, add_assoc] using sub_le_iff_le_add.mp hbound
  have h₂ : R + ε ≤ R + (ε + ulpBudget R) := by
    have := le_add_of_nonneg_right hBudget
    have := add_le_add_left this R
    simpa [add_comm, add_left_comm, add_assoc] using this
  simpa [toReal, add_comm, add_left_comm, add_assoc] using le_trans h₁ h₂

/-- Absolute-difference control implies an additive upper bound. -/
theorem abs_sub_le_add
  (r R ε : Float) :
  Float.abs (r - R) ≤ ε → r ≤ R + ε := by
  intro h
  have hbound : r - R ≤ ε := (abs_le.mp h).2
  simpa [sub_eq_add_neg, add_comm, add_left_comm, add_assoc] using sub_le_iff_le_add.mp hbound

/-- Reflexivity for the Float order. -/
theorem le_self (x : Float) : x ≤ x :=
  le_rfl

end IVI
