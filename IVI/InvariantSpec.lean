/-
  IVI/InvariantSpec.lean
  Proof-side (ℝ-based) versions of the invariant lemmas so we avoid Float reasoning.
  Runtime code remains in Float; these are to support Bridge proofs.
-/

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

/-- Spec version of the lambda-vector difference on reals. -/
@[simp] def rVectorMaxDiff : List Real → List Real → Real
  | [], [] => 0
  | x :: xs, [] => max (|x|) (rVectorMaxDiff xs [])
  | [], y :: ys => max (|y|) (rVectorMaxDiff [] ys)
  | x :: xs, y :: ys =>
      let d := |x - y|
      max d (rVectorMaxDiff xs ys)

@[simp] theorem rVectorMaxDiff_nonneg (xs ys : List Real) :
  0 ≤ rVectorMaxDiff xs ys :=
by
  revert ys
  induction xs with
  | nil =>
      intro ys
      cases ys <;> simp [rVectorMaxDiff, abs_nonneg]
  | cons x xs ih =>
      intro ys
      cases ys with
      | nil =>
          have hx : 0 ≤ |x| := abs_nonneg _
          have hy := ih []
          simp [rVectorMaxDiff, hx, hy, max_eq_left]  -- |x| ≥ 0, recursion ≥ 0
      | cons y ys =>
          have hx : 0 ≤ |x - y| := abs_nonneg _
          have hy := ih ys
          -- max of two nonnegative terms ≥ 0
          have hmax : 0 ≤ max |x - y| (rVectorMaxDiff xs ys) :=
            le_max_iff.mpr (Or.inl hx)
          simpa [rVectorMaxDiff] using hmax

@[simp] theorem rVectorMaxDiff_symm (xs ys : List Real) :
  rVectorMaxDiff xs ys = rVectorMaxDiff ys xs :=
by
  revert ys
  induction xs with
  | nil =>
      intro ys
      cases ys <;> simp [rVectorMaxDiff, max_comm]
  | cons x xs ih =>
      intro ys
      cases ys with
      | nil => simp [rVectorMaxDiff, max_comm]
      | cons y ys =>
          have hxy : |x - y| = |y - x| := by
            simpa [sub_eq_add_neg, add_comm] using abs_sub_comm x y
          simp [rVectorMaxDiff, ih ys, hxy, max_comm]

@[simp] theorem rVectorMaxDiff_self_zero (xs : List Real) :
  rVectorMaxDiff xs xs = 0 :=
by
  induction xs with
  | nil => simp [rVectorMaxDiff]
  | cons x xs ih =>
      simp [rVectorMaxDiff, ih, sub_self, abs_zero, max_eq_left]

end IVI
