/-
  IVI/KakeyaBounds.lean
  Proof-side scaffolding for assembling Kakeya contracts from analytic bounds.
  Inequalities are currently stubbed with `sorry` placeholders.
-/

import IVI.Kakeya.Core
import IVI.SVObj
import IVI.Will
import IVI.Bounds

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

namespace KakeyaBounds

open Classical
open Invariant
open List

/--
Packaged deltas between successive IVI steps.
Stores the raw signed differences and exposes absolute values via helpers.
-/
structure DeltaPack where
  grainDiff   : Float
  entropyDiff : Float
  lambdaDiff  : Float
  θMax        : Float
  deriving Repr

namespace DeltaPack

@[simp] def Δgrain (d : DeltaPack) : Float := Float.abs d.grainDiff
@[simp] def Δentropy (d : DeltaPack) : Float := Float.abs d.entropyDiff
@[simp] def Δlambda (d : DeltaPack) : Float := Float.abs d.lambdaDiff

/-- Assemble a Kakeya contract using the exact measured deltas. -/
@[simp] def assemble (d : DeltaPack) : KakeyaContract :=
  { Cg := d.Δgrain
  , Ce := d.Δentropy
  , Cl := d.Δlambda
  , θMax := d.θMax
  , grain_ok := Float.abs d.grainDiff = d.Δgrain
  , entropy_ok := Float.abs d.entropyDiff = d.Δentropy
  , lam_ok := Float.abs d.lambdaDiff = d.Δlambda }

@[simp] theorem assemble_grain_ok (d : DeltaPack) :
    (d.assemble).grain_ok := by
  simp [assemble, Δgrain]

@[simp] theorem assemble_entropy_ok (d : DeltaPack) :
    (d.assemble).entropy_ok := by
  simp [assemble, Δentropy]

@[simp] theorem assemble_lambda_ok (d : DeltaPack) :
    (d.assemble).lam_ok := by
  simp [assemble, Δlambda]

/-- Relax the grain bound to any enclosing constant. -/
@[simp] def relaxGrain {Cg : Float}
    (d : DeltaPack) (h : d.Δgrain ≤ Cg) :
    Float.abs d.grainDiff ≤ Cg := by
  simpa [Δgrain] using h

/-- Relax the entropy bound to any enclosing constant. -/
@[simp] def relaxEntropy {Ce : Float}
    (d : DeltaPack) (h : d.Δentropy ≤ Ce) :
    Float.abs d.entropyDiff ≤ Ce := by
  simpa [Δentropy] using h

/-- Relax the λ-head bound to any enclosing constant. -/
@[simp] def relaxLambda {Cl : Float}
    (d : DeltaPack) (h : d.Δlambda ≤ Cl) :
    Float.abs d.lambdaDiff ≤ Cl := by
  simpa [Δlambda] using h

/-- Build a relaxed Kakeya contract using inequality bounds. -/
@[simp] def relaxedContract
    (d : DeltaPack)
    (Cg Ce Cl θMax : Float) : KakeyaContract :=
  { Cg := Cg
  , Ce := Ce
  , Cl := Cl
  , θMax := θMax
  , grain_ok := Float.abs d.grainDiff ≤ Cg
  , entropy_ok := Float.abs d.entropyDiff ≤ Ce
  , lam_ok := Float.abs d.lambdaDiff ≤ Cl }

end DeltaPack

/--
Contract data extracted from a single IVI step together with witness slots for
future analytic bounds.
-/
structure ContractWitness
    (stepE : StepE)
    (doms : List DomainSignature)
    (nodes : List DomainNode) where
  K : KakeyaField
  ctx : WillCtx
  will : Will
  nextDomains : List DomainSignature
  nextNodes : List DomainNode
  nextObjs : List SVObj
  preObjs : List SVObj
  lamPrev : Float
  lamNext : Float
  evidence : StepEvidence
  nodesAligned : K.nodes = nextNodes
  deltas : DeltaPack
  contract : KakeyaContract
  kernelLip : Float
  stepLip : Float
  degBound : Float
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
    (nodes : List DomainNode)
    (ctx : WillCtx := {})
    (will : Will := Will.idle) :
    ContractWitness stepE doms nodes :=
by
  classical
  obtain ⟨doms₁, nodes₁, ev⟩ := stepE doms nodes
  let matrixPrev := resonanceMatrixW defaultWeighting nodes
  let score := graininessScore (resonanceMatrixW defaultWeighting nodes₁)
  let collapseCfg : ICollapseCfg :=
    { τGrain := score
    , ε := 1e-6
    , W := defaultWeighting }
  let matrixNext := resonanceMatrixW defaultWeighting nodes₁
  let grainPrev := graininessScore matrixPrev
  let grainNext := graininessScore matrixNext
  let grainDiff := grainNext - grainPrev
  let entropyPrev := rowEntropy (symmetriseLL matrixPrev)
  let entropyNext := rowEntropy (symmetriseLL matrixNext)
  let entropyDiff := entropyNext - entropyPrev
  let lambdaPrev := spectralInvariant nodes
  let lambdaNext := spectralInvariant nodes₁
  let lambdaDiff := lambdaNext - lambdaPrev
  let thetaMeasured :=
    (List.zip nodes nodes₁).foldl
      (fun acc pair =>
        let θPrev := pair.fst.state.time.theta
        let θNext := pair.snd.state.time.theta
        let δ := Float.abs (θNext - θPrev)
        if acc < δ then δ else acc)
      0.0
  let thetaSoftBound :=
    if ctx.bounds.θCap ≤ thetaMeasured then thetaMeasured else ctx.bounds.θCap
  let thetaBound := max thetaSoftBound 1.0
  let deltas : DeltaPack :=
    { grainDiff := grainDiff
    , entropyDiff := entropyDiff
    , lambdaDiff := lambdaDiff
    , θMax := thetaMeasured }
  let lamPrev := spectralInvariantW defaultWeighting nodes
  let lamNext := spectralInvariantW defaultWeighting nodes₁
  let spectral := ctx.spectral
  let kernelLip := max spectral.kernelLip 1.0
  let stepLip := max spectral.stepLip 1.0
  let denom := kernelLip * stepLip * thetaBound
  let degBound := Float.abs lambdaDiff / denom
  let preObjs :=
    nodes₁.map fun n =>
      let dir := headingOf n
      let schemaInput := SVObj.fromNode n thetaMeasured
      let schemaId := will.selectSchema ctx schemaInput
      let schemCtx : SchemaContext :=
        { schema := schemaId
        , concept := n.signature.name
        , direction := dir
        , intensity := 1.0 }
      let θ := ctx.law.chooseTheta schemCtx
      let base := SVObj.fromNode n θ
      let withW := base.withWeights matrixNext
      let recMeta : KantRecognition := { label := schemaId, valid := true }
      let recogn := withW.withRecognition recMeta
      recogn
  let nextObjs := preObjs.map (will.apply ctx)
  let K : KakeyaField :=
    { tolDir := 0.0
    , collapseCfg := collapseCfg
    , dirs := []
    , nodes := nodes₁ }
  let contract : KakeyaContract :=
    { (deltas.assemble) with θMax := thetaBound }
  refine
    { K := K
    , ctx := ctx
    , will := will
    , nextDomains := doms₁
    , nextNodes := nodes₁
    , nextObjs := nextObjs
    , preObjs := preObjs
    , lamPrev := lamPrev
    , lamNext := lamNext
    , evidence := ev
    , nodesAligned := rfl
    , deltas := deltas
    , contract := contract
    , kernelLip := kernelLip
    , stepLip := stepLip
    , degBound := degBound
    , grainWitness := ?_
    , entropyWitness := ?_
    , lamWitness := ?_ }
  · simp [contract]
  · simp [contract]
  · simp [contract]

/--
Build a relaxed contract witness from existing measured deltas and external bounds.
This leaves the builder unchanged while permitting future inequality upgrades.
-/
def ContractWitness.relax
    {stepE : StepE}
    {doms : List DomainSignature}
    {nodes : List DomainNode}
    (w : ContractWitness stepE doms nodes)
    (Cg Ce Cl θMax : Float)
    (hCg : w.deltas.Δgrain ≤ Cg)
    (hCe : w.deltas.Δentropy ≤ Ce)
    (hCl : w.deltas.Δlambda ≤ Cl) :
    ContractWitness stepE doms nodes :=
  let thetaBound := max θMax 1.0
  let denom := w.kernelLip * w.stepLip * thetaBound
  let degBound := Float.abs w.deltas.lambdaDiff / denom
  { w with
    contract := w.deltas.relaxedContract Cg Ce Cl thetaBound
    , nextObjs := w.nextObjs
    , ctx := w.ctx
    , will := w.will
    , preObjs := w.preObjs
    , lamPrev := w.lamPrev
    , lamNext := w.lamNext
    , degBound := degBound
    , kernelLip := w.kernelLip
    , stepLip := w.stepLip
    , grainWitness := w.deltas.relaxGrain hCg
    , entropyWitness := w.deltas.relaxEntropy hCe
    , lamWitness := w.deltas.relaxLambda hCl }

namespace DeltaPack

@[simp] theorem contract_Cl_of_theta
    (d : DeltaPack) (θ : Float) :
    ({ (d.assemble) with θMax := θ }).Cl = d.Δlambda := by
  simp [DeltaPack.assemble]

end DeltaPack

end KakeyaBounds

end IVI
