/-
  IVI/KantLimit.lean
  Bridges Kant's limiting structures with IVI grain/stick and Kakeya fields.
  Provides predicates that interpret IVI invariants as Kantian bounds.
-/

import IVI.Invariant
import IVI.Harmonics
import IVI.Kakeya

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open Invariant

/-- Bounded form of intuition: graininess sits below the space–time threshold. -/
@[simp] def boundedIntuition (S : List (List Float)) (τ : Float) : Prop :=
  graininessScore S ≤ τ

/-- Schematism bound: stickiness stays above the required level. -/
@[simp] noncomputable def schematismBound
    (Sprev Scur : List (List Float)) (τStick : Float)
    (τ : Float := 0.1) (ε : Float := 1e-3) : Prop :=
  stickinessScore Sprev Scur τ ε ≥ τStick

/-- Noumenal boundary: Kakeya field remains collapse-free. -/
@[simp] def noumenalBoundary (K : KakeyaField) : Prop :=
  K.isCollapseZero

/-- Unity of apperception: reuse the invariant unity predicate. -/
@[simp] def unityOfApperception (cfgInv : InvariantCfg)
    (prev_nodes cur_nodes : List DomainNode) (ev : StepEvidence) : Prop :=
  let lamPrev := spectralInvariantW cfgInv.W prev_nodes
  let lamCur  := spectralInvariantW cfgInv.W cur_nodes
  let props := invariantProps cfgInv lamPrev lamCur prev_nodes cur_nodes ev
  props.unityProgress

/-- Bundle the Kantian limiting conditions derived from an IVI step. -/
structure KantLimit where
  boundedIntuition : Prop
  schematismBound  : Prop
  noumenalBoundary : Prop
  unity            : Prop

/-- Build Kant-limit data from successive node states and a Kakeya witness. -/
@[simp] noncomputable def kantLimitFrom
    (cfgInv : InvariantCfg)
    (τIntuition τStick : Float)
    (τ : Float := 0.1) (ε : Float := 1e-3)
    (prev_nodes cur_nodes : List DomainNode)
    (ev : StepEvidence) (K : KakeyaField) : KantLimit :=
  let Sprev := symmetriseLL (weightsFrom cfgInv.W prev_nodes)
  let Scur  := symmetriseLL (weightsFrom cfgInv.W cur_nodes)
  { boundedIntuition := boundedIntuition Scur τIntuition
  , schematismBound  := schematismBound Sprev Scur τStick τ ε
  , noumenalBoundary := noumenalBoundary K
  , unity            := unityOfApperception cfgInv prev_nodes cur_nodes ev }

end IVI

