/-
  IVI/Demo.lean
  Minimal demonstration wiring abstract IVI operators across domains.
-/

import IVI.Core
import IVI.Pure
import IVI.Logic
import IVI.Operators
import IVI.Domain
import IVI.System
import IVI.C3Model
import IVI.Theorems
import IVI.Proofs
import IVI.Intangible
import IVI.Invariant
import IVI.Harmonics
import IVI.Fractal

open IVI
open Intangible
open Invariant

set_option autoImplicit true

def main : IO Unit := do
  IO.println "IVI demo — abstract, non-measurement verification"

  -- Mathematics
  let Rm := Math.recips
  let Jm := Math.J
  let x  := Math.fSVO
  let y  : SVO Math.Obj := { repr := fun n => n + 1, status := .possible }
  let _  := VWM_symm Rm Jm.ctx x y
  IO.println "Math: VWM_symm lemma available."

  -- Physics
  let Rp := Physics.recips
  let Jp := Physics.J
  let p1 := Physics.s₁
  let p2 := Physics.s₂
  IO.println "Physics: VWM predicate instantiated for sample states."

  -- Ethics
  let Re : Reciprocity Ethics.Maxim :=
    { relates := fun _ _ => True
    , symm := by intro _ _ _; trivial }
  let Je := Ethics.J
  let m1 := Ethics.tellTruth
  let _ := harmonize_singleton Re Je.ctx m1
  IO.println "Ethics: harmonize_singleton lemma available."

  -- Aesthetics with Encode
  let Ja := Aesthetics.J
  let a0 := Aesthetics.f₀
  let a1 := Encode Ja.ctx (t := (5 : Nat)) a0
  IO.println s!"Aesthetic encoded repr: {a1.repr.signature}"

  -- System closure toy check
  let S : System Math.Obj Nat := { R := Rm, recs := [Math.rec] }
  let xs : List (SVO Math.Obj) := [x]
  have closedDemo : closedUnderIVI S xs := by
    unfold closedUnderIVI
    refine And.intro ?_ ?_
    · intro y hy; cases hy
    · intro a ha b hb hne r hr; cases ha
  let _ := harmonizeIfClosed S xs closedDemo
  IO.println "System: harmonizeIfClosed produced a witness."

  -- C3 placeholder model
  let cR := C3Reciprocity (τ := Nat) (simThr := 0.1) (alignThr := 0.1)
  let sA := mkC3 1.0 0.0 0.0 0.0 0.0 0.0 0.0 "A"
  let sB := mkC3 0.9 0.05 0.0 0.0 0.0 0.0 0.1 "B"
  let svA : SVO C3State := { repr := sA, status := .possible }
  let svB : SVO C3State := { repr := sB, status := .possible }
  IO.println "C3 model: VWM predicate instantiated for sample states."

  -- Intangible verification across domains
  let k : Float := 0.5
  let mathSig : DomainSignature :=
    { name := "Math", timeShift := 0.1
    , axis := { r1 := 1, i1 := 0, r2 := 0, i2 := 0, r3 := 0, i3 := 0 } }
  let physicsSig : DomainSignature :=
    { name := "Physics", timeShift := 0.3
    , axis := { r1 := 0, i1 := 0, r2 := 1, i2 := 0, r3 := 0, i3 := 0 } }
  let ethicsSig : DomainSignature :=
    { name := "Ethics", timeShift := 0.6
    , axis := { r1 := 0, i1 := 0, r2 := 0, i2 := 0, r3 := 1, i3 := 0 } }
  let nodeMath : DomainNode := { signature := mathSig, state := sA }
  let nodePhys : DomainNode :=
    { signature := physicsSig
    , state := mkC3 0.2 0.1 0.5 0.0 0.0 0.0 0.2 "P" }
  let nodeEth : DomainNode :=
    { signature := ethicsSig
    , state := mkC3 0.0 0.0 0.3 0.0 0.8 0.0 0.4 "E" }
  let domainNodes := [nodeMath, nodePhys, nodeEth]
  let interactions : List (DomainSignature × DomainSignature) :=
    [(mathSig, physicsSig), (physicsSig, ethicsSig), (ethicsSig, mathSig)]
  let finalNodes := Intangible.resuperposeFractal k interactions 3 domainNodes
  IO.println s!"Intangible: updated time shifts {finalNodes.map (·.signature.timeShift)}"

  -- Invariant-driven convergence demo
  let domainsList : List DomainSignature := [mathSig, physicsSig, ethicsSig]
  let cfgRun : RunnerCfg := { eps := 1e-6, maxIters := 10 }
  let stepFn := fun (doms : List DomainSignature) (nodes : List DomainNode) =>
    let updated := Intangible.resuperposeStep k interactions nodes
    let updateDomain (d : DomainSignature) : DomainSignature :=
      let relevant := updated.filter (fun n => n.signature.name = d.name)
      match relevant with
      | [] => d
      | _ =>
        let sum := relevant.foldl (fun acc node => acc + node.signature.timeShift) 0.0
        let avg := sum / Float.ofNat relevant.length
        { d with timeShift := avg }
    (doms.map updateDomain, updated)
  let convergence := runUntilConverged cfgRun stepFn domainsList domainNodes
  IO.println s!"Invariant converged in {convergence.iter} iterations; lambda ≈ {convergence.invariant}"
  IO.println s!"Lambda vector (multi-scale): {convergence.lambdaVec}"
  IO.println s!"Final domain time shifts: {convergence.domains.map (·.timeShift)}"

  -- Kakeya/Harmonics/Kant-limit diagnostics across successive I-directed zooms
  let layer0 : FractalLayer := { depth := 0, nodes := domainNodes }
  let itrans : ITranslation := { k := k, pairs := interactions }
  let maxZooms : Nat := 4
  let runDiagnostics
      (label : String) (collapseFn : CollapseMeasure)
      (τIntuition τStick : Float) : IO Unit := do
    IO.println label
    let dedupNat (xs : List Nat) : List Nat :=
      let acc := xs.foldl
        (fun (acc : List Nat) x => if acc.contains x then acc else x :: acc) []
      acc.reverse
    let jaccardEval (xs ys : List Nat) : Float :=
      let xu := dedupNat xs
      let yu := dedupNat ys
      let inter := (xu.filter fun i => yu.contains i).length
      let union := (dedupNat (xu ++ yu)).length
      if union = 0 then 1.0 else Float.ofNat inter / Float.ofNat union
    let stickinessScoreEval
        (Sprev Scur : List (List Float)) (τ : Float := 0.1) (ε : Float := 1e-3) : Float :=
      let Np := neighborMatrix Sprev τ
      let Nc := neighborMatrix Scur τ
      let count := Nat.min Np.length Nc.length
      let sims := (List.range count).map fun i =>
        jaccardEval (getRow Np i) (getRow Nc i)
      let jac :=
        match sims with
        | [] => 1.0
        | _ =>
            let total := sims.foldl (fun acc x => acc + x) 0.0
            total / Float.ofNat sims.length
      let rows := zipWithTrunc
        (fun a b => zipWithTrunc (fun x y => decide (Float.abs (x - y) ≤ ε)) a b)
        Sprev Scur
      let good := rows.foldl (fun acc r =>
        r.foldl (fun inner b => inner + (if b then 1 else 0)) acc) 0
      let total := rows.foldl (fun acc r => acc + r.length) 0
      let inertia := if total = 0 then 1.0 else Float.ofNat good / Float.ofNat total
      0.5 * jac + 0.5 * inertia
    let grainInit := graininessScore (resonanceMatrixW defaultWeighting layer0.nodes)
    let collapseInit := collapseFn layer0.nodes
    IO.println s!"  layer 0: grain={grainInit}, collapse={collapseInit}"
    let rec logZooms : Nat → Nat → FractalLayer → IO Unit
      | 0, _, _ => pure ()
      | Nat.succ remaining, idx, layerPrev => do
          let (layerNext, _) := itrans.zoomE layerPrev
          let SPrev := resonanceMatrixW defaultWeighting layerPrev.nodes
          let SNext := resonanceMatrixW defaultWeighting layerNext.nodes
          let grainPrev := graininessScore SPrev
          let grainNext := graininessScore SNext
          let stickPrev := stickinessScoreEval SPrev SNext
          let collapsePrev := collapseFn layerPrev.nodes
          let boundedFlag : Bool := grainNext ≤ τIntuition
          let schematismFlag : Bool := stickPrev ≥ τStick
          let noumenalFlag : Bool := collapsePrev ≤ 1e-9
          let unityFlag : Bool := Float.abs (grainNext - grainPrev) ≤ 1e-3
          let selfSimFlag : Bool := boundedFlag ∧ schematismFlag ∧ unityFlag
          IO.println s!"  zoom {idx}→{idx+1}: grain={grainPrev}→{grainNext}, stick={stickPrev}, collapse={collapsePrev}, Kant*(b={boundedFlag}, s={schematismFlag}, n={noumenalFlag}, u={unityFlag}), self-sim≈{selfSimFlag}"
          logZooms remaining (idx + 1) layerNext
    logZooms maxZooms 0 layer0
  let collapseZero : CollapseMeasure := fun _ => 0.0
  let collapsePerturb : CollapseMeasure := fun nodes =>
    match nodes with
    | [] => 0.0
    | _ =>
        let total := nodes.foldl
          (fun acc n => acc + Intangible.spatialNorm n.state.ψ) 0.0
        let avg := total / Float.ofNat nodes.length
        avg * 1e-3
  runDiagnostics "Intangible Kakeya (μ = 0)" collapseZero 0.6 0.7
  runDiagnostics "Perturbed Kakeya (μ ∝ radius)" collapsePerturb 0.6 0.7

  -- Reference to future theorem work (placeholders compile today).
  let _ : True := T4_practical_aperture_unique
  pure ()
