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
  nextDomains : List DomainSignature
  nextNodes : List DomainNode
  evidence : StepEvidence
  nodesAligned : K.nodes = nextNodes
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

/-- Build the Kakeya field and contract placeholders for a single IVI step. -/
noncomputable def buildContract
    (stepE : StepE)
    (doms : List DomainSignature)
    (nodes : List DomainNode) :
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
  let thetaMax :=
    (List.zip nodes nodes₁).foldl
      (fun acc pair =>
        let θPrev := pair.fst.state.time.theta
        let θNext := pair.snd.state.time.theta
        let δ := Float.abs (θNext - θPrev)
        if acc < δ then δ else acc)
      0.0
  let deltas : DeltaPack :=
    { grainDiff := grainDiff
    , entropyDiff := entropyDiff
    , lambdaDiff := lambdaDiff
    , θMax := thetaMax }
  let K : KakeyaField :=
    { tolDir := 0.0
    , collapseCfg := collapseCfg
    , dirs := []
    , nodes := nodes₁ }
  let contract : KakeyaContract := deltas.assemble
  refine
    { K := K
    , nextDomains := doms₁
    , nextNodes := nodes₁
    , evidence := ev
    , nodesAligned := rfl
    , deltas := deltas
    , contract := contract
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
  { w with
    contract := w.deltas.relaxedContract Cg Ce Cl θMax
    , grainWitness := w.deltas.relaxGrain hCg
    , entropyWitness := w.deltas.relaxEntropy hCe
    , lamWitness := w.deltas.relaxLambda hCl }

end KakeyaBounds

end IVI
