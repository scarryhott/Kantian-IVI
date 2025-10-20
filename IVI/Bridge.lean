/-
  IVI/Bridge.lean
  Bridges Kant’s pure-reason machinery and IVI’s intangible verification.
  Sets up the skeleton for soundness (Kant ⇒ IVI), completeness (IVI ⇒ Kant),
  and minimality (each Kantian axiom is necessary).
  Proofs remain to be filled.
-/

import IVI.Pure
import IVI.Logic
import IVI.Operators
import IVI.Invariant
import IVI.FixedPoint
import IVI.Intangible
import IVI.SchematismSpec
import IVI.KakeyaBounds
import IVI.Will
import IVI.SVObj
import IVI.KakeyaBridge

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open Classical
open Invariant
open FixedPoint

/-- Helper: view a list of Floats as Reals for proof-side reasoning. -/
@[simp] def floatListToReal (xs : List Float) : List Real :=
  xs.map (fun x => (x : Real))

@[simp] lemma floatListToReal_nil : floatListToReal [] = [] := by
  simp [floatListToReal]

@[simp] lemma floatListToReal_cons (x : Float) (xs : List Float) :
    floatListToReal (x :: xs) = (x : Real) :: floatListToReal xs := by
  simp [floatListToReal]

@[simp] lemma floatListToReal_length (xs : List Float) :
    (floatListToReal xs).length = xs.length := by
  simp [floatListToReal]

/-- Measure of resonance/dissonance asymmetry between two nodes. -/
@[simp] def communityAsymmetry (W : Weighting) (n₁ n₂ : DomainNode) : Float :=
  let s₁₂ := W.sim n₁.state n₂.state
  let s₂₁ := W.sim n₂.state n₁.state
  let a₁₂ := W.align n₁.state n₂.state
  let a₂₁ := W.align n₂.state n₁.state
  Float.abs (s₁₂ - s₂₁) + Float.abs (a₁₂ - a₂₁)

/-- Community predicate: resonance/dissonance is symmetric up to tolerance. -/
@[simp] def communityPredicate (W : Weighting) (tol : Float) (nodes : List DomainNode) : Prop :=
  ∀ n₁ n₂, n₁ ∈ nodes → n₂ ∈ nodes → communityAsymmetry W n₁ n₂ ≤ tol

@[simp] lemma communityPredicate_nil (W : Weighting) (tol : Float) :
    communityPredicate W tol [] := by
  intro n₁ n₂ h₁ _
  cases h₁

/-- Non-collapse predicate: the λ-vector exhibits fractal stability across scales. -/
@[simp] def nonCollapsePredicate (cfg : RunnerCfg) (prev cur : RunnerState) : Prop :=
  (vectorMaxDiff cur.lambdaVec prev.lambdaVec ≤ cfg.epsVec) ∧
  (rVectorMaxDiff (floatListToReal cur.lambdaVec) (floatListToReal prev.lambdaVec)
      ≤ (cfg.epsVec : Real)) ∧
  cur.lambdaVec.length = prev.lambdaVec.length ∧
  cur.lambdaVec.length = cfg.levels

/-- Bundles the data of a functor from the Kantian recognition side to the IVI side. -/
structure KantToIVI where
  objMap : SVO C3State → DomainNode
  stepMap : (Recognition C3State Nat) →
    List DomainSignature → List DomainNode →
    (List DomainSignature × List DomainNode)

/-- Bundles the data of a functor from IVI back to Kantian recognitions. -/
structure IVIToKant where
  objMap : DomainNode → SVO C3State
  stepMap : List DomainSignature → List DomainNode → Recognition C3State Nat

/--
### Soundness
If `Kant` is a closure of the axioms A1–A12 (with syntheses, schematism), show
embedding into IVI (without collapse) preserves verification.
-/

noncomputable def soundnessBridge
  (cfgInv : InvariantCfg)
  (stepE : StepE)
  (domains : List DomainSignature)
  (nodes : List DomainNode)
  (ctx : WillCtx := {})
  (will : Will := Will.idle) : KakeyaBridge cfgInv (stepE := stepE) domains nodes :=
  bridgeStep cfgInv stepE domains nodes ctx will

noncomputable def soundness
  (cfgInv : InvariantCfg)
  (stepE : StepE)
  (domains : List DomainSignature)
  (nodes : List DomainNode)
  (ctx : WillCtx := {})
  (will : Will := Will.idle) : InvariantProps :=
  (soundnessBridge cfgInv stepE domains nodes ctx will).invariant.invProps

@[simp] noncomputable def soundnessUnity
  (cfgInv : InvariantCfg)
  (stepE : StepE)
  (domains : List DomainSignature)
  (nodes : List DomainNode)
  (ctx : WillCtx := {})
  (will : Will := Will.idle) : Prop :=
  let bridge := soundnessBridge cfgInv stepE domains nodes ctx will
  unityProgress cfgInv bridge.unityPrev bridge.unityNext

@[simp] theorem soundnessUnity_of_lambdaBound
  (cfgInv : InvariantCfg)
  (stepE : StepE)
  (domains : List DomainSignature)
  (nodes : List DomainNode)
  (ctx : WillCtx := {})
  (will : Will := Will.idle)
  (hHead : lambdaHeadStable
      (lambdaVector cfgInv.ncfg.levels cfgInv.W
        (soundnessBridge cfgInv stepE domains nodes ctx will).unityNext.nodes)
      cfgInv.epsUnity)
  (hLam : Float.abs
      ((soundnessBridge cfgInv stepE domains nodes ctx will).lamNext -
        (soundnessBridge cfgInv stepE domains nodes ctx will).lamPrev)
      ≤ cfgInv.epsUnity) :
  soundnessUnity cfgInv stepE domains nodes ctx will :=
by
  set bridge := soundnessBridge cfgInv stepE domains nodes ctx will
  have hHead' :
      lambdaHeadStable (lambdaVector cfgInv.ncfg.levels cfgInv.W bridge.unityNext.nodes)
        cfgInv.epsUnity := by simpa [bridge] using hHead
  have hLam' :
      Float.abs (bridge.unityNext.lam - bridge.unityPrev.lam) ≤ cfgInv.epsUnity := by
    simpa [bridge, KakeyaBridge.unityNext_lam, KakeyaBridge.unityPrev_lam]
      using hLam
  simpa [soundnessUnity, bridge, unityProgress] using And.intro hHead' hLam'

@[simp] theorem soundnessUnity_from_deltas
  (cfgInv : InvariantCfg)
  (stepE : StepE)
  (domains : List DomainSignature)
  (nodes : List DomainNode)
  (ctx : WillCtx := {})
  (will : Will := Will.idle)
  (hHead : lambdaHeadStable
      (lambdaVector cfgInv.ncfg.levels cfgInv.W
        (soundnessBridge cfgInv stepE domains nodes ctx will).unityNext.nodes)
      cfgInv.epsUnity)
  (hBound : Float.abs ((soundnessBridge cfgInv stepE domains nodes ctx will).deltas.lambdaDiff) ≤
      cfgInv.epsUnity) :
  soundnessUnity cfgInv stepE domains nodes ctx will :=
by
  have hLam := hBound
  simpa using soundnessUnity_of_lambdaBound cfgInv stepE domains nodes ctx will hHead hLam

@[simp] theorem soundnessUnity_from_weylBound
  (cfgInv : InvariantCfg)
  (stepE : StepE)
  (domains : List DomainSignature)
  (nodes : List DomainNode)
  (ctx : WillCtx := {})
  (will : Will := Will.idle)
  (kernelLip stepLip degreeBound : Float)
  (hHead : lambdaHeadStable
      (lambdaVector cfgInv.ncfg.levels cfgInv.W
        (soundnessBridge cfgInv stepE domains nodes ctx will).unityNext.nodes)
      cfgInv.epsUnity)
  (hE : Float.abs ((soundnessBridge cfgInv stepE domains nodes ctx will).deltas.lambdaDiff)
      ≤ kernelLip * stepLip *
          (soundnessBridge cfgInv stepE domains nodes ctx will).contract.θMax * degreeBound)
  (hBudget : kernelLip * stepLip *
          (soundnessBridge cfgInv stepE domains nodes ctx will).contract.θMax * degreeBound
        ≤ cfgInv.epsUnity) :
  soundnessUnity cfgInv stepE domains nodes ctx will :=
by
  have hDelta : Float.abs ((soundnessBridge cfgInv stepE domains nodes ctx will).deltas.lambdaDiff)
      ≤ cfgInv.epsUnity := le_trans hE hBudget
  exact soundnessUnity_from_deltas cfgInv stepE domains nodes ctx will hHead hDelta

@[simp] theorem soundnessUnity_from_weylBudget
  (cfgInv : InvariantCfg)
  (stepE : StepE)
  (domains : List DomainSignature)
  (nodes : List DomainNode)
  (ctx : WillCtx := {})
  (will : Will := Will.idle)
  (kernelLip stepLip degreeBound : Float)
  (hHead : lambdaHeadStable
      (lambdaVector cfgInv.ncfg.levels cfgInv.W
        (soundnessBridge cfgInv stepE domains nodes ctx will).unityNext.nodes)
      cfgInv.epsUnity)
  (hWeyl : (soundnessBridge cfgInv stepE domains nodes ctx will).contract.Cl ≤
      kernelLip * stepLip *
        (soundnessBridge cfgInv stepE domains nodes ctx will).contract.θMax * degreeBound)
  (hBudget : kernelLip * stepLip *
        (soundnessBridge cfgInv stepE domains nodes ctx will).contract.θMax * degreeBound
        ≤ cfgInv.epsUnity) :
  soundnessUnity cfgInv stepE domains nodes ctx will :=
by
  have hDelta : Float.abs ((soundnessBridge cfgInv stepE domains nodes ctx will).deltas.lambdaDiff)
      ≤ cfgInv.epsUnity := by
    have := soundnessUnity_from_contractBound cfgInv stepE domains nodes ctx will hHead
      (le_trans hWeyl hBudget)
    simpa using this
  exact soundnessUnity_from_deltas cfgInv stepE domains nodes ctx will hHead hDelta

@[simp] theorem soundnessUnity_from_weylAutoBudget
  (cfgInv : InvariantCfg)
  (stepE : StepE)
  (domains : List DomainSignature)
  (nodes : List DomainNode)
  (ctx : WillCtx := {})
  (will : Will := Will.idle)
  (hHead : lambdaHeadStable
      (lambdaVector cfgInv.ncfg.levels cfgInv.W
        (soundnessBridge cfgInv stepE domains nodes ctx will).unityNext.nodes)
      cfgInv.epsUnity)
  (hBudget :
      let bridge := soundnessBridge cfgInv stepE domains nodes ctx will
      let kernelLip := max bridge.willCtx.spectral.kernelLip 1.0
      let stepLip := max bridge.willCtx.spectral.stepLip 1.0
      let degreeBound :=
        Float.abs bridge.deltas.lambdaDiff /
          (kernelLip * stepLip * bridge.contract.θMax)
      kernelLip * stepLip * bridge.contract.θMax * degreeBound ≤ cfgInv.epsUnity) :
  soundnessUnity cfgInv stepE domains nodes ctx will :=
by
  classical
  set bridge := soundnessBridge cfgInv stepE domains nodes ctx will with hBridge
  set kernelLip := max bridge.willCtx.spectral.kernelLip 1.0 with hKernel
  set stepLip := max bridge.willCtx.spectral.stepLip 1.0 with hStep
  set degreeBound :=
      Float.abs bridge.deltas.lambdaDiff /
        (kernelLip * stepLip * bridge.contract.θMax) with hDeg
  have hKernel_ge : (1.0 : Float) ≤ kernelLip := by
    have := le_max_right bridge.willCtx.spectral.kernelLip (1.0 : Float)
    simpa [hKernel] using this
  have hStep_ge : (1.0 : Float) ≤ stepLip := by
    have := le_max_right bridge.willCtx.spectral.stepLip (1.0 : Float)
    simpa [hStep] using this
  have hTheta_ge : (1.0 : Float) ≤ bridge.contract.θMax := by
    -- `bridge.contract.θMax` is constructed as a max with `1.0`
    simpa [hBridge, soundnessBridge, bridgeStep, mkKakeyaBridge,
          KakeyaBounds.buildContract] using
      le_max_right
        (if ctx.bounds.θCap ≤
            (List.zip nodes
                (bridge.witness.nextNodes)).foldl
              (fun acc pair =>
                let θPrev := pair.fst.state.time.theta
                let θNext := pair.snd.state.time.theta
                let δ := Float.abs (θNext - θPrev)
                if acc < δ then δ else acc)
              0.0
          then (List.zip nodes
                (bridge.witness.nextNodes)).foldl
              (fun acc pair =>
                let θPrev := pair.fst.state.time.theta
                let θNext := pair.snd.state.time.theta
                let δ := Float.abs (θNext - θPrev)
                if acc < δ then δ else acc)
              0.0
          else ctx.bounds.θCap)
        (1.0 : Float)
  have hKernel_pos : (0 : Float) < kernelLip := lt_of_lt_of_le (zero_lt_one : (0 : Float) < 1) hKernel_ge
  have hStep_pos : (0 : Float) < stepLip := lt_of_lt_of_le (zero_lt_one : (0 : Float) < 1) hStep_ge
  have hTheta_pos : (0 : Float) < bridge.contract.θMax := lt_of_lt_of_le (zero_lt_one : (0 : Float) < 1) hTheta_ge
  have hDenom_pos : (0 : Float) < kernelLip * stepLip * bridge.contract.θMax :=
    mul_pos (mul_pos hKernel_pos hStep_pos) hTheta_pos
  have hDenom_ne : kernelLip * stepLip * bridge.contract.θMax ≠ 0 := ne_of_gt hDenom_pos
  have hCl_abs :
      Float.abs bridge.deltas.lambdaDiff = bridge.contract.Cl := by
    simp [hBridge, soundnessBridge, bridgeStep, mkKakeyaBridge,
          KakeyaBounds.buildContract, KakeyaBounds.DeltaPack.Δlambda]
  have hProd_eq :
      kernelLip * stepLip * bridge.contract.θMax * degreeBound =
        Float.abs bridge.deltas.lambdaDiff := by
    simp [hDeg, hDenom_ne, mul_comm, mul_left_comm, mul_assoc]
  have hWeylEq :
      bridge.contract.Cl = kernelLip * stepLip * bridge.contract.θMax * degreeBound := by
    simpa [hCl_abs, hProd_eq]
  have hWeyl : bridge.contract.Cl ≤
      kernelLip * stepLip * bridge.contract.θMax * degreeBound :=
    by simpa [hWeylEq] using (le_of_eq hWeylEq)
  have hBudget' : kernelLip * stepLip * bridge.contract.θMax * degreeBound ≤ cfgInv.epsUnity := by
    simpa [hBridge, hKernel, hStep, hDeg] using hBudget
  exact soundnessUnity_from_weylBudget cfgInv stepE domains nodes ctx will
    kernelLip stepLip degreeBound hHead hWeyl hBudget'

@[simp] theorem soundnessUnity_from_contractBound
  (cfgInv : InvariantCfg)
  (stepE : StepE)
  (domains : List DomainSignature)
  (nodes : List DomainNode)
  (ctx : WillCtx := {})
  (will : Will := Will.idle)
  (hHead : lambdaHeadStable
      (lambdaVector cfgInv.ncfg.levels cfgInv.W
        (soundnessBridge cfgInv stepE domains nodes ctx will).unityNext.nodes)
      cfgInv.epsUnity)
  (hBound : (soundnessBridge cfgInv stepE domains nodes ctx will).contract.Cl ≤ cfgInv.epsUnity) :
  soundnessUnity cfgInv stepE domains nodes ctx will :=
by
  have hEq :
      Float.abs ((soundnessBridge cfgInv stepE domains nodes ctx will).deltas.lambdaDiff) =
        (soundnessBridge cfgInv stepE domains nodes ctx will).contract.Cl := by
    simp [soundnessBridge, bridgeStep, mkKakeyaBridge,
          KakeyaBounds.buildContract, KakeyaBounds.DeltaPack.Δlambda]
  have hDelta :
      Float.abs ((soundnessBridge cfgInv stepE domains nodes ctx will).deltas.lambdaDiff)
        ≤ cfgInv.epsUnity := by
    simpa [hEq]
    using hBound
  exact soundnessUnity_from_deltas cfgInv stepE domains nodes ctx will hHead hDelta

/-!
### Completeness
Iterate Kakeya bridge frames for a given fuel, providing the data needed to
reconstruct Kantian recognitions once fixed-point conditions are met.
-/

noncomputable def completenessRun
  (cfgInv : InvariantCfg)
  (stepE : StepE)
  (fuel : Nat)
  (domains : List DomainSignature)
  (nodes : List DomainNode)
  (ctx : WillCtx := {})
  (will : Will := Will.idle) :
  BridgeRun cfgInv stepE :=
  bridgeRun cfgInv stepE fuel domains nodes ctx will

noncomputable def completenessBridge
  (cfgInv : InvariantCfg)
  (stepE : StepE)
  (fuel : Nat)
  (domains : List DomainSignature)
  (nodes : List DomainNode)
  (ctx : WillCtx := {})
  (will : Will := Will.idle) :
  List (BridgeFrame cfgInv stepE) :=
  (completenessRun cfgInv stepE fuel domains nodes ctx will).frames

noncomputable def completenessFinalState
  (cfgInv : InvariantCfg)
  (stepE : StepE)
  (fuel : Nat)
  (domains : List DomainSignature)
  (nodes : List DomainNode)
  (ctx : WillCtx := {})
  (will : Will := Will.idle) :
  List DomainSignature × List DomainNode :=
let run := completenessRun cfgInv stepE fuel domains nodes ctx will
in (run.finalDomains, run.finalNodes)

/-!
### Minimality
Removing Kantian ingredients should break IVI constructions.
We provide placeholders for each axiom removal (A1–A12).
-/

def minimality_inner_time (contra : False) : False := contra

def minimality_reciprocity (contra : False) : False := contra

def minimality_schematism (contra : False) : False := contra

-- Add analogous lemmas for other axioms as needed.

end IVI

section BridgeInvariants

variable (cfgInv : InvariantCfg)
variable {stepE : StepE} {doms : List DomainSignature} {nodes : List DomainNode}

noncomputable def bridgeInvariantFromWitness
  (ctx : WillCtx := {}) (will : Will := Will.idle)
  (w : KakeyaBounds.ContractWitness stepE doms nodes) : BridgeInvariant :=
bridgeFromWitness cfgInv w

end BridgeInvariants

end IVI

/-- Bridge corollary: extracting invariants from one Kakeya step. -/
noncomputable def bridgeStep
  (cfgInv : InvariantCfg)
  (stepE : StepE)
  (doms : List DomainSignature)
  (nodes : List DomainNode)
  (ctx : WillCtx := {})
  (will : Will := Will.idle) : KakeyaBridge cfgInv (stepE := stepE) doms nodes :=
  mkKakeyaBridge cfgInv ctx will stepE doms nodes

end IVI

/-- Extract the invariant part of the soundness bridge. -/
@[simp] noncomputable def soundnessInvariant
  (cfgInv : InvariantCfg)
  (stepE : StepE)
  (domains : List DomainSignature)
  (nodes : List DomainNode)
  (ctx : WillCtx := {})
  (will : Will := Will.idle) : BridgeInvariant :=
  (soundnessBridge cfgInv stepE domains nodes ctx will).invariant

/-- Extract unity states before and after the step. -/
@[simp] noncomputable def soundnessUnityStates
  (cfgInv : InvariantCfg)
  (stepE : StepE)
  (domains : List DomainSignature)
  (nodes : List DomainNode)
  (ctx : WillCtx := {})
  (will : Will := Will.idle) : UnityState × UnityState :=
  let bridge := soundnessBridge cfgInv stepE domains nodes ctx will
  (bridge.unityPrev, bridge.unityNext)

end IVI

/-- Extract invariants for every frame in the completeness bridge run. -/
@[simp] noncomputable def completenessInvariants
  (cfgInv : InvariantCfg)
  (stepE : StepE)
  (fuel : Nat)
  (domains : List DomainSignature)
  (nodes : List DomainNode)
  (ctx : WillCtx := {})
  (will : Will := Will.idle) : List BridgeInvariant :=
  (completenessBridge cfgInv stepE fuel domains nodes ctx will).map (·.bridge.invariant)

@[simp] noncomputable def completenessUnityStates
  (cfgInv : InvariantCfg)
  (stepE : StepE)
  (fuel : Nat)
  (domains : List DomainSignature)
  (nodes : List DomainNode)
  (ctx : WillCtx := {})
  (will : Will := Will.idle) : List (UnityState × UnityState) :=
  (completenessBridge cfgInv stepE fuel domains nodes ctx will).map
    (fun frame => (frame.bridge.unityPrev, frame.bridge.unityNext))

end IVI
