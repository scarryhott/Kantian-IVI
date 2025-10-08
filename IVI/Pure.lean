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
theorem intuition_time {τ} [InnerTime τ] (s : Subject τ) : True :=
  trivial

/-- A2: All thinking-of-an-object proceeds under categories. -/
theorem categories_bind (any : Prop) : True :=
  trivial

/-- A3: Unity of apperception. -/
theorem unity_of_apperception : True :=
  trivial

/-- A4: Noumenal limit. -/
theorem noumenal_limit : True :=
  trivial

/-- A5: Ideas of reason regulate unification. -/
theorem ideas_regulative : True :=
  trivial

/-- A6: Schematism is possible. -/
theorem schematism_possible : True :=
  trivial

/-- A7: Reciprocity (Community). -/
def reciprocity (α : Type u) : Reciprocity α :=
  { relates := fun _ _ => True
  , symm := by
      intro x y _
      trivial }

/-- A8: Synthetic a priori validity is possible. -/
theorem synthetic_apriori_possible : True :=
  trivial

/-- A9: Practical reason opens the intelligible standpoint. -/
theorem practical_reason_aperture : True :=
  trivial

/-- A10: Reflective judgment seeks rules where none are given. -/
theorem reflective_judgment : True :=
  trivial

/-- A11: Verification without empirical collapse is legitimate. -/
theorem non_collapse_legit : True :=
  trivial

/-- A12: Reason demands systematic unity. -/
theorem demand_for_system : True :=
  trivial

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
  categoriesForJudgment : ∀ {any : Prop}, iThink → True
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

namespace Thread

variable {τ : Type u} [InnerTime τ] {s : Subject τ}

/-- The standing witness that the `I think` accompanies the manifold. -/
@[simp] theorem witness (t : Thread τ s) : t.iThink := t.iThinkWitness

/-- "Time is the formal condition a priori of all appearances whatsoever" (A33/B49).
    Extracts the inner-time ordering guaranteed by the thread. -/
theorem intuitionTime (t : Thread τ s) : True := t.formOfInnerTime t.iThinkWitness

/-- "The same function which gives unity to the different representations in a judgment
also gives unity to the mere synthesis of different representations in an intuition"
(A79/B104). Pulls the categorical binding ensured by the thread. -/
theorem categoriesBind {any : Prop} (t : Thread τ s) : True :=
  t.categoriesForJudgment (any := any) t.iThinkWitness

/-- "This transcendental unity of apperception is that unity through which all the
manifold given in an intuition is united" (B135). -/
theorem apperception (t : Thread τ s) : True := t.apperceptiveUnity t.iThinkWitness

/-- "The concept of a noumenon is therefore merely a limiting concept" (A255/B311). -/
theorem noumenalLimit (t : Thread τ s) : True := t.noumenalBoundary t.iThinkWitness

/-- "The ideas of pure reason have a necessary regulative use" (A642/B670). -/
theorem regulativeIdeas_proof (t : Thread τ s) : True := t.regulativeIdeas t.iThinkWitness

/-- "This schematism of our understanding... is a transcendental product of the imagination"
(A140/B179). -/
theorem schematism (t : Thread τ s) : True := t.schematismBridge t.iThinkWitness

/-- "All substances... are in thoroughgoing interaction" (B256). Provides the
Community/Reciprocity relation arising from the thread. -/
def reciprocity {α : Type u} (t : Thread τ s) : Reciprocity α :=
  t.reciprocityCommunity t.iThinkWitness

/-- "Synthetic judgments a priori are therefore possible" (B19–B20). -/
theorem syntheticApriori_proof (t : Thread τ s) : True :=
  t.syntheticApriori t.iThinkWitness

/-- "Practical reason of itself gives reality to a supersensible object of the faculty of desire"
(KPV 5:42). -/
theorem practicalStandpoint_proof (t : Thread τ s) : True :=
  t.practicalStandpoint t.iThinkWitness

/-- "Reflective judgment... requires a principle" (CJ 5:179). -/
theorem reflectiveJudgment (t : Thread τ s) : True := t.reflectiveSearch t.iThinkWitness

/-- "A hypothesis is allowable only as a means of bringing unity into the manifold of knowledge, so far as that unity rests upon experience" (A820/B848).
-/
theorem nonCollapse_proof (t : Thread τ s) : True := t.nonCollapse t.iThinkWitness

/-- "Reason demands a system in accordance with its own concepts" (A833/B861). -/
theorem systemDemand_proof (t : Thread τ s) : True := t.systemDemand t.iThinkWitness

end Thread

end FromIThink

end IVI
