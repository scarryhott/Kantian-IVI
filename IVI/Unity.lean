/-
  IVI/Unity.lean
  Fixed-point style invariant tying λ-head stability to an "I think" witness.
-/

import IVI.SVObj
import IVI.KakeyaBounds
import IVI.Invariant

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

structure UnityState where
  objs  : List SVObj
  nodes : List DomainNode
  lam   : Float
  deriving Repr

@[simp] def unityProgress
    (cfg : InvariantCfg) (prev cur : UnityState) : Prop :=
  let lvPrev := lambdaVector cfg.ncfg.levels cfg.W prev.nodes
  let lvCur := lambdaVector cfg.ncfg.levels cfg.W cur.nodes
  lambdaHeadStable lvCur cfg.epsUnity ∧ Float.abs (cur.lam - prev.lam) ≤ cfg.epsUnity

@[simp] def unityStateFromWitness
    (cfgInv : InvariantCfg)
    {stepE : StepE} {doms : List DomainSignature} {nodes : List DomainNode}
    (w : KakeyaBounds.ContractWitness stepE doms nodes) : UnityState :=
  let lamPrev := spectralInvariantW cfgInv.W nodes
  let lamNext := spectralInvariantW cfgInv.W w.nextNodes
  { objs := w.nextObjs
  , nodes := w.nextNodes
  , lam := lamNext }

end IVI
