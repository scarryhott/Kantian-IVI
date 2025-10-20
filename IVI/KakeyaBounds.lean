/-
  IVI/KakeyaBounds.lean
  Proof-side scaffolding for assembling Kakeya contracts from analytic bounds.
  Inequalities are currently stubbed with `sorry` placeholders.
-/

import IVI.Kakeya.Core
import IVI.SVObj
import IVI.Will
import IVI.Bounds
import IVI.WeylBounds
import IVI.FloatSpec

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

namespace KakeyaBounds

open Classical
open Invariant
open List
open WeylBounds

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
  grainPrev : Float
  grainNext : Float
  @[simp] grainPrev_eval :
    grainPrev = graininessScore (resonanceMatrixW K.collapseCfg.W nodes)
  @[simp] grainNext_eval :
    grainNext = graininessScore (resonanceMatrixW K.collapseCfg.W nextNodes)
  @[simp] grainDiff_eval :
    deltas.grainDiff = grainNext - grainPrev
  @[simp] lamPrev_eval :
    lamPrev = spectralInvariantW K.collapseCfg.W nodes
  @[simp] lamNext_eval :
    lamNext = spectralInvariantW K.collapseCfg.W nextNodes
  @[simp] lamDiff_eval :
    deltas.lambdaDiff = lamNext - lamPrev
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
  let collapseCfg : ICollapseCfg :=
    { τGrain := graininessScore (resonanceMatrixW defaultWeighting nodes)
    , ε := 1e-6
    , W := defaultWeighting }
  let deltas : DeltaPack :=
    { grainDiff := 0.0, entropyDiff := 0.0, lambdaDiff := 0.0, θMax := 0.0 }
  let contract := deltas.relaxedContract 0.0 0.0 0.0 1.0
  refine
    { K :=
        { tolDir := 0.0
        , collapseCfg := collapseCfg
        , dirs := []
        , nodes := nodes }
    , ctx := ctx
    , will := will
    , nextDomains := doms
    , nextNodes := nodes
    , nextObjs := []
    , preObjs := []
    , lamPrev := spectralInvariantW defaultWeighting nodes
    , lamNext := spectralInvariantW defaultWeighting nodes
    , evidence := {}
    , nodesAligned := rfl
    , deltas := deltas
    , contract := contract
    , kernelLip := 0.0
    , stepLip := 0.0
    , degBound := 0.0
    , grainPrev := graininessScore (resonanceMatrixW defaultWeighting nodes)
    , grainNext := graininessScore (resonanceMatrixW defaultWeighting nodes)
    , grainPrev_eval := rfl
    , grainNext_eval := rfl
    , grainDiff_eval := rfl
    , lamPrev_eval := rfl
    , lamNext_eval := rfl
    , lamDiff_eval := rfl
    , grainWitness := by
        simpa using le_self (Float.abs 0.0)
    , entropyWitness := by
        simpa using le_self (Float.abs 0.0)
    , lamWitness := by
        simpa using le_self (Float.abs 0.0) }

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

namespace ContractWitness

open FloatSpec

/-- Convert a relaxed grain witness into a monotone-style inequality with slack. -/
@[simp] theorem grain_relaxed_bound
    {stepE : StepE} {doms : List DomainSignature} {nodes : List DomainNode}
    (w : ContractWitness stepE doms nodes)
    (h : Float.abs w.deltas.grainDiff ≤ w.contract.Cg) :
    graininessScore (resonanceMatrixW w.K.collapseCfg.W w.nextNodes) ≤
      graininessScore (resonanceMatrixW w.K.collapseCfg.W nodes) + w.contract.Cg :=
by
  have h' : Float.abs (w.grainNext - w.grainPrev) ≤ w.contract.Cg := by
    simpa [w.grainDiff_eval]
  have := abs_sub_le_add w.grainNext w.grainPrev w.contract.Cg h'
  simpa [w.grainNext_eval, w.grainPrev_eval]

@[simp] theorem lambda_relaxed_bound
    {stepE : StepE} {doms : List DomainSignature} {nodes : List DomainNode}
    (w : ContractWitness stepE doms nodes)
    (h : Float.abs w.deltas.lambdaDiff ≤ w.contract.Cl) :
    Float.abs
        (spectralInvariantW w.K.collapseCfg.W w.nextNodes -
          spectralInvariantW w.K.collapseCfg.W nodes) ≤
      w.contract.Cl :=
by
  simpa [w.lamDiff_eval, w.lamNext_eval, w.lamPrev_eval]

end ContractWitness

namespace DeltaPack

@[simp] theorem contract_Cl_of_theta
    (d : DeltaPack) (θ : Float) :
    ({ (d.assemble) with θMax := θ }).Cl = d.Δlambda := by
  simp [DeltaPack.assemble]

end DeltaPack

end KakeyaBounds

end IVI
