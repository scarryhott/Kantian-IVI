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

@[simp] def coarse (nodes : List DomainNode) : List DomainNode :=
  (enumerate nodes).foldr (fun pair acc =>
    if pair.fst % 2 = 0 then pair.snd :: acc else acc) []

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

@[simp] def lambdaVector : Nat → Weighting → List DomainNode → List Float
  | 0, _, _ => []
  | Nat.succ _, _, [] => []
  | Nat.succ lvl, W, nodes =>
      let lam := spectralInvariantW W nodes
      lam :: lambdaVector lvl W (coarse nodes)

@[simp] def vectorMaxDiff : List Float → List Float → Float
  | [], [] => 0.0
  | x :: xs, y :: ys =>
      let diff := Float.abs (x - y)
      fmax diff (vectorMaxDiff xs ys)
  | xs, [] => normInf xs
  | [], ys => normInf ys

def vectorMaxDiff_comm (xs ys : List Float) :
  vectorMaxDiff xs ys = vectorMaxDiff ys xs := by
  revert ys
  induction xs with
  | nil =>
      intro ys
      cases ys <;> simp [vectorMaxDiff]
  | cons x xs ih =>
      intro ys
      cases ys with
      | nil => simp [vectorMaxDiff]
      | cons y ys' =>
          -- Placeholder; a full proof would analyse the Float.max branches
          -- and use |x - y| symmetry.
          admit
/-- The lambda vector never has length exceeding the number of levels we ask for. -/
@[simp] theorem lambdaVector_length_le
  (levels : Nat) (W : Weighting) (nodes : List DomainNode) :
  (lambdaVector levels W nodes).length ≤ levels :=
by
  revert nodes
  induction levels with
  | zero =>
      intro nodes
      simp [lambdaVector]
  | succ levels ih =>
      intro nodes
      cases nodes with
      | nil =>
          simp [lambdaVector]
      | cons hd tl =>
          have h := ih (coarse (hd :: tl))
          change Nat.succ (lambdaVector levels W (coarse (hd :: tl))).length ≤ Nat.succ levels
          exact Nat.succ_le_succ h

/-- The vector difference when one side is empty reduces to the infinity norm. -/
@[simp] theorem vectorMaxDiff_nil_left (ys : List Float) :
  vectorMaxDiff [] ys = normInf ys := by
  cases ys <;> simp [vectorMaxDiff]

/-- Symmetric version of `vectorMaxDiff_nil_left`. -/
@[simp] theorem vectorMaxDiff_nil_right (xs : List Float) :
  vectorMaxDiff xs [] = normInf xs := by
  cases xs <;> simp [vectorMaxDiff]

structure RunnerCfg where
  eps      : Float := 1e-6
  epsVec   : Float := 1e-6
  maxIters : Nat   := 64
  levels   : Nat   := 3
  weighting : Weighting := defaultWeighting

structure RunnerState where
  iter       : Nat
  invariant  : Float
  lambdaVec  : List Float
  domains    : List DomainSignature
  nodes      : List DomainNode

/-- Component predicates describing the invariant after a step. -/
structure InvariantProps where
  nonCollapse   : Prop
  community     : Prop
  schematism    : Prop
  unityProgress : Prop
  fixedPoint    : Prop

/-- Assemble the component predicates for consecutive states. -/
@[simp] def invariantProps
  (cfg : RunnerCfg) (prev cur : RunnerState) : InvariantProps :=
  { nonCollapse   := True
  , community     := True
  , schematism    := True
  , unityProgress :=
      (cur.invariant ≥ prev.invariant) ∨
      (Float.abs (cur.invariant - prev.invariant) ≤ cfg.eps)
  , fixedPoint    :=
      (vectorMaxDiff cur.lambdaVec prev.lambdaVec ≤ cfg.epsVec)
  }

@[simp] def runUntilConverged
  (cfg : RunnerCfg)
  (step : List DomainSignature → List DomainNode →
          (List DomainSignature × List DomainNode))
  (d0 : List DomainSignature)
  (n0 : List DomainNode)
: RunnerState :=
  let W := cfg.weighting
  let levels := cfg.levels
  let rec loop : Nat → Nat → Float → List Float → List DomainSignature → List DomainNode → RunnerState
    | 0, iter, _, _, doms, nodes =>
      let lam := spectralInvariantW W nodes
      let vec := lambdaVector levels W nodes
      { iter := iter, invariant := lam, lambdaVec := vec, domains := doms, nodes := nodes }
    | Nat.succ fuel, iter, lastLam, lastVec, doms, nodes =>
      let lam := spectralInvariantW W nodes
      let vec := lambdaVector levels W nodes
      let lamDiff := Float.abs (lam - lastLam)
      let vecDiff := vectorMaxDiff vec lastVec
      if iter > 0 ∧ lamDiff ≤ cfg.eps ∧ vecDiff ≤ cfg.epsVec then
        { iter := iter, invariant := lam, lambdaVec := vec, domains := doms, nodes := nodes }
      else
        let (doms', nodes') := step doms nodes
        loop fuel (iter + 1) lam vec doms' nodes'
  let initialLam := spectralInvariantW W n0
  let initialVec := lambdaVector levels W n0
  loop cfg.maxIters 0 initialLam initialVec d0 n0

end

end Invariant

end IVI
