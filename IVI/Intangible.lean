/-
  IVI/Intangible.lean
  Formalises the intangible verification step: translating the temporal
  component of a node according to spatial radius and angular alignment
  between domains, then iterating the process fractally across domains.
-/

import IVI.C3Model

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open Classical

/-- Domain metadata used for the intangible verification step. The
    `axis` vector gives the domain's preferred spatial orientation and
    `timeShift` is its base temporal/subjective value (the `i` factor). -/
structure DomainSignature where
  name      : String
  timeShift : Float
  axis      : C3Vec
  deriving Repr

/-- Bundle a state with its domain metadata. -/
structure DomainNode where
  signature : DomainSignature
  state     : C3State
  deriving Repr

namespace Intangible

/-- Extract the real spatial triple from a `C3Vec`. We use the real
    components as the coarse spatial embedding for intangible
    verification. -/
@[simp] def spatialNorm (v : C3Vec) : Float :=
  Float.sqrt (v.r1 * v.r1 + v.r2 * v.r2 + v.r3 * v.r3)

/-- Dot product on the real spatial triple. -/
@[simp] def dot3 (a b : C3Vec) : Float :=
  a.r1 * b.r1 + a.r2 * b.r2 + a.r3 * b.r3

/-- Clamp a float to the interval [-1, 1] to keep acos stable. -/
@[simp] def clampUnit (x : Float) : Float :=
  if x > 1.0 then 1.0 else if x < (-1.0) then (-1.0) else x

/-- Angle between two spatial triples. When one of the vectors is
    degenerate we return 0. -/
@[simp] def angleBetween (a b : C3Vec) : Float :=
  let na := spatialNorm a
  let nb := spatialNorm b
  if na == 0.0 || nb == 0.0 then
    0.0
  else
    let raw := dot3 a b / (na * nb)
    Float.acos (clampUnit raw)

/-- Normalise a spatial direction, falling back to the x-axis when the
    vector degenerates. -/
@[simp] def normaliseDir (v : C3Vec) : C3Vec :=
  let n := spatialNorm v
  if n == 0.0 then
    { r1 := 1.0, i1 := 0.0, r2 := 0.0, i2 := 0.0, r3 := 0.0, i3 := 0.0 }
  else
    { r1 := v.r1 / n
    , i1 := v.i1
    , r2 := v.r2 / n
    , i2 := v.i2
    , r3 := v.r3 / n
    , i3 := v.i3 }

/-- Orientation axis connecting two domains. If the axes coincide we
    blend their spatial directions using the time-shift delta. -/
@[simp] def axisBetween (src tgt : DomainSignature) : C3Vec :=
  let srcDir := normaliseDir src.axis
  let tgtDir := normaliseDir tgt.axis
  let Δt := tgt.timeShift - src.timeShift
  let blended := C3Vec.mk
    (srcDir.r1 + Δt * tgtDir.r1)
    (srcDir.i1)
    (srcDir.r2 + Δt * tgtDir.r2)
    (srcDir.i2)
    (srcDir.r3 + Δt * tgtDir.r3)
    (srcDir.i3)
  let dir := if spatialNorm blended == 0.0 then tgtDir else blended
  dir

/-- Core translation: Δi = k · |r⃗| · θ where θ is the angle between the
    node's spatial position and the temporal axis determined by the
    interacting domains. -/
@[simp] def deltaI (k : Float) (src tgt : DomainSignature) (node : C3State) : Float :=
  let r := spatialNorm node.ψ
  let axis := axisBetween src tgt
  let θ := angleBetween node.ψ axis
  k * r * θ

/-- Update the temporal component of a node using the intangible rule. -/
@[simp] def translateTemporal (Δ : Float) (node : C3State) : C3State :=
  { node with time := { theta := node.time.theta + Δ } }

/-- Decide whether a node belongs to a given domain (by name). -/
@[simp] def belongsTo (node : DomainNode) (sig : DomainSignature) : Bool :=
  node.signature.name = sig.name

/-- Apply a single intangible translation from `src` to `tgt` across the
    current node set. Nodes outside `tgt` are left untouched. -/
@[simp] def translateNodes (k : Float) (src tgt : DomainSignature)
    (nodes : List DomainNode) : List DomainNode :=
  nodes.map fun n =>
    if belongsTo n tgt then
      let Δ := deltaI k src tgt n.state
      let newState := translateTemporal Δ n.state
      let newSig := { n.signature with timeShift := n.signature.timeShift + Δ }
      { signature := newSig, state := newState }
    else
      n

/-- Sum of pairwise resonance scores using the existing similarity
    helper from the C3 model. -/
@[simp] def resonanceSum (nodes : List DomainNode) : Float :=
  let states := nodes.map (·.state)
  let rec loop : List C3State → Float → Float
    | [], acc => acc
    | s :: tail, acc =>
      let contrib := tail.foldl (fun a b => a + sim s.ψ b.ψ) 0.0
      loop tail (acc + contrib)
  loop states 0.0

/-- One pass of intangible verification across all ordered domain
    interactions. -/
@[simp] def resuperposeStep (k : Float)
    (pairs : List (DomainSignature × DomainSignature))
    (nodes : List DomainNode) : List DomainNode :=
  pairs.foldl (fun acc (p : DomainSignature × DomainSignature) =>
    translateNodes k p.fst p.snd acc) nodes

/-- Iterate the intangible verification step a bounded number of times
    (the `fuel` argument). This stands in for the fractal recursion in
    a computationally safe way. -/
@[simp] def resuperposeFractal (k : Float)
    (pairs : List (DomainSignature × DomainSignature))
    (fuel : Nat) (nodes : List DomainNode) : List DomainNode :=
  match fuel with
  | 0 => nodes
  | Nat.succ f =>
    let updated := resuperposeStep k pairs nodes
    resuperposeFractal k pairs f updated

end Intangible

end IVI
