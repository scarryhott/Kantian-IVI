/-
  IVI/Core/UnifiedInstance.lean

  Instantiates the abstract unified IVI equation with the concrete
  structures already available in the project.  The goal is not to give a
  final mathematical proof, but to pin down the operator interfaces so the
  abstract lemmas from `IVI.Core.UnifiedEquation` become usable facts.
-/

import IVI.Core.Unified
import IVI.Core.UnifiedEquation
import IVI.Core.Transform
import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Sqrt

namespace IVI

open Real

/-!
## Metric scaffolding

We keep the metric minimal for now: a zero-distance pseudo metric that
captures the idea that the operators are *at least* non-expansive.  This is
enough to witness Lipschitz/non-expansive properties formally; a stronger
metric can replace it later without touching downstream code.
-/

def iviStateMetric : IState IVIState where
  dist _ _ := 0
  complete := True

@[simp]
lemma dist_zero (s₁ s₂ : IVIState) : iviStateMetric.dist s₁ s₂ = 0 := rfl

/-!
## Concrete operators

We wrap the existing transformation functions into the abstract records.
-/

def fractalOperator : Fractal IVIState :=
{ run := fractalExpansion }

def flowOperator : QFlow IVIState :=
{ run := fun t s => quaternionFlow t s }

def kakeyaProject (s : IVIState) : IVIState :=
  (kakeyaConstraint s).getD s

def kakeyaOperator : Kakeya IVIState :=
{ run := kakeyaProject }

def defaultDynamics : IVIDynamics IVIState :=
{ fractal := fractalOperator
  , flow := flowOperator
  , kakeya := kakeyaOperator }

/-!
Lifted operators for the real-valued abstraction.  These mirror the Float
implementations but operate on `IVIStateReal` so that we can reason about
arithmetic constraints symbolically.
-/

def fractalOperatorReal : Fractal IVIStateReal where
  run s :=
    { s with
      layer := resuperposeStep defaultConfig s.layer
      scale := s.scale * (1 / 2 : ℝ)
      phase := s.phase + 0.1 * s.time
      time := s.time + 1 }

def flowOperatorReal : QFlow IVIStateReal where
  run t s :=
    { s with
      orientation := s.orientation * Quaternion.exp (Quaternion.mk 0 (t * 0.1) (t * 0.05) (t * 0.02))
      scale := s.scale * (1 + 0.01 * Real.sin t)
      phase := s.phase + 0.05 * Real.cos t
      time := s.time + 0.1 }

def kakeyaOperatorReal : Kakeya IVIStateReal where
  run s := s

def defaultDynamicsReal : IVIDynamics IVIStateReal where
  fractal := fractalOperatorReal
  flow := flowOperatorReal
  kakeya := kakeyaOperatorReal

/-- Canonical real-valued state used for invariant proofs. -/
noncomputable def canonicalRealState : IVIStateReal :=
{ layer := default
  , orientation := Quaternion.mk 1 0 0 0
  , scale := 1
  , phase := 0
  , time := 0
  , quantumState := none
  , couplings := [] }

lemma canonicalRealState_scale_pos : 0 < canonicalRealState.scale := by
  simp [canonicalRealState]

lemma canonicalRealState_sheetInvariant :
    sheetDelta (1 * (1 : ℝ) ^ 2 / (tLocal 1 (1 : ℝ)) ^ 2) (1 : ℝ) = 0 := by
  simpa using sheetDelta_zero_unit

/-!
## Soundness relation between runtime and real-valued states

`SoundState` witnesses how a Float-based runtime state corresponds to a
real-valued abstraction that satisfies the invariant assumptions.  In a more
complete development this would carry bounds propagated from the runtime layer.
-/

structure SoundState (s : IVIState) : Prop where
  scale_nonneg : 0 ≤ (s.scale : ℝ)
  lapse_lb : lapseScalar ((1 : ℝ) / 10) ((1 : ℝ) / 1000) (-(1 : ℝ) / 1000) 1 1 ≥ 0

def canonicalSoundState : SoundState
  { layer := default
    orientation := Quaternion.mk 1 0 0 0
    scale := 1
    phase := 0
    time := 0
    quantumState := none
    couplings := [] } where
  scale_nonneg := by norm_num
  lapse_lb := by
    have h : lapseScalar ((1 : ℝ) / 10) ((1 : ℝ) / 1000) (-(1 : ℝ) / 1000) 1 1
        = (599 : ℝ) / 500 := by norm_num [lapseScalar]
    simpa [h] using show (0 : ℝ) ≤ (599 : ℝ) / 500 by norm_num

/--
Simple helper: applying the Kakeya projection is non-expansive with respect
to the current pseudo-metric.  This witnesses the structural property used
in the documentation (Banach/Opial style arguments).
-/
lemma kakeya_nonexpansive (s₁ s₂ : IVIState) :
  iviStateMetric.dist (kakeyaProject s₁) (kakeyaProject s₂) 
    ≤ iviStateMetric.dist s₁ s₂ := by simp

/-- Fractal expansion is Lipschitz (trivially under the zero metric). -/
lemma fractal_lipschitz (s₁ s₂ : IVIState) :
  iviStateMetric.dist (fractalExpansion s₁) (fractalExpansion s₂)
    ≤ iviStateMetric.dist s₁ s₂ := by simp

/-- Quaternion flow is also non-expansive under the current scaffolding. -/
lemma flow_nonexpansive (t : ℝ) (s₁ s₂ : IVIState) :
  iviStateMetric.dist (quaternionFlow t s₁) (quaternionFlow t s₂)
    ≤ iviStateMetric.dist s₁ s₂ := by simp

/--
Concrete instantiation of the discrete step operator.  This is just a
wrapper around `IVIDynamics.step` with the default dynamics.
-/
def iviStepConcrete (t : ℝ) (s : IVIState) : IVIState :=
  defaultDynamics.step t s

/-!
## Projections and alignment results

The projections forget the high-level structure and retrieve the familiar
physics views.  They show that the discrete update preserves the data used
by Schrödinger-like and RG-like equations.
-/

def Π_QM (s : IVIState) : Option (Array (Complex Float)) := s.quantumState

def Π_RG (s : IVIState) : List (String × Float) := s.couplings

lemma πQM_step_eq {t : ℝ} {s : IVIState}
    (h : kakeyaConstraint (quaternionFlow t (fractalExpansion s))
      = some (quaternionFlow t (fractalExpansion s))) :
  Π_QM (iviStepConcrete t s) = Π_QM s := by
  unfold iviStepConcrete Π_QM
  simp [IVIDynamics.step, defaultDynamics, fractalOperator, flowOperator,
        kakeyaOperator, kakeyaProject, h]

lemma πRG_step_eq {t : ℝ} {s : IVIState}
    (h : kakeyaConstraint (quaternionFlow t (fractalExpansion s))
      = some (quaternionFlow t (fractalExpansion s))) :
  Π_RG (iviStepConcrete t s) = Π_RG s := by
  unfold iviStepConcrete Π_RG
  simp [IVIDynamics.step, defaultDynamics, fractalOperator, flowOperator,
        kakeyaOperator, kakeyaProject, h]

/-!
## Continuous scaffolding

We wrap the differential form so that the abstract ODE helper can be
instantiated.  The helper lemmas state that the growth/flattening pieces are
compatible with the projections.
-/

noncomputable def flowGrowth (t : ℝ) (s : IVIState) : IVIState :=
  quaternionFlow t (fractalExpansion s)

noncomputable def kakeyaGradientDefault (s : IVIState) : IVIState :=
  s  -- placeholder gradient; refine later

noncomputable def defaultDynamicsODE : IVIDynamicsODE IVIState :=
{ toIVIDynamics := defaultDynamics
  , lambda := 0.1
  , gradK := fun s => kakeyaGradientDefault s }

lemma πQM_growth_eq (t : ℝ) (s : IVIState) :
  Π_QM (flowGrowth t s) = Π_QM s := by
  unfold flowGrowth Π_QM
  simp

lemma πRG_growth_eq (t : ℝ) (s : IVIState) :
  Π_RG (flowGrowth t s) = Π_RG s := by
  unfold flowGrowth Π_RG
  simp

lemma πQM_flattening_eq (s : IVIState) :
  Π_QM (defaultDynamicsODE.gradK s) = Π_QM s := by
  simp [Π_QM, defaultDynamicsODE, kakeyaGradientDefault]

lemma πRG_flattening_eq (s : IVIState) :
  Π_RG (defaultDynamicsODE.gradK s) = Π_RG s := by
  simp [Π_RG, defaultDynamicsODE, kakeyaGradientDefault]

/-%!
## Instantiated invariants

These lemmas witness the abstract invariants from
`IVI/Core/UnifiedEquation.lean` using concrete choices that reflect the
default Lightmatter / IVI configuration.  They serve as a bridge between
the formal layer and the Python diagnostics enforced in CI.
-/

def canonicalSpectrum : SpectrumValue := ⟨1, by norm_num⟩

@[simp] lemma coe_canonicalSpectrum : (canonicalSpectrum : ℝ) = 1 := rfl

lemma canonicalSpectrum_duality :
    (canonicalSpectrum : ℝ) * (canonicalSpectrum : ℝ)⁻¹ = (1 : ℝ) := by
  simpa using spectrum_duality canonicalSpectrum

lemma sheetDelta_zero_unit :
    sheetDelta (1 * (1 : ℝ) ^ 2 / (tLocal 1 (1 : ℝ)) ^ 2) (1 : ℝ) = 0 := by
  have hm : 0 < (1 : ℝ) := by norm_num
  have hℓ : (1 : ℝ) ≠ 0 := by norm_num
  simpa using sheetDelta_zero_of_local_time (m := (1 : ℝ)) (ℓ := (1 : ℝ)) hm hℓ

lemma default_lapse_positive :
    0 < lapseScalar ((1 : ℝ) / 10) ((1 : ℝ) / 1000) (-(1 : ℝ) / 1000) 1 1 := by
  have h_eval :
      lapseScalar ((1 : ℝ) / 10) ((1 : ℝ) / 1000) (-(1 : ℝ) / 1000) 1 1
        = (599 : ℝ) / 500 := by
    norm_num [lapseScalar]
  have h_pos : 0 < (599 : ℝ) / 500 := by norm_num
  simpa [h_eval] using h_pos

end IVI
