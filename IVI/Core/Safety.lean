/-
  IVI/Core/Safety.lean
  Safety predicates and proofs for IVI transformations.
  
  Defines what it means for a fractal layer to be "safe"
  and provides proofs that transformations preserve safety.
-/

import IVI.Core.Types
import Mathlib.Topology.MetricSpace.Basic

namespace IVI

open DomainNode FractalLayer

/--
Proof that a fractal layer satisfies all safety constraints
specified in the configuration.
-/
structure KakeyaSafeLayer (cfg : ICollapseCfg) (L : FractalLayer) where
  /-- All nodes must respect the minimum grain size -/
  grain_safe : ∀ n ∈ L.nodes, n.grainSize ≥ cfg.minGrainSize
  
  /-- Branching factor must be within limits -/
  branching_safe : L.nodes.length ≤ cfg.maxBranching
  
  /-- Total node count must be within limits -/
  node_count_safe : cfg.maxNodes.map (L.nodes.length ≤ ·) |>.getD true
  
  /-- Depth must be within limits -/
  depth_safe : cfg.maxDepth.map (L.depth ≤ ·) |>.getD true
  
  /-- Energy must be conserved within tolerance -/
  energy_safe : 
    let initialEnergy := L.nodes.foldl (fun acc n => acc + n.energy) 0
    let currentEnergy := L.totalEnergy
    currentEnergy ≤ initialEnergy * (1 + cfg.energyTolerance)

/--
A fractal layer bundled with a proof that it satisfies
all safety constraints.
-/
structure SafeLayer (cfg : ICollapseCfg) where
  /-- The underlying fractal layer -/
  layer : FractalLayer
  
  /-- Proof that this layer is safe -/
  isSafe : KakeyaSafeLayer cfg layer
  
  deriving Repr

namespace KakeyaSafeLayer

/-- The empty layer is trivially safe -/
instance : Inhabited (KakeyaSafeLayer cfg default) where
  default := {
    grain_safe := by simp [FractalLayer.nodes]
    branching_safe := Nat.zero_le _
    node_count_safe := rfl
    depth_safe := rfl
    energy_safe := by simp [FractalLayer.totalEnergy]
  }

/-- Check if a node can be safely added to a layer -/
def canAddNode (safeL : KakeyaSafeLayer cfg L) (n : DomainNode) : Prop :=
  n.grainSize ≥ cfg.minGrainSize ∧
  L.nodes.length < cfg.maxBranching ∧
  cfg.maxNodes.map (L.nodes.length < ·) |>.getD true

/-- Add a node to a safe layer if it preserves safety -/
def addNode (safeL : KakeyaSafeLayer cfg L) (n : DomainNode) 
  (h : safeL.canAddNode n) : KakeyaSafeLayer cfg {
    L with 
      nodes := n :: L.nodes
      totalEnergy := L.totalEnergy + n.energy
  } := {
    grain_safe := by
      intro m hm
      simp at hm
      cases hm with
      | inl heq => rw [←heq]; exact h.1
      | inr hm => exact safeL.grain_safe m hm
      
    branching_safe := by
      simp [FractalLayer.nodes]
      exact Nat.le_trans (Nat.le_succ _) h.2.1
      
    node_count_safe := by
      cases cfg.maxNodes with
      | none => simp
      | some max => 
        simp [FractalLayer.nodes] 
        exact Nat.lt_of_lt_of_le h.2.2 (Nat.le_succ _)
        
    depth_safe := safeL.depth_safe
    
    energy_safe := by
      simp [FractalLayer.totalEnergy, *]
      ring
  }

end KakeyaSafeLayer

/--
Lift a function on fractal layers to safe layers,
proving that it preserves safety.
-/
protected def SafeLayer.map 
  (f : FractalLayer → FractalLayer)
  (h_safe : ∀ L cfg, KakeyaSafeLayer cfg L → KakeyaSafeLayer cfg (f L)) :
  SafeLayer cfg → SafeLayer cfg := 
  fun ⟨L, hL⟩ => ⟨f L, h_safe L _ hL⟩

/--
Lift a partial function on fractal layers to safe layers,
failing if the result would be unsafe.
-/
protected def SafeLayer.bind?
  (f : FractalLayer → Option FractalLayer)
  (h_safe : ∀ L cfg, KakeyaSafeLayer cfg L → 
    ∀ L', f L = some L' → KakeyaSafeLayer cfg L') :
  SafeLayer cfg → Option (SafeLayer cfg) := 
  fun ⟨L, hL⟩ => (f L).map fun L' => ⟨L', h_safe L _ hL _ rfl⟩

end IVI
