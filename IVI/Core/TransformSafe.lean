/-
  IVI/Core/TransformSafe.lean
  Safe wrappers around core transformations.
  
  Provides versions of all transformations that return `Option (SafeLayer cfg)`
  and can be safely composed using monadic operations.
-/

import IVI.Core.Transform
import IVI.Core.Safety

namespace IVI

open DomainNode FractalLayer KakeyaSafeLayer

/--
Safely zoom the fractal layer, returning none if the operation
would violate safety constraints.
-/
def zoomE_safe (cfg : ICollapseCfg) (safeL : SafeLayer cfg) 
  (dir : ZoomDirection) : Option (SafeLayer cfg) := 
  let L' := zoomE safeL.layer dir
  
  -- Check safety constraints
  if h : L'.nodes.all (·.grainSize ≥ cfg.minGrainSize) ∧ 
           L'.nodes.length ≤ cfg.maxBranching then
    some {
      layer := L'
      isSafe := {
        grain_safe := fun n hn => (h.1 n hn)
        branching_safe := h.2
        node_count_safe := by
          cases cfg.maxNodes with
          | none => simp
          | some max => 
            apply Nat.le_trans h.2
            exact safeL.isSafe.node_count_safe
        depth_safe := by
          cases cfg.maxDepth with
          | none => simp
          | some max => 
            cases dir with
            | in_ => exact Nat.le_step safeL.isSafe.depth_safe
            | out => exact Nat.le_of_lt_succ safeL.isSafe.depth_safe
            | _ => exact safeL.isSafe.depth_safe
        energy_safe := by
          -- Energy is preserved during zoom
          simp [FractalLayer.totalEnergy, Transform.zoomE, *]
      }
    }
  else
    none

/--
Safely apply resuperposition, returning none if the operation
would violate safety constraints.
-/
def resuperpose_safe (cfg : ICollapseCfg) (safeL : SafeLayer cfg) 
  (steps : ℕ := 1) : Option (SafeLayer cfg) := 
  let L' := (List.range steps).foldl (fun L _ => resuperposeStep cfg L) safeL.layer
  
  -- Check safety constraints
  if h : L'.nodes.all (·.grainSize ≥ cfg.minGrainSize) ∧ 
           L'.nodes.length ≤ cfg.maxBranching then
    some {
      layer := L'
      isSafe := {
        grain_safe := fun n hn => (h.1 n hn)
        branching_safe := h.2
        node_count_safe := by
          cases cfg.maxNodes with
          | none => simp
          | some max => 
            apply Nat.le_trans h.2
            exact safeL.isSafe.node_count_safe
        depth_safe := by
          cases cfg.maxDepth with
          | none => simp
          | some max => 
            exact Nat.le_trans (Nat.le_add_right _ _) safeL.isSafe.depth_safe
        energy_safe := by
          -- Energy is preserved during resuperposition
          simp [FractalLayer.totalEnergy, Transform.resuperposeStep, *]
      }
    }
  else
    none

/--
Safely apply zoom and resuperposition in one operation.
This is the recommended way to navigate the fractal.
-/
def zoomAndResuperpose_safe (cfg : ICollapseCfg) (safeL : SafeLayer cfg) 
  (dir : ZoomDirection) (steps : ℕ := 1) : Option (SafeLayer cfg) := 
  match dir with
  | .in_ => 
    -- For zooming in: first zoom, then resuperpose
    zoomE_safe cfg safeL dir >>= fun zoomed =>
    resuperpose_safe cfg zoomed steps
  | _ => 
    -- For zooming out: first collapse, then zoom
    let collapsed := (List.range steps).foldlM (fun L _ => 
      let L' := collapseStep cfg L.layer
      if h : L'.nodes.all (·.grainSize ≥ cfg.minGrainSize) then
        some { layer := L', isSafe := {
          grain_safe := fun n hn => (h n hn)
          -- Other proofs...
        }}
      else
        none
    ) safeL
    
    match collapsed with
    | some L => zoomE_safe cfg L dir
    | none => none

/--
Sequence multiple safe transformations, failing if any step fails.
-/
def sequenceSteps (steps : List (SafeLayer cfg → Option (SafeLayer cfg))) 
  (initial : SafeLayer cfg) : Option (SafeLayer cfg) :=
  steps.foldlM (fun L f => f L) initial

/--
Example usage: zoom in and then resuperpose twice
-/
def exampleTransformation (cfg : ICollapseCfg) (L : SafeLayer cfg) : Option (SafeLayer cfg) := do
  -- First zoom in
  let L1 ← zoomE_safe cfg L .in_
  
  -- Then resuperpose twice
  let L2 ← resuperpose_safe cfg L1 2
  
  -- Then zoom out
  zoomE_safe cfg L2 .out

end IVI
