/-
  IVI/FloatSpec.lean
  Placeholder lemmas capturing the intent of transferring analytic (real)
  bounds down to `Float`.  These are axiomatically stated today so that the
  plumbing compiles; replace them with constructive proofs once a concrete
  Float→ℝ story is available.
-/

namespace IVI

@[simp] def ulpBudget (x : Float) : Float := Float.abs x * 1e-7

/-- Stub: treat a `Float` as if it were already a real-valued quantity. -/
@[simp] def toReal (x : Float) : Float := x

/-- Placeholder inequality transfer. -/
axiom float_transfer_le
  (r R : Float) (h : r ≤ R) : toReal r ≤ toReal R + ulpBudget R

/-- Placeholder absolute-error transfer. -/
axiom float_transfer_abs_le
  (r R ε : Float) (h : Float.abs (r - R) ≤ ε) :
    toReal r ≤ toReal R + (ε + ulpBudget R)

/-- Absolute-difference control implies an additive upper bound.
    This axiom encapsulates the intended Float↔ℝ transfer:
    if |r - R| ≤ ε then r ≤ R + ε. -/
axiom abs_sub_le_add
  (r R ε : Float) :
  Float.abs (r - R) ≤ ε → r ≤ R + ε

end IVI
