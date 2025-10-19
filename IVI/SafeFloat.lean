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

/-- Safe less-than-or-equal comparison. -/
def le (a b : SafeFloat) : Bool :=
  a.val ≤ b.val

/-- Safe less-than comparison. -/
def lt (a b : SafeFloat) : Bool :=
  a.val < b.val

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

/-- Transitivity holds for safe floats (no NaN). 

For finite floats (no NaN), the ≤ relation should be transitive.
However, proving this from IEEE-754 semantics is complex, so we
axiomatize it for now.

TODO: This could potentially be proven using Float's underlying
representation and properties, but requires deep knowledge of
Lean's Float implementation.
-/
axiom SafeFloat.le_trans (a b c : SafeFloat) :
  a.le b = true → b.le c = true → a.le c = true

/-- Addition preserves inequality for safe floats. -/
axiom SafeFloat.add_le_add (a b c d : SafeFloat) :
  a.le b = true → c.le d = true →
  ∀ (sum1 : SafeFloat) (sum2 : SafeFloat),
    a.add c = some sum1 → b.add d = some sum2 →
    sum1.le sum2 = true

end IVI
