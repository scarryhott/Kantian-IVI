/-
  IVI/FixedPoint.lean
  Fixed-point predicate and runner for IVI intangible recursion. These definitions
  live in a noncomputable section so they can be used for analysis, even if the
  demo executable does not call them directly.
-/

import IVI.Invariant

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open Classical
open Invariant

namespace FixedPoint

noncomputable section

structure FixedCfg where
  epsLam   : Float := 1e-6
  epsLoopI : Float := 1e-6
  epsScale : Float := 1e-6
  maxIters : Nat   := 64
  weighting : Weighting := defaultWeighting

@[simp] def loopClosureErr (seed now : List DomainSignature) : Float :=
  let paired := seed.zip now
  if paired.isEmpty then 0.0
  else
    let sum := paired.foldl (fun acc pair =>
      acc + Float.abs (pair.fst.timeShift - pair.snd.timeShift)) 0.0
    sum / Float.ofNat paired.length

@[simp] def coarse (nodes : List DomainNode) : List DomainNode :=
  (enumerate nodes).foldr (fun pair acc =>
    if pair.fst % 2 = 0 then pair.snd :: acc else acc) []

@[simp] def scaleAgreement (W : Weighting) (nodes : List DomainNode) : Float :=
  let lamFull := spectralInvariantW W nodes
  let small := coarse nodes
  let lamCoarse := if small.isEmpty then lamFull else spectralInvariantW W small
  Float.abs (lamFull - lamCoarse)

@[simp] def IVIFixedPoint
  (cfg : FixedCfg)
  (seed : List DomainSignature)
  (prevLam curLam : Float)
  (curDomains : List DomainSignature)
  (flatNodes : List DomainNode)
: Prop :=
  Float.abs (curLam - prevLam) ≤ cfg.epsLam ∧
  loopClosureErr seed curDomains ≤ cfg.epsLoopI ∧
  scaleAgreement cfg.weighting flatNodes ≤ cfg.epsScale

structure FixedWitness where
  iters   : Nat
  lambda  : Float
  domains : List DomainSignature
  nodes   : List DomainNode
  deriving Repr

@[simp] def runToFixedPoint
  (cfg : FixedCfg)
  (step : List DomainSignature → List DomainNode →
          (List DomainSignature × List DomainNode))
  (seed : List DomainSignature)
  (d0   : List DomainSignature)
  (n0   : List DomainNode)
: FixedWitness :=
  let W := cfg.weighting
  let lam0 := spectralInvariantW W n0
  let rec loop : Nat → Nat → Float → List DomainSignature → List DomainNode → FixedWitness
    | 0, iter, lam, doms, nodes => { iters := iter, lambda := lam, domains := doms, nodes := nodes }
    | Nat.succ fuel, iter, lam, doms, nodes =>
      let (doms', nodes') := step doms nodes
      let lam' := spectralInvariantW W nodes'
      let flat := nodes'
      if IVIFixedPoint cfg seed lam lam' doms' flat then
        { iters := iter + 1, lambda := lam', domains := doms', nodes := nodes' }
      else
        loop fuel (iter + 1) lam' doms' nodes'
  loop cfg.maxIters 0 lam0 d0 n0

end

end FixedPoint

end IVI
