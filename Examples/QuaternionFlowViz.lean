/-
  Examples/QuaternionFlowViz.lean
  Visualization of the quaternion flow system.
  
  This example demonstrates:
  1. Creating a quaternion flow
  2. Projecting to both IVI and Quantum spaces
  3. Visualizing the dual interpretation
-/

import IVI.QuaternionFlow
import Lean.Data.Json

namespace IVI.Examples

open Quaternion

/-- 
Generate a visualization of the quaternion flow as JSON
that can be plotted using a JavaScript visualization library.
-/
def visualizeFlow (flow : List QuaternionFlow.QuatFlowState) : String :=
  let entries := flow.map λ state => 
    let ivi := state.toIVI
    let qm := state.toQuantum
    s!"""
    {{
      "time": {state.time},
      "scale": {state.scale},
      "orientation": [{state.orientation.re}, {state.orientation.imI}, {state.orientation.imJ}, {state.orientation.imK}],
      "ivi": {{
        "scale": {ivi.scale},
        "entropy": {ivi.entropy},
        "direction": [{ivi.direction.i}, {ivi.direction.j}, {ivi.direction.k}]
      }},
      "quantum": {{
        "scale": {qm.scale},
        "entropy": {qm.entropy},
        "direction": [{qm.direction.i}, {qm.direction.j}, {qm.direction.k}]
      }},
      "flat_dimension": {state.flatDimension 1.0 1.0}
    }}"""
  
  s!"""
  {{
    "metadata": {{
      "description": "Quaternion Flow Visualization",
      "steps": {flow.length},
      "has_quantum": true,
      "has_ivi": true
    }},
    "data": [
      {String.intercalate ",\n      " entries}
    ]
  }}"""

/-- 
Example: Spiral zoom visualization
-/
def main : IO Unit := do
  -- Create a spiral zoom flow
  let flow := QuaternionFlow.exampleSpiralZoom 100
  
  -- Generate visualization JSON
  let vizData := visualizeFlow flow
  
  -- Write to file (can be loaded by a web-based visualizer)
  IO.FS.writeFile "quaternion_flow_viz.json" vizData
  
  -- Print summary
  let first := flow[0]!
  let last := flow[flow.length - 1]!
  
  IO.println "✅ Generated quaternion flow visualization"
  IO.println s!"- Time: {first.time:.2f} → {last.time:.2f}"
  IO.println s!"- Scale: {first.scale:.2f} → {last.scale:.2f}"
  IO.println s!"- IVI Scale: {first.toIVI.scale:.2f} → {last.toIVI.scale:.2f}"
  IO.println s!"- QM Scale: {first.toQuantum.scale:.2f} → {last.toQuantum.scale:.2f}"
  IO.println "\nVisualization data written to: quaternion_flow_viz.json"

end IVI.Examples

-- Run the example
#eval IVI.Examples.main
