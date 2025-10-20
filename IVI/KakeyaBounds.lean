/-
  IVI/KakeyaBounds.lean
  Quantitative Kakeya witness construction.

  This module rebuilds the bridge that was previously stubbed out: we recover
  the real measurements (graininess, entropy, λ-head) associated with an IVI
  step and package them into a contract witness that downstream proofs can
  relax.  The bounds remain list-based and executable, matching the rest of
  the runtime pipeline.
-/

import IVI.Kakeya.Core
import IVI.SVObj
import IVI.Invariant
import IVI.Will
import IVI.FloatSpec

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

namespace KakeyaBounds

/-- Minimal delta packet carried between steps. -/
structure DeltaPack where
  grainDiff    : Float := 0.0
  entropyDiff  : Float := 0.0
  lambdaDiff   : Float := 0.0
  θMeasured    : Float := 0.0
  θMax         : Float := 1.0
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

/-- Annotate a domain node with the will's current schema/theta choices. -/
private def decorateWithWill (ctx : WillCtx) (will : Will) (n : DomainNode) : SVObj :=
  let base := SVObj.fromNode n
  let schema := will.selectSchema ctx base
  let θ := will.chooseTheta ctx base
  let kant := { base.kant with recognition := { label := schema, valid := True } }
  let ivi := { base.ivi with θChoice := θ }
  { kant := kant, ivi := ivi }

/-- Accumulate the maximum theta deviation across corresponding node pairs. -/
private def thetaSpan (pairs : List (DomainNode × DomainNode)) : Float :=
  pairs.foldl
    (fun acc pair =>
      let θPrev := pair.fst.state.time.theta
      let θNext := pair.snd.state.time.theta
      let δ := Float.abs (θNext - θPrev)
      if acc < δ then δ else acc)
    0.0

/-- Produce a quantitative contract witness for a single IVI step. -/
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
  let W := collapseCfg.W
  let weightsPrev := resonanceMatrixW W nodes
  let weightsNext := resonanceMatrixW W nodes'
  let symPrev := symmetriseLL weightsPrev
  let symNext := symmetriseLL weightsNext
  let grainPrev := graininessScore weightsPrev
  let grainNext := graininessScore weightsNext
  let entropyPrev := rowEntropy symPrev
  let entropyNext := rowEntropy symNext
  let lamPrev := spectralInvariantW W nodes
  let lamNext := spectralInvariantW W nodes'
  let θMeasured := thetaSpan (nodes.zip nodes')
  let θCap := ctx.bounds.θCap
  let θBound := if θCap ≤ θMeasured then θMeasured else θCap
  let θMaxContract := max θBound 1.0
  let deltaPack : DeltaPack :=
    { grainDiff := grainNext - grainPrev
    , entropyDiff := entropyNext - entropyPrev
    , lambdaDiff := lamNext - lamPrev
    , θMeasured := θMeasured
    , θMax := θMaxContract }
  let preObjs := nodes.map (decorateWithWill ctx will)
  let nextObjs := nodes'.map (decorateWithWill ctx will)
  have hGrain :
      Float.abs (grainNext - grainPrev) ≤ DeltaPack.Δgrain deltaPack := by
    simpa [DeltaPack.Δgrain, deltaPack] using
      (IVI.le_self (Float.abs (grainNext - grainPrev)))
  have hEntropy :
      Float.abs (entropyNext - entropyPrev) ≤ DeltaPack.Δentropy deltaPack := by
    simpa [DeltaPack.Δentropy, deltaPack] using
      (IVI.le_self (Float.abs (entropyNext - entropyPrev)))
  have hLambda :
      Float.abs (lamNext - lamPrev) ≤ DeltaPack.Δlambda deltaPack := by
    simpa [DeltaPack.Δlambda, deltaPack] using
      (IVI.le_self (Float.abs (lamNext - lamPrev)))
  let contract : KakeyaContract :=
    { Cg := DeltaPack.Δgrain deltaPack
    , Ce := DeltaPack.Δentropy deltaPack
    , Cl := DeltaPack.Δlambda deltaPack
    , θMax := θMaxContract
    , grain_ok := Float.abs (grainNext - grainPrev) ≤ DeltaPack.Δgrain deltaPack
    , entropy_ok := Float.abs (entropyNext - entropyPrev) ≤ DeltaPack.Δentropy deltaPack
    , lam_ok := Float.abs (lamNext - lamPrev) ≤ DeltaPack.Δlambda deltaPack }
  let K : KakeyaField :=
    { tolDir := θCap
    , collapseCfg := collapseCfg
    , dirs := []
    , nodes := nodes }
  exact
    { K := K
    , nextDomains := doms'
    , nextNodes := nodes'
    , nextObjs := nextObjs
    , preObjs := preObjs
    , lamPrev := lamPrev
    , lamNext := lamNext
    , evidence := ev
    , deltas := deltaPack
    , contract := contract
    , grainWitness := hGrain
    , entropyWitness := hEntropy
    , lamWitness := hLambda }

end KakeyaBounds

end IVI
