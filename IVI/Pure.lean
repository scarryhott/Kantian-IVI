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

namespace FromIThink

open Axioms

universe u

/--
"The 'I think' must be able to accompany all my representations" (B131–B132).
Packages the Kantian a priori thread that radiates from this condition.
-/
structure Thread (τ : Type u) [InnerTime τ] (s : Subject τ) : Type (max (u+2) 1) where
  /--
  "The 'I think' must be able to accompany all my representations" (B131–B132).
  -/
  iThink : Prop
  /-- Witness that the transcendental apperception actually accompanies the manifold. -/
  iThinkWitness : iThink
  /--
  "Time is the formal condition a priori of all appearances whatsoever" (A33/B49).
  -/
  formOfInnerTime : iThink → True
  /--
  "The same function which gives unity to the different representations in a judgement
  also gives unity to the mere synthesis of different representations in an intuition"
  (A79/B104).
  -/
  categoriesForJudgment : ∀ {_ : Prop}, iThink → True
  /--
  "This transcendental unity of apperception is that unity through which all the
  manifold given in an intuition is united" (B135).
  -/
  apperceptiveUnity : iThink → True
  /--
  "The concept of a noumenon is therefore merely a limiting concept" (A255/B311).
  -/
  noumenalBoundary : iThink → True
  /--
  "The ideas of pure reason have a necessary regulative use" (A642/B670).
  -/
  regulativeIdeas : iThink → True
  /--
  "This schematism of our understanding... is a transcendental product of the imagination" (A140/B179).
  -/
  schematismBridge : iThink → True
  /--
  "All substances, insofar as they can be perceived as coexisting in space, are in
  thoroughgoing interaction" (B256).
  -/
  reciprocityCommunity : ∀ {α : Type u}, iThink → Reciprocity α
  /--
  "Synthetic judgments a priori are therefore possible" (B19–B20).
  -/
  syntheticApriori : iThink → True
  /--
  "Practical reason of itself gives reality to a supersensible object of the faculty of desire" (KPV 5:42).
  -/
  practicalStandpoint : iThink → True
  /--
  "Reflective judgment, which is supposed to ascend from the particular in nature to the universal, requires a principle" (CJ 5:179).
  -/
  reflectiveSearch : iThink → True
  /--
  "A hypothesis is allowable only as a means of bringing unity into the manifold of knowledge, so far as that unity rests upon experience" (A820/B848).
  -/
  nonCollapse : iThink → True
  /--
  "Reason demands a system in accordance with its own concepts" (A833/B861).
  -/
  systemDemand : iThink → True

/-- Canonical instantiation of the thread using the base axioms. -/
noncomputable def canonical (τ : Type u) [InnerTime τ] (s : Subject τ) : Thread τ s where
  iThink := True
  iThinkWitness := Axioms.unity_of_apperception
  formOfInnerTime := fun _ => Axioms.intuition_time s
  categoriesForJudgment := fun {any} _ => Axioms.categories_bind any
  apperceptiveUnity := fun _ => Axioms.unity_of_apperception
  noumenalBoundary := fun _ => Axioms.noumenal_limit
  regulativeIdeas := fun _ => Axioms.ideas_regulative
  schematismBridge := fun _ => Axioms.schematism_possible
  reciprocityCommunity := fun {α} _ => Axioms.reciprocity α
  syntheticApriori := fun _ => Axioms.synthetic_apriori_possible
  practicalStandpoint := fun _ => Axioms.practical_reason_aperture
  reflectiveSearch := fun _ => Axioms.reflective_judgment
  nonCollapse := fun _ => Axioms.non_collapse_legit
  systemDemand := fun _ => Axioms.demand_for_system

end FromIThink

end IVI
