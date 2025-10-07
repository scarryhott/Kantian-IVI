/-
  IVI/SchematismEvidence.lean
  Minimal runtime evidence for schematism usage.
-/

namespace IVI

set_option autoImplicit true

/-- Runtime-visible evidence that the step used the θ/Δi schematism rule. -/
structure StepEvidence where
  usedSchematism : Bool := true
  deriving Repr

/-- Lift to a Prop for Bridge proofs. -/
@[simp] def schematismPredicate (e : StepEvidence) : Prop :=
  e.usedSchematism = true

/-- The predicate is definitionally the underlying boolean flag. -/
@[simp] theorem schematismPredicate_iff (ev : StepEvidence) :
    schematismPredicate ev ↔ ev.usedSchematism = true := Iff.rfl

end IVI
