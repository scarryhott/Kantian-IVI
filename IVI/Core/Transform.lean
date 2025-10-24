/-
  IVI/Core/Transform.lean
  Core transformation functions for fractal layers.
  
  Implements zooming, resuperposition, and other operations
  that can be composed to build complex transformations.
-/

import IVI.Core.Types
import IVI.Core.Safety
import Mathlib.Topology.MetricSpace.Basic

namespace IVI

open DomainNode FractalLayer

/--
Zoom the fractal layer by the given direction and scale.
This is the unsafe version that doesn't guarantee safety.
-/
def zoomE (L : FractalLayer) (dir : ZoomDirection) : FractalLayer := Id.run do
  let scale := match dir with
    | .in_ => 0.5  -- Zoom in by 2x
    | .out => 2.0  -- Zoom out by 1/2x
    | .custom s => s.toReal
  
  -- Scale positions and grain sizes
  let nodes ← L.nodes.mapM fun n => do
    let newPos := n.position.map (· * scale)
    let newGrain := n.grainSize * scale.toNNReal
    { n with 
      position := newPos
      grainSize := newGrain
    }
  
  -- Update derived properties
  { L with 
    nodes := nodes
    depth := match dir with
      | .in_ => L.depth + 1
      | .out => L.depth - 1
      | _ => L.depth
    -- Other properties will be recalculated automatically
  }

/--
Single step of resuperposition: refine nodes that are too large
relative to the local feature size.
-/
def resuperposeStep (cfg : ICollapseCfg) (L : FractalLayer) : FractalLayer := Id.run do
  let mut newNodes : List DomainNode := []
  
  for n in L.nodes do
    -- If grain size is too large, split the node
    if n.grainSize > cfg.minGrainSize * 2 then
      -- Simple splitting: replace with 8 smaller nodes
      let childGrain := n.grainSize / 2
      let childEnergy := n.energy / 8
      
      -- Generate child nodes in a 2x2x2 grid
      for dx in [0, 1] do
        for dy in [0, 1] do
          for dz in [0, 1] do
            let offset : ℝ³ := (
              (dx - 0.5) * n.grainSize,
              (dy - 0.5) * n.grainSize,
              (dz - 0.5) * n.grainSize
            )
            let childPos := n.position + offset
            
            newNodes := {
              position := childPos
              grainSize := childGrain
              energy := childEnergy
              phase := n.phase + (dx + 2*dy + 4*dz) * (π/4)
              neighbors := []  -- Will be updated in a second pass
            } :: newNodes
    else
      newNodes := n :: newNodes
  
  -- Update neighbor relationships (simplified)
  let newNodesArray := newNodes.toArray
  let newNodes' ← newNodesArray.mapIdxM fun i n => do
    let neighbors := newNodesArray.filterIdx fun j _ => 
      i ≠ j && (newNodesArray[j]!.position - n.position).norm < 1.1 * n.grainSize
    pure { n with neighbors := neighbors.toList.map (·.1) }
  
  { L with 
    nodes := newNodes'.toList
    depth := L.depth + 1
  }

/--
Collapse nodes that are too small or too close together.
This is the dual operation to resuperposition.
-/
def collapseStep (cfg : ICollapseCfg) (L : FractalLayer) : FractalLayer := Id.run do
  -- Group nodes that should be merged
  let mut merged : Array (List DomainNode) := #[]
  let mut mergedPos : Array ℕ := Array.mkArray L.nodes.length 0
  
  -- Simple greedy clustering (can be optimized)
  for (i, n) in L.nodes.toArray.toList.enum do
    if h : i < mergedPos.size then
      if mergedPos[i]! = 0 then continue
      
      -- Start a new cluster
      mergedPos := mergedPos.set! i (merged.size + 1)
      let cluster := [n]
      
      -- Find all nodes that should be in this cluster
      let mut toProcess := [i]
      while let some j := toProcess.head? do
        toProcess := toProcess.tailD []
        let nj := L.nodes.get! j
        
        -- Check all other nodes
        for (k, nk) in L.nodes.toArray.toList.enum do
          if k ≠ j && mergedPos.get! k = 0 then
            let dist := (nj.position - nk.position).norm
            if dist < cfg.minGrainSize then
              mergedPos := mergedPos.set! k (merged.size + 1)
              toProcess := k :: toProcess
              merged := merged.push [nk]
      
      merged := merged.push cluster
  
  -- Merge nodes in each cluster
  let newNodes ← merged.mapM fun cluster => do
    if cluster.isEmpty then none else
    let totalEnergy := cluster.foldl (· + ·.energy) 0
    let avgPos := cluster.foldl (· + ·.position) 0.0 / cluster.length.toReal
    let avgPhase := cluster.foldl (· + ·.phase) 0.0 / cluster.length.toReal
    
    some {
      position := avgPos
      grainSize := cluster[0]!.grainSize * 2  -- Coarser grain
      energy := totalEnergy
      phase := avgPhase
      neighbors := []  -- Will be updated by caller
    }
  
  { L with 
    nodes := newNodes.toList.filterMap id
    depth := max 0 (L.depth - 1)
  }

/--
Composition of zoom and resuperposition steps.
This is the main workhorse for navigating the fractal.
-/
def zoomAndResuperpose 
  (cfg : ICollapseCfg) 
  (dir : ZoomDirection) 
  (steps : ℕ := 1) : 
  FractalLayer → FractalLayer := 
  match dir with
  | .in_ => 
    -- Zoom in: first zoom, then resuperpose
    (fun L => (List.range steps).foldl (fun L _ => resuperposeStep cfg L) L) ∘ 
    zoomE · dir
  | _ => 
    -- Zoom out: first collapse, then zoom
    zoomE · dir ∘ 
    (fun L => (List.range steps).foldl (fun L _ => collapseStep cfg L) L)

end IVI
