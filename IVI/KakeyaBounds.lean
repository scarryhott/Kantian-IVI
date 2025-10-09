/-
  IVI/KakeyaBounds.lean
  Proof-side scaffolding for assembling Kakeya contracts from analytic bounds.
  Inequalities are currently stubbed with `sorry` placeholders.
-/

import IVI.Kakeya.Core

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

namespace KakeyaBounds

open Classical
open Invariant

/--
Contract data extracted from a single IVI step together with witness slots for
future analytic bounds.
-/
structure ContractWitness
    (stepE : StepE)
    (doms : List DomainSignature)
    (nodes : List DomainNode) where
  K : KakeyaField
  nextDomains : List DomainSignature
  nextNodes : List DomainNode
  evidence : StepEvidence
  nodesAligned : K.nodes = nextNodes
  contract : KakeyaContract
  grainWitness : contract.grain_ok
  entropyWitness : contract.entropy_ok
  lamWitness : contract.lam_ok

/-- Assemble the preservation statement once the contract witnesses are in hand. -/
@[simp] def assemble_preservation_from_components
    {stepE : StepE}
    {doms : List DomainSignature}
    {nodes : List DomainNode}
    (w : ContractWitness stepE doms nodes) :
    preservesKakeya w.K stepE doms nodes :=
by
  refine ⟨w.contract, ?_⟩
  exact ⟨w.grainWitness, w.entropyWitness, w.lamWitness⟩

/-- Build the Kakeya field and contract placeholders for a single IVI step. -/
noncomputable def buildContract
    (stepE : StepE)
    (doms : List DomainSignature)
    (nodes : List DomainNode) :
    ContractWitness stepE doms nodes :=
by
  classical
  obtain ⟨doms₁, nodes₁, ev⟩ := stepE doms nodes
  let score := graininessScore (resonanceMatrixW defaultWeighting nodes₁)
  let collapseCfg : ICollapseCfg :=
    { τGrain := score
    , ε := 1e-6
    , W := defaultWeighting }
  let K : KakeyaField :=
    { tolDir := 0.0
    , collapseCfg := collapseCfg
    , dirs := []
    , nodes := nodes₁ }
  let contract : KakeyaContract :=
    { Cg := 0.0
    , Ce := 0.0
    , Cl := 0.0
    , θMax := 0.0
    , grain_ok := True
    , entropy_ok := True
    , lam_ok := True }
  refine
    { K := K
    , nextDomains := doms₁
    , nextNodes := nodes₁
    , evidence := ev
    , nodesAligned := rfl
    , contract := contract
    , grainWitness := ?_
    , entropyWitness := ?_
    , lamWitness := ?_ }
  · -- ΔRow / graininess bound placeholder
    sorry
  · -- Entropy mixing bound placeholder
    sorry
  · -- λ-head stability bound placeholder
    sorry

end KakeyaBounds

end IVI
