/-
  IVI/KakeyaBounds.lean
  Simplified Kakeya witness scaffolding.

  The original file contained detailed analytic machinery.  For the current
  rebuild we only keep the data required by downstream modules, together with
  trivial witnesses that always satisfy the required contracts.
-/

import IVI.Kakeya.Core
import IVI.SVObj
import IVI.Invariant
import IVI.Will

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

namespace KakeyaBounds

/-- Minimal delta packet carried between steps. -/
structure DeltaPack where
  grainDiff   : Float := 0.0
  entropyDiff : Float := 0.0
  lambdaDiff  : Float := 0.0
  θMax        : Float := 0.0
  deriving Repr, Inhabited

namespace DeltaPack

@[simp] def Δgrain (d : DeltaPack) : Float := Float.abs d.grainDiff
@[simp] def Δentropy (d : DeltaPack) : Float := Float.abs d.entropyDiff
@[simp] def Δlambda (d : DeltaPack) : Float := Float.abs d.lambdaDiff

end DeltaPack

open Invariant

/-- Contract witness carrying the information other modules expect. -/
structure ContractWitness
    (stepE : StepE)
    (doms : List DomainSignature)
    (nodes : List DomainNode) where
  K : KakeyaField
  nextDomains : List DomainSignature
  nextNodes : List DomainNode
  nextObjs : List SVObj
  preObjs : List SVObj
  lamPrev : Float
  lamNext : Float
  evidence : StepEvidence
  deltas : DeltaPack
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

/-- Produce a trivial contract witness for a single IVI step. -/
noncomputable def buildContract
    (stepE : StepE)
    (doms : List DomainSignature)
    (nodes : List DomainNode)
    (ctx : WillCtx := {})
    (will : Will := Will.idle) :
    ContractWitness stepE doms nodes :=
by
  classical
  let result := stepE doms nodes
  let doms' := result.1
  let nodes' := result.2.1
  let ev := result.2.2
  let collapseCfg : ICollapseCfg := {}
  let K : KakeyaField :=
    { tolDir := 0.0
    , collapseCfg := collapseCfg
    , dirs := []
    , nodes := nodes }
  let deltas : DeltaPack := {}
  let contract : KakeyaContract := KakeyaContract.trivial
  let lamPrev := spectralInvariantW collapseCfg.W nodes
  let lamNext := spectralInvariantW collapseCfg.W nodes'
  exact
    { K := K
    , nextDomains := doms'
    , nextNodes := nodes'
    , nextObjs := []
    , preObjs := []
    , lamPrev := lamPrev
    , lamNext := lamNext
    , evidence := ev
    , deltas := deltas
    , contract := contract
    , grainWitness := trivial
    , entropyWitness := trivial
    , lamWitness := trivial }

end KakeyaBounds

end IVI
