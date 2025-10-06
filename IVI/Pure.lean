/-
  IVI/Pure.lean
  Axioms and scaffolding from pure reason (A1–A12).
-/

import IVI.Core

namespace IVI

set_option autoImplicit true

/-- Subject as carrier of forms and unity. -/
structure Subject (τ : Type u) [InnerTime τ] : Type u where
  deriving Repr

namespace Axioms

/-- A1: All givenness-for-a-subject is ordered by inner time. -/
axiom intuition_time {τ} [InnerTime τ] (s : Subject τ) : True

/-- A2: All thinking-of-an-object proceeds under categories. -/
axiom categories_bind (any : Prop) : True

/-- A3: Unity of apperception. -/
axiom unity_of_apperception : True

/-- A4: Noumenal limit. -/
axiom noumenal_limit : True

/-- A5: Ideas of reason regulate unification. -/
axiom ideas_regulative : True

/-- A6: Schematism is possible. -/
axiom schematism_possible : True

/-- A7: Reciprocity (Community). -/
axiom reciprocity (α : Type u) : Reciprocity α

/-- A8: Synthetic a priori validity is possible. -/
axiom synthetic_apriori_possible : True

/-- A9: Practical reason opens the intelligible standpoint. -/
axiom practical_reason_aperture : True

/-- A10: Reflective judgment seeks rules where none are given. -/
axiom reflective_judgment : True

/-- A11: Verification without empirical collapse is legitimate. -/
axiom non_collapse_legit : True

/-- A12: Reason demands systematic unity. -/
axiom demand_for_system : True

end Axioms

end IVI
