/-
  IVI/Collapse.lean
  Collapse configuration for i-directional grain thresholds and helpers
  to evaluate when a layer exceeds the allowed graininess.
-/

import IVI.Intangible
import IVI.Harmonics
import IVI.Invariant

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open Classical
open Invariant

/-- Configuration controlling when i-direction graininess counts as a
    collapse along the intangible axis. `τGrain` is the nominal limit and
    `ε` gives a small hysteresis margin so that callers can distinguish
    "definitely collapsed" (above the margin) from borderline cases. -/
structure ICollapseCfg where
  τGrain : Float := 0.5
  ε      : Float := 1e-6
  W      : Weighting := defaultWeighting

@[simp] def ICollapseCfg.collapseScore
    (cfg : ICollapseCfg) (nodes : List DomainNode) : Float :=
  graininessScore (resonanceMatrixW cfg.W nodes)

@[simp] def ICollapseCfg.safeScore (cfg : ICollapseCfg) (score : Float) : Prop :=
  score ≤ cfg.τGrain

@[simp] def ICollapseCfg.collapsedScore (cfg : ICollapseCfg) (score : Float) : Prop :=
  cfg.τGrain + cfg.ε ≤ score

@[simp] def ICollapseCfg.grainSafe
    (cfg : ICollapseCfg) (nodes : List DomainNode) : Prop :=
  cfg.safeScore (cfg.collapseScore nodes)

@[simp] def ICollapseCfg.grainCollapse
    (cfg : ICollapseCfg) (nodes : List DomainNode) : Prop :=
  cfg.collapsedScore (cfg.collapseScore nodes)

@[simp] def ICollapseCfg.grainSafeBool
    (cfg : ICollapseCfg) (nodes : List DomainNode) : Bool :=
  decide (cfg.collapseScore nodes ≤ cfg.τGrain)

@[simp] def ICollapseCfg.grainCollapseBool
    (cfg : ICollapseCfg) (nodes : List DomainNode) : Bool :=
  decide (cfg.τGrain + cfg.ε ≤ cfg.collapseScore nodes)

@[simp] theorem ICollapseCfg.grainSafeBool_iff
    (cfg : ICollapseCfg) (nodes : List DomainNode) :
    cfg.grainSafeBool nodes = true ↔ cfg.grainSafe nodes := by
  simp [ICollapseCfg.grainSafeBool, ICollapseCfg.grainSafe,
        ICollapseCfg.safeScore]

@[simp] theorem ICollapseCfg.grainCollapseBool_iff
    (cfg : ICollapseCfg) (nodes : List DomainNode) :
    cfg.grainCollapseBool nodes = true ↔ cfg.grainCollapse nodes := by
  simp [ICollapseCfg.grainCollapseBool, ICollapseCfg.grainCollapse,
        ICollapseCfg.collapsedScore]

end IVI
