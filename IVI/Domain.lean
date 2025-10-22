/-
  IVI/Domain.lean
  Domain specializations as instances of the pure operators and helpers that
  distinguish the phenomenal (real) and noumenal (complex) layers.
-/

import IVI.Core
import IVI.Operators
import IVI.Kakeya.Core
import IVI.C3Model

namespace IVI

set_option autoImplicit true

/-- Phenomenal resonance space (ordered, Kakeya-rigid). -/
abbrev RealDomain := Dir3

/-- Noumenal potential space (unordered, dissonant). -/
abbrev ComplexDomain := C3Vec

/-- Sublation helper: project a noumenal configuration into the phenomenal frame. -/
@[simp] def projectToReal (v : ComplexDomain) : RealDomain :=
  normaliseDir3 { x := v.r1, y := v.r2, z := v.r3 }

/-- Extract the imaginary displacement that measures noumenal dissonance. -/
@[simp] def imaginaryOffset (v : ComplexDomain) : Dir3 :=
  { x := v.i1, y := v.i2, z := v.i3 }

/-- Coordinates of the imaginary offset are the imaginary components. -/
@[simp]
theorem imaginaryOffset_x (v : ComplexDomain) :
    (imaginaryOffset v).x = v.i1 := rfl

@[simp]
theorem imaginaryOffset_y (v : ComplexDomain) :
    (imaginaryOffset v).y = v.i2 := rfl

@[simp]
theorem imaginaryOffset_z (v : ComplexDomain) :
    (imaginaryOffset v).z = v.i3 := rfl

/-- The imaginary offset vanishes exactly when all imaginary components vanish. -/
@[simp]
theorem imaginaryOffset_eq_zero_iff (v : ComplexDomain) :
    imaginaryOffset v = { x := 0, y := 0, z := 0 } ↔
      v.i1 = 0 ∧ v.i2 = 0 ∧ v.i3 = 0 := by
  cases v with
  | mk r1 i1 r2 i2 r3 i3 =>
      constructor
      · intro h
        have hx := congrArg Dir3.x h
        have hy := congrArg Dir3.y h
        have hz := congrArg Dir3.z h
        simp [imaginaryOffset] at hx hy hz
        exact ⟨hx, ⟨hy, hz⟩⟩
      · intro h
        rcases h with ⟨hx, hy, hz⟩
        have hx' : i1 = 0 := by simpa [imaginaryOffset] using hx
        have hy' : i2 = 0 := by simpa [imaginaryOffset] using hy
        have hz' : i3 = 0 := by simpa [imaginaryOffset] using hz
        simp [imaginaryOffset, hx', hy', hz']

/-- Non-zero imaginary component forces non-zero offset (first coordinate). -/
theorem imaginaryOffset_ne_zero_of_i1_ne
    {v : ComplexDomain} (h : v.i1 ≠ 0) :
    imaginaryOffset v ≠ { x := 0, y := 0, z := 0 } := by
  intro hz
  have := (imaginaryOffset_eq_zero_iff v).mp hz
  exact h this.1

/-- Non-zero imaginary component forces non-zero offset (second coordinate). -/
theorem imaginaryOffset_ne_zero_of_i2_ne
    {v : ComplexDomain} (h : v.i2 ≠ 0) :
    imaginaryOffset v ≠ { x := 0, y := 0, z := 0 } := by
  intro hz
  have := (imaginaryOffset_eq_zero_iff v).mp hz
  exact h this.2.1

/-- Non-zero imaginary component forces non-zero offset (third coordinate). -/
theorem imaginaryOffset_ne_zero_of_i3_ne
    {v : ComplexDomain} (h : v.i3 ≠ 0) :
    imaginaryOffset v ≠ { x := 0, y := 0, z := 0 } := by
  intro hz
  have := (imaginaryOffset_eq_zero_iff v).mp hz
  exact h this.2.2


/-- Provide a simple inner-time instance on natural numbers (ticks). -/
instance Nat.innerTime : InnerTime Nat := ⟨trivial⟩

/-! ### Mathematics -/
namespace Math

abbrev Obj := Nat → Nat

def monotoneRule : Rule Obj :=
  { applies := fun f => ∀ x y, x ≤ y → f x ≤ f y }

def stepSchema : Schema Obj Nat :=
  { tick := fun t f => fun n => f (n + t) }

def recips : Reciprocity Obj :=
  { relates := fun f g => ∀ n, f (n + 1000) = g (n + 1000)
  , symm := by
      intro x y h
      intro n
      exact (h n).symm }

def rec : Recognition Obj Nat :=
  { rule := monotoneRule, schema := stepSchema, sound := by intro x hx; trivial }

def fSVO : SVO Obj := { repr := fun n => n, status := .necessary }

def J : IVIJudgment Obj Nat := { svo := fSVO, ctx := rec }

end Math

/-! ### Physics -/
namespace Physics

structure State where
  tag : String
  deriving Repr

def symmetryRule : Rule State := { applies := fun _ => True }

def evolve : Schema State Nat :=
  { tick := fun t s => { s with tag := s!"{s.tag}@t={t}" } }

def recips : Reciprocity State :=
  { relates := fun _ _ => True
  , symm := by intro _ _ _; trivial }

def rec : Recognition State Nat :=
  { rule := symmetryRule, schema := evolve, sound := by intro x hx; trivial }

def s₁ : SVO State := { repr := { tag := "ψ" }, status := .possible }

def s₂ : SVO State := { repr := { tag := "φ" }, status := .possible }

def J : IVIJudgment State Nat := { svo := s₁, ctx := rec }

end Physics

/-! ### Ethics (Practical Reason) -/
namespace Ethics

structure Maxim where
  desc : String
  deriving Repr

def CI : Rule Maxim := { applies := fun _ => True }

def deliberation : Schema Maxim Nat :=
  { tick := fun _ m => m }

def rec : Recognition Maxim Nat :=
  { rule := CI, schema := deliberation, sound := by intro x hx; trivial }

def tellTruth : SVO Maxim := { repr := { desc := "Tell the truth" }, status := .necessary }

def J : IVIJudgment Maxim Nat := { svo := tellTruth, ctx := rec }

end Ethics

/-! ### Aesthetics (Reflective Judgment) -/
namespace Aesthetics

structure Form where
  signature : String
  deriving Repr

def reflectiveRule : Rule Form := { applies := fun _ => True }

def freePlay : Schema Form Nat :=
  { tick := fun t f => { f with signature := s!"{f.signature}~{t}" } }

def rec : Recognition Form Nat :=
  { rule := reflectiveRule, schema := freePlay, sound := by intro x hx; trivial }

def f₀ : SVO Form := { repr := { signature := "|||" }, status := .possible }

def J : IVIJudgment Form Nat := { svo := f₀, ctx := rec }

end Aesthetics

/-! ### Law / Norms -/
namespace Law

structure Norm where
  name : String
  deriving Repr

def coherence : Rule Norm := { applies := fun _ => True }

def precedent : Schema Norm Nat :=
  { tick := fun t n => { n with name := s!"{n.name}#p{t}" } }

def rec : Recognition Norm Nat :=
  { rule := coherence, schema := precedent, sound := by intro x hx; trivial }

def dueProcess : SVO Norm := { repr := { name := "DueProcess" }, status := .necessary }

def J : IVIJudgment Norm Nat := { svo := dueProcess, ctx := rec }

end Law

end IVI
