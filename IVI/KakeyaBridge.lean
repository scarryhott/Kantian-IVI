/-
  IVI/KakeyaBridge.lean
  Lift Kakeya witnesses into bridge invariants suitable for the Kant↔IVI proof.
-/

import IVI.KakeyaAssemble
import IVI.InvariantBridge
import IVI.Will
import IVI.Unity

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open KakeyaBounds

/-- Bundle preservation proof and bridge invariant in one record. -/
structure KakeyaBridge where
  witness   : ContractWitness (stepE := stepE) doms nodes
  invariant : BridgeInvariant
  willCtx   : WillCtx
  will      : Will
  unityPrev : UnityState
  unityNext : UnityState
  lamPrev   : Float
  lamNext   : Float
  preserves : preservesKakeya witness.K stepE doms nodes

variable (cfgInv : InvariantCfg)
variable (ctx : WillCtx := {}) (will : Will := Will.idle)

noncomputable def mkKakeyaBridge
    (stepE : StepE)
    (doms : List DomainSignature)
    (nodes : List DomainNode) : KakeyaBridge (stepE := stepE) doms nodes :=
by
  classical
  let witness := KakeyaBounds.buildContract stepE doms nodes ctx will
  let invariant := bridgeFromWitness cfgInv witness
  let lamPrev := spectralInvariantW cfgInv.W nodes
  let lamNext := spectralInvariantW cfgInv.W witness.nextNodes
  let unityPrev : UnityState := { objs := witness.preObjs
                                , nodes := nodes
                                , lam := lamPrev }
  let unityNext := { objs := witness.nextObjs
                    , nodes := witness.nextNodes
                    , lam := lamNext }
  have preserves := preserves_of_witness (w := witness)
  exact { witness := witness
        , invariant := invariant
        , willCtx := ctx
        , will := will
        , unityPrev := unityPrev
        , unityNext := unityNext
        , lamPrev := lamPrev
        , lamNext := lamNext
        , preserves := preserves }

/-- Frame storing the bridge data for a particular step. -/
structure BridgeFrame (cfgInv : InvariantCfg) (stepE : StepE) where
  doms   : List DomainSignature
  nodes  : List DomainNode
  bridge : KakeyaBridge cfgInv (stepE := stepE) doms nodes

@[simp] noncomputable def mkBridgeFrame
    (cfgInv : InvariantCfg) (ctx : WillCtx := {}) (will : Will := Will.idle)
    (stepE : StepE)
    (doms : List DomainSignature)
    (nodes : List DomainNode) :
    BridgeFrame cfgInv stepE :=
{ doms := doms
, nodes := nodes
, bridge := mkKakeyaBridge cfgInv ctx will stepE doms nodes }

@[simp] noncomputable def iterateBridge
    (cfgInv : InvariantCfg) (stepE : StepE)
    (fuel : Nat)
    (doms : List DomainSignature)
    (nodes : List DomainNode)
    (ctx : WillCtx := {}) (will : Will := Will.idle) :
    List (BridgeFrame cfgInv stepE) × (List DomainSignature × List DomainNode) :=
by
  classical
  revert doms nodes
  refine Nat.rec ?base ?step fuel
  · intro doms nodes
    exact ([], (doms, nodes))
  · intro fuel ih doms nodes
    let frame := mkBridgeFrame cfgInv ctx will stepE doms nodes
    let (tail, finalState) :=
      ih frame.bridge.witness.nextDomains frame.bridge.witness.nextNodes
    exact (frame :: tail, finalState)

@[simp] noncomputable def bridgeFrames
    (cfgInv : InvariantCfg) (stepE : StepE) (fuel : Nat)
    (doms : List DomainSignature) (nodes : List DomainNode)
    (ctx : WillCtx := {}) (will : Will := Will.idle) :
    List (BridgeFrame cfgInv stepE) :=
  (iterateBridge cfgInv stepE fuel doms nodes ctx will).fst

@[simp] noncomputable def bridgeFinalState
    (cfgInv : InvariantCfg) (stepE : StepE) (fuel : Nat)
    (doms : List DomainSignature) (nodes : List DomainNode)
    (ctx : WillCtx := {}) (will : Will := Will.idle) :
    List DomainSignature × List DomainNode :=
  (iterateBridge cfgInv stepE fuel doms nodes ctx will).snd

end IVI
