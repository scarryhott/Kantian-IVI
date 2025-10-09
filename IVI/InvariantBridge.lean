/-
  IVI/InvariantBridge.lean
  Extracts bridge-friendly invariants from a Kakeya contract witness.
-/

import IVI.KakeyaBounds
import IVI.Invariant

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open Invariant

structure BridgeInvariant where
  preObjs    : List SVObj
  postObjs   : List SVObj
  nodesPrev  : List DomainNode
  nodesNext  : List DomainNode
  contract   : KakeyaContract
  deltas     : KakeyaBounds.DeltaPack
  invProps   : InvariantProps

noncomputable def bridgeFromWitness
    (cfgInv : InvariantCfg)
    {stepE : StepE}
    {doms : List DomainSignature}
    {nodes : List DomainNode}
    (w : KakeyaBounds.ContractWitness stepE doms nodes) : BridgeInvariant :=
  let lamPrev := spectralInvariantW cfgInv.W nodes
  let lamNext := spectralInvariantW cfgInv.W w.nextNodes
  let inv := invariantProps cfgInv lamPrev lamNext nodes w.nextNodes w.evidence
  { preObjs := w.preObjs
  , postObjs := w.nextObjs
  , nodesPrev := nodes
  , nodesNext := w.nextNodes
  , contract := w.contract
  , deltas := w.deltas
  , invProps := inv }

end IVI
