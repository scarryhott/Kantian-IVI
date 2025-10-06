/-
  IVI/Domain.lean
  Domain specializations as instances of the pure operators.
-/

import IVI.Core
import IVI.Operators

namespace IVI

set_option autoImplicit true

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
