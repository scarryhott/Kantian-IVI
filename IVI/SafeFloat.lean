/-
  IVI/SafeFloat.lean
  Safe Float wrapper with NaN/infinity guards.
  
  This file provides a safer abstraction over Float that excludes NaN and infinities,
  making it safe to reason about order properties.
-/

namespace IVI

set_option autoImplicit true

open Classical

noncomputable section

/-- A Float that is guaranteed to be finite (not NaN, not infinity). -/
structure SafeFloat where
  val      : Float
  isFinite : val.isFinite = true
  notNaN   : val.isNaN = false

namespace SafeFloat

/-- Convert a Float to SafeFloat if it's finite. -/
def ofFloat? (x : Float) : Option SafeFloat :=
  if h1 : x.isFinite then
    if h2 : ¬x.isNaN then
      some ⟨x, h1, by simp [h2]⟩
    else none
  else none

/-- Zero is always safe. -/
def zero : SafeFloat :=
  ⟨0.0, by native_decide, by native_decide⟩

/-- One is always safe. -/
def one : SafeFloat :=
  ⟨1.0, by native_decide, by native_decide⟩

/-- Safe addition (returns none if result is not finite). -/
def add (a b : SafeFloat) : Option SafeFloat :=
  ofFloat? (a.val + b.val)

/-- Safe subtraction (returns none if result is not finite). -/
def sub (a b : SafeFloat) : Option SafeFloat :=
  ofFloat? (a.val - b.val)

/-- Safe multiplication (returns none if result is not finite). -/
def mul (a b : SafeFloat) : Option SafeFloat :=
  ofFloat? (a.val * b.val)

/-- Safe division (returns none if result is not finite or divisor is zero). -/
def div (a b : SafeFloat) : Option SafeFloat :=
  if b.val = 0.0 then none
  else ofFloat? (a.val / b.val)

/-- Safe less-than-or-equal comparison (boolean witness). -/
def le (a b : SafeFloat) : Bool :=
  decide (a.val ≤ b.val)

/-- Safe less-than comparison (boolean witness). -/
def lt (a b : SafeFloat) : Bool :=
  decide (a.val < b.val)

/-- Absolute value (safe wrapper). Returns `none` if result isn't finite. -/
def abs (a : SafeFloat) : Option SafeFloat :=
  ofFloat? (Float.abs a.val)

instance : ToString SafeFloat where
  toString a := toString a.val

end SafeFloat

end

/-!
## Transitivity for SafeFloat

With SafeFloat, we can safely assert transitivity because we've excluded NaN.
However, we still axiomatize it rather than proving from IEEE-754 semantics.
-/

/-- Helper: characterise the value stored by `ofFloat?` when it succeeds. -/
lemma SafeFloat.ofFloat?_eq_some {x : Float} {s : SafeFloat}
    (h : SafeFloat.ofFloat? x = some s) : s.val = x := by
  unfold SafeFloat.ofFloat? at h
  by_cases hfin : x.isFinite
  · simp [hfin] at h
    by_cases hnan : ¬x.isNaN
    · simp [hnan] at h
      cases h; rfl
    · simp [hnan] at h
  · simp [hfin] at h

/-- Unfold the value returned by safe addition when it succeeds. -/
lemma SafeFloat.add_val {a b sum : SafeFloat}
    (h : SafeFloat.add a b = some sum) :
    sum.val = a.val + b.val := by
  unfold SafeFloat.add at h
  exact SafeFloat.ofFloat?_eq_some h

/-- Transitivity holds for safe floats (no NaN). -/
theorem SafeFloat.le_trans (a b c : SafeFloat) :
  a.le b = true → b.le c = true → a.le c = true := by
  intro hab hbc
  have hab' : a.val ≤ b.val := by
    simpa [SafeFloat.le] using hab
  have hbc' : b.val ≤ c.val := by
    simpa [SafeFloat.le] using hbc
  have hac' : a.val ≤ c.val := le_trans hab' hbc'
  simpa [SafeFloat.le] using hac'

/-- Addition preserves inequality for safe floats. -/
theorem SafeFloat.add_le_add (a b c d : SafeFloat) :
  a.le b = true → c.le d = true →
  ∀ (sum1 : SafeFloat) (sum2 : SafeFloat),
    a.add c = some sum1 → b.add d = some sum2 →
    sum1.le sum2 = true := by
  intro hab hcd sum1 sum2 hsum1 hsum2
  have hab' : a.val ≤ b.val := by
    simpa [SafeFloat.le] using hab
  have hcd' : c.val ≤ d.val := by
    simpa [SafeFloat.le] using hcd
  have hsum1' : sum1.val = a.val + c.val := SafeFloat.add_val hsum1
  have hsum2' : sum2.val = b.val + d.val := SafeFloat.add_val hsum2
  have hsums : sum1.val ≤ sum2.val := by
    simpa [hsum1', hsum2', add_comm, add_left_comm, add_assoc] using add_le_add hab' hcd'
  simpa [SafeFloat.le] using hsums

end IVI
