/-
  IVI/Kakeya.lean
  Formalises directional completeness + zero-collapse geometry for IVI runs.
  Captures the IVI–Kakeya bridge as an axiom that can later be replaced by
  a constructive Besicovitch-style argument.
-/

import IVI.Kakeya.Core
import IVI.KakeyaBounds
import IVI.KakeyaAssemble
import IVI.InvariantBridge
import IVI.Will

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open Classical
open KakeyaBounds

/-- Build the full contract witness for a single IVI step. -/
@[simp] noncomputable def kakeyaWitness
    (stepE : StepE)
    (doms : List DomainSignature)
    (nodes : List DomainNode)
    (ctx : WillCtx := {})
    (will : Will := Will.idle) :
    KakeyaBounds.ContractWitness stepE doms nodes :=
  KakeyaBounds.buildContract stepE doms nodes ctx will

/-- IVI–Kakeya Principle: assemble a Kakeya field and preservation contract. -/
theorem IVI_Kakeya_Principle
  (stepE : StepE)
  (doms : List DomainSignature)
  (nodes : List DomainNode) :
  ∃ K : KakeyaField, preservesKakeya K stepE doms nodes :=
by
  classical
  let witness := kakeyaWitness stepE doms nodes
  refine ⟨witness.K, ?_⟩
  exact preserves_of_witness (w := witness)

/-- Existence corollary: there is a directionally complete, non-collapsing field. -/
@[simp] theorem exists_kakeya_field
  (stepE : StepE) (doms : List DomainSignature) (nodes : List DomainNode) :
  ∃ K : KakeyaField, preservesKakeya K stepE doms nodes :=
  IVI_Kakeya_Principle stepE doms nodes

/-- Preservation corollary: one IVI step keeps the Kakeya properties. -/
@[simp] theorem kakeya_preserved_one_step
  (stepE : StepE) (doms : List DomainSignature) (nodes : List DomainNode) :
  ∃ K : KakeyaField, preservesKakeya K stepE doms nodes :=
  IVI_Kakeya_Principle stepE doms nodes

end IVI
