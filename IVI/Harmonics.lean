/-
  IVI/Harmonics.lean
  Lightweight spectral helpers for resonance/dissonance phrased as harmonics.
  These scores live in `RealDomain` (ℝ³ projection); noumenal metrics should be
  handled in the complex layer before calling the projection helpers.
  Stays list-based (mathlib-free) to match the existing invariant pipeline.
-/

import IVI.Invariant

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open Classical

/-- Max helper for Floats (avoids needing additional imports). -/
@[simp] def fmax (a b : Float) : Float := if a < b then b else a

/-- Degree (row sum) vector for a weighted adjacency matrix. -/
@[simp] def degLL (S : List (List Float)) : List Float :=
  S.map (fun row => row.foldl (fun acc x => acc + x) 0.0)

/-- Helper: dot product of equal-length Float lists (truncates to shortest). -/
@[simp] def dotLL (a b : List Float) : Float :=
  (a.zip b).foldl (fun acc pair => acc + pair.fst * pair.snd) 0.0

/-- Unnormalised Laplacian L = D − S for list-matrices. -/
@[simp] def laplacianLL (S : List (List Float)) : List (List Float) :=
  let deg := degLL S
  let idxRows := (List.range S.length).zip S
  idxRows.map fun (ir : Nat × List Float) =>
    let i := ir.fst
    let row := ir.snd
    let di := (deg.drop i).headD 0.0
    let idxVals := (List.range row.length).zip row
    idxVals.map fun (jr : Nat × Float) =>
      let j := jr.fst
      let val := jr.snd
      if i = j then di - val else 0.0 - val

/-- One Krylov step: normalise S · v. -/
@[simp] def krylovStep (S : List (List Float)) (v : List Float) : List Float :=
  let mv := S.map (fun row => dotLL row v)
  let energy := dotLL mv mv
  let denom := Float.sqrt (fmax 1e-12 energy)
  mv.map (fun x => x / denom)

/-- Rayleigh quotient vᵀ L v / vᵀ v as a coarse frequency score. -/
@[simp] def rayleighLL (L : List (List Float)) (v : List Float) : Float :=
  let mv := L.map (fun row => dotLL row v)
  let num := dotLL v mv
  let base := dotLL v v
  let den := fmax 1e-12 base
  num / den

/-- Build a small Krylov sequence and record Rayleigh energies along the way. -/
@[simp] def harmonicSummary (S : List (List Float)) (k : Nat) : List Float :=
  let dim := match S with
    | [] => 0
    | row :: _ => row.length
  if dim = 0 ∨ k = 0 then [] else
    let L := laplacianLL S
    let baseVal := 1.0 / Float.ofNat (Nat.max 1 dim)
    let rec build : Nat → List Float → List Float → List Float
      | 0, _v, acc => acc.reverse
      | Nat.succ fuel, v, acc =>
          let rq := rayleighLL L v
          let v' := krylovStep S v
          build fuel v' (rq :: acc)
    let v0 := List.replicate dim baseVal
    build k v0 []

/-- Low-frequency resonance: first two Rayleigh scores under τLow. -/
@[simp] def harmonicResonance (bands : List Float) (τLow : Float := 0.2) : Prop :=
  match bands with
  | [] => True
  | [b] => b ≤ τLow
  | b₁ :: b₂ :: _ => b₁ ≤ τLow ∧ b₂ ≤ τLow

/-- High-frequency richness: some score beyond the first two exceeds τHigh. -/
@[simp] def harmonicDissonance (bands : List Float) (τHigh : Float := 0.8) : Prop :=
  ∃ b, b ∈ bands.drop 2 ∧ b ≥ τHigh

/-- Variance of weights in a row (local irregularity). -/
@[simp] def rowVariance (row : List Float) : Float :=
  let n := Nat.max 1 row.length
  let denom := Float.ofNat n
  let mean := (row.foldl (fun acc x => acc + x) 0.0) / denom
  let sq := row.foldl (fun acc x =>
    let d := x - mean
    acc + d * d) 0.0
  sq / denom

/-- Average row variance (global roughness proxy). -/
@[simp] def meanRowVariance (S : List (List Float)) : Float :=
  let n := Nat.max 1 S.length
  let total := S.foldl (fun acc row => acc + rowVariance row) 0.0
  total / Float.ofNat n

/-- High-frequency energy from the tail of the harmonic summary. -/
@[simp] def spectralGraininess (S : List (List Float)) (k : Nat := 4) : Float :=
  let bands := harmonicSummary S k
  let tail := bands.drop (bands.length / 2)
  match tail with
  | [] => 0.0
  | _ =>
      let total := tail.foldl (fun acc x => acc + x) 0.0
      total / Float.ofNat (Nat.max 1 tail.length)

/-- Combined graininess score blending variance and spectral roughness. -/
@[simp] def graininessScore (S : List (List Float)) : Float :=
  0.5 * meanRowVariance S + 0.5 * spectralGraininess S

@[simp] def enumerateRow (row : List Float) : List (Nat × Float) :=
  (List.range row.length).zip row

/-- Collect neighbour indices above a threshold. -/
@[simp] def neighborSet (row : List Float) (τ : Float) : List Nat :=
  (enumerateRow row).foldr
    (fun pair acc => if pair.snd ≥ τ then pair.fst :: acc else acc) []

/-- Jaccard similarity between two finite sets represented as lists. -/
@[simp] noncomputable def jaccard (xs ys : List Nat) : Float :=
  let xu := xs.eraseDups
  let yu := ys.eraseDups
  let inter := (xu.filter fun i => yu.contains i).length
  let union := ((xu ++ yu).eraseDups).length
  if union = 0 then 1.0 else Float.ofNat inter / Float.ofNat union

/-- Build neighbour lists for each row under threshold τ. -/
@[simp] def neighborMatrix (S : List (List Float)) (τ : Float) : List (List Nat) :=
  S.map fun row => neighborSet row τ

@[simp] def getRow {α} (rows : List (List α)) (i : Nat) : List α :=
  (rows.drop i).headD []

/-- Zip two lists truncating to the shorter length. -/
@[simp] def zipWithTrunc {α β γ}
    (f : α → β → γ) : List α → List β → List γ
  | [], _ => []
  | _, [] => []
  | a :: as, b :: bs => f a b :: zipWithTrunc f as bs

/-- Average neighbour persistence measured by Jaccard similarity. -/
@[simp] noncomputable def stickinessJaccard
    (Sprev Scur : List (List Float)) (τ : Float) : Float :=
  let Np := neighborMatrix Sprev τ
  let Nc := neighborMatrix Scur τ
  let count := Nat.min Np.length Nc.length
  let sims := (List.range count).map fun i =>
    jaccard (getRow Np i) (getRow Nc i)
  match sims with
  | [] => 1.0
  | _ =>
      let total := sims.foldl (fun acc x => acc + x) 0.0
      total / Float.ofNat sims.length

/-- Fraction of edges whose weights change at most ε. -/
@[simp] noncomputable def edgeInertia
    (Sprev Scur : List (List Float)) (ε : Float) : Float :=
  let rows := zipWithTrunc (fun a b => zipWithTrunc (fun x y => Float.abs (x - y) ≤ ε) a b) Sprev Scur
  let good := rows.foldl (fun acc r =>
    r.foldl (fun inner b => inner + (if b then 1 else 0)) acc) 0
  let total := rows.foldl (fun acc r => acc + r.length) 0
  if total = 0 then 1.0 else Float.ofNat good / Float.ofNat total

/-- Stickiness score combining neighbour persistence and edge inertia. -/
@[simp] noncomputable def stickinessScore
    (Sprev Scur : List (List Float)) (τ : Float := 0.1) (ε : Float := 1e-3) : Float :=
  0.5 * stickinessJaccard Sprev Scur τ + 0.5 * edgeInertia Sprev Scur ε

/-- Graininess predicate (high implies pronounced fine structure). -/
@[simp] def grainy (S : List (List Float)) (τHigh : Float := 0.5) : Prop :=
  graininessScore S ≥ τHigh

/-- Stickiness predicate capturing persistence across steps. -/
@[simp] def sticky
    (Sprev Scur : List (List Float)) (τStick : Float := 0.7)
    (τ : Float := 0.1) (ε : Float := 1e-3) : Prop :=
  stickinessScore Sprev Scur τ ε ≥ τStick

end IVI
