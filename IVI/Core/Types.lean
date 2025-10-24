/-
  IVI/Core/Types.lean
  Core type definitions for the IVI framework.
  
  Defines the fundamental structures for representing fractal layers
  and domain nodes with their geometric and semantic properties.
-/

import Mathlib.Data.Real.EReal
import Mathlib.Topology.MetricSpace.Basic

namespace IVI

/--
A node in the fractal domain, representing a region of space
with associated geometric and semantic properties.
-/
structure DomainNode where
  -- Geometric properties
  position : ℝ³
  grainSize : ℝ≥0  -- Minimum feature size in this region
  
  -- Semantic properties
  energy : ℝ≥0     -- Energy/importance of this node
  phase : ℝ        -- Phase angle for wave interference
  
  -- Connectivity
  neighbors : List ℕ  -- Indices of connected nodes
  
  -- Derived properties (cached for performance)
  volume : ℝ≥0 := (grainSize)^3
  
  deriving Repr, Inhabited

/--
A layer in the fractal hierarchy, representing a complete
state of the system at a particular scale.
-/
structure FractalLayer where
  -- Core data
  nodes : List DomainNode
  depth : ℕ  -- Recursion depth (0 = coarsest scale)
  
  -- Global properties
  totalEnergy : ℝ≥0 := nodes.foldl (fun acc n => acc + n.energy) 0
  
  -- Cached metrics
  boundingBox : ℝ³ × ℝ³ :=  -- (min_corner, max_corner)
    let xs := nodes.map (·.position.x)
    let ys := nodes.map (·.position.y)
    let zs := nodes.map (·.position.z)
    ( (⨅ xs, ⨅ ys, ⨅ zs), (⨆ xs, ⨆ ys, ⨆ zs) )
  
  volume : ℝ≥0 := 
    let ((x1, y1, z1), (x2, y2, z2)) := boundingBox
    (x2 - x1) * (y2 - y1) * (z2 - z1)
  
  deriving Repr, Inhabited

/--
Configuration parameters that control the behavior of
IVI transformations and safety checks.
-/
structure ICollapseCfg where
  -- Grain size thresholds
  minGrainSize : ℝ≥0     -- Absolute minimum allowed grain size
  grainDecay : ℝ≥0       -- Minimum scaling factor per zoom level (0 < x ≤ 1)
  
  -- Branching limits
  maxBranching : ℕ       -- Maximum nodes per parent
  maxDepth : Option ℕ    -- Optional maximum recursion depth
  
  -- Energy conservation
  energyTolerance : ℝ≥0  -- Allowed energy drift (0 = exact conservation)
  
  -- Performance
  maxNodes : Option ℕ    -- Safety limit on total nodes
  
  deriving Repr, Inhabited

/-- Default configuration with safe defaults -/
defaultConfig : ICollapseCfg where
  minGrainSize := 0.001
  grainDecay := 0.5
  maxBranching := 8
  maxDepth := some 10
  energyTolerance := 0.01
  maxNodes := some 10000

/-- Direction for zooming operations -/
inductive ZoomDirection
  | in_    -- Zoom in (higher detail)
  | out    -- Zoom out (lower detail)
  | custom (scale : ℝ≥0)  -- Custom scale factor
  
  deriving Repr, Inhabited

end IVI
