/-
  Examples/SimpleDemo.lean
  A simple demonstration of safe fractal transformations.
  
  This example shows how to:
  1. Create a simple fractal layer
  2. Apply safe transformations
  3. Verify safety properties
-/

import IVI.Core.TransformSafe
import IVI.Core.Types

namespace IVI.Examples

open IVI.DomainNode IVI.FractalLayer IVI.KakeyaSafeLayer IVI.TransformSafe

/-- Create a simple initial layer with a single node -/
def createInitialLayer (cfg : ICollapseCfg) : SafeLayer cfg where
  layer := {
    nodes := [{
      position := (0.0, 0.0, 0.0)
      grainSize := 1.0
      energy := 1.0
      phase := 0.0
      neighbors := []
    }]
    depth := 0
  }
  isSafe := {
    grain_safe := by simp [ICollapseCfg.minGrainSize, defaultConfig]
    branching_safe := by simp
    node_count_safe := by simp
    depth_safe := by simp
    energy_safe := by simp
  }

/-- Run a simple demonstration -/
def runDemo : IO Unit := do
  let cfg := defaultConfig
  let initial := createInitialLayer cfg
  
  IO.println "Starting with initial layer:"
  IO.println s!"- Nodes: {initial.layer.nodes.length}"
  IO.println s!"- Grain size: {initial.layer.nodes[0]!.grainSize}"
  
  -- Zoom in
  match zoomE_safe cfg initial .in_ with
  | some zoomed =>
    IO.println "\nAfter zooming in:"
    IO.println s!"- Nodes: {zoomed.layer.nodes.length}"
    IO.println s!"- Grain size: {zoomed.layer.nodes[0]!.grainSize}"
    
    -- Resuperpose
    match resuperpose_safe cfg zoomed 2 with
    | some resup =>
      IO.println "\nAfter resuperposition:"
      IO.println s!"- Nodes: {resup.layer.nodes.length}"
      IO.println s!"- Grain size: {resup.layer.nodes[0]!.grainSize}"
      
      -- Try to zoom out
      match zoomE_safe cfg resup .out with
      | some zoomedOut =>
        IO.println "\nAfter zooming out:"
        IO.println s!"- Nodes: {zoomedOut.layer.nodes.length}"
        IO.println s!"- Grain size: {zoomedOut.layer.nodes[0]!.grainSize}"
      | none => IO.println "\nFailed to zoom out (safety violation)"
      
    | none => IO.println "\nResuperposition failed (safety violation)"
    
  | none => IO.println "\nZoom in failed (safety violation)"

/-- Run the demo -/
#eval runDemo

end IVI.Examples
