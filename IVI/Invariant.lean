/-
  IVI/Invariant.lean
  Unified resonance weighting, spectral invariant, and simple runners built on
  lists (mathlib-free).
-/

import IVI.Intangible

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open Classical

namespace Invariant

noncomputable section

@[simp] def fmax (a b : Float) : Float := if a < b then b else a

@[simp] def clampZero (x : Float) : Float := if x < 0.0 then 0.0 else x

@[simp] def enumerate {α} (xs : List α) : List (Nat × α) :=
  (List.range xs.length).zip xs

structure Weighting where
  sim      : C3State → C3State → Float
  align    : C3State → C3State → Float
  symmetric : Bool := true
  rowNorm   : Bool := false

@[simp] def defaultWeighting : Weighting :=
  { sim := fun a b => clampZero (sim a.ψ b.ψ)
  , align := fun a b => align a.time b.time
  , symmetric := true
  , rowNorm := false }

@[simp] def resonanceMatrixW (W : Weighting) (nodes : List DomainNode)
  : List (List Float) :=
  let en := enumerate nodes
  en.map fun (i, ni) =>
    let base := en.map fun (j, nj) =>
      if i = j then 0.0
      else
        let raw := (W.sim ni.state nj.state) * (W.align ni.state nj.state)
        clampZero raw
    let sum := base.foldl (fun acc x => acc + x) 0.0
    if W.rowNorm ∧ sum > 0.0 then base.map (· / sum) else base

@[simp] def mulMatVec (M : List (List Float)) (v : List Float) : List Float :=
  M.map fun row =>
    (row.zip v).foldl (fun acc ab => acc + ab.fst * ab.snd) 0.0

@[simp] def normInf : List Float → Float
  | [] => 0.0
  | x :: xs => fmax (Float.abs x) (normInf xs)

@[simp] def normalise (v : List Float) : List Float :=
  let nrm := normInf v
  if nrm == 0.0 then v else v.map (· / nrm)

@[simp] def powerIterAux (M : List (List Float)) (eps : Float)
  : Nat → Float → List Float → Float × List Float
  | 0, lam, v => (lam, v)
  | Nat.succ fuel, lam, v =>
      let w := mulMatVec M v
      let v' := normalise w
      let lam' := normInf w
      if Float.abs (lam' - lam) ≤ eps then (lam', v')
      else powerIterAux (M := M) (eps := eps) fuel lam' v'

@[simp] def powerIter (M : List (List Float)) (iters : Nat) (eps : Float)
  : Float × List Float :=
  let dim := M.length
  if dim = 0 then (0.0, []) else
    let v0 := List.replicate dim (1.0 / Float.ofNat dim)
    powerIterAux (M := M) (eps := eps) iters 0.0 v0

@[simp] def spectralInvariantW (W : Weighting) (nodes : List DomainNode) : Float :=
  (powerIter (resonanceMatrixW W nodes) 128 1e-7).fst

@[simp] def spectralInvariant (nodes : List DomainNode) : Float :=
  spectralInvariantW defaultWeighting nodes

structure RunnerCfg where
  eps      : Float := 1e-6
  maxIters : Nat   := 64
  weighting : Weighting := defaultWeighting

structure RunnerState where
  iter      : Nat
  invariant : Float
  domains   : List DomainSignature
  nodes     : List DomainNode

@[simp] def runUntilConverged
  (cfg : RunnerCfg)
  (step : List DomainSignature → List DomainNode →
          (List DomainSignature × List DomainNode))
  (d0 : List DomainSignature)
  (n0 : List DomainNode)
: RunnerState :=
  let W := cfg.weighting
  let rec loop : Nat → Nat → Float → List DomainSignature → List DomainNode → RunnerState
    | 0, iter, _, doms, nodes =>
      let inv := spectralInvariantW W nodes
      { iter := iter, invariant := inv, domains := doms, nodes := nodes }
    | Nat.succ fuel, iter, lastInv, doms, nodes =>
      let inv := spectralInvariantW W nodes
      if Float.abs (inv - lastInv) ≤ cfg.eps then
        { iter := iter, invariant := inv, domains := doms, nodes := nodes }
      else
        let (doms', nodes') := step doms nodes
        loop fuel (iter + 1) inv doms' nodes'
  loop cfg.maxIters 0 (-1.0) d0 n0

end

end Invariant

end IVI
