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
          KakeyaBounds.DeltaPack.contract_Cl_of_theta]
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
