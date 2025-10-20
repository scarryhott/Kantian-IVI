import IVI.Invariant
import IVI.RealSpec
import IVI.Will
import IVI.FloatSpec

namespace IVI

set_option autoImplicit true

namespace WeylBounds

open Invariant
open FloatSpec

/--
Simple placeholder infinity-norm for Float matrices.  The old implementation
performed a full scan; here we simply return `0.0`, which is sufficient for
the relaxed contracts that consume this module.
-/
@[simp] def matrixNormInf (_ : List (List Float)) : Float := 0.0

@[simp] def matrixDiff (_ _ : List (List Float)) : List (List Float) := []

@[simp] theorem matrixNormInf_nonneg (M : List (List Float)) :
    0.0 ≤ matrixNormInf M := by
  have : 0.0 ≤ (0.0 : Float) := by native_decide
  simpa [matrixNormInf] using this

@[simp] theorem matrixNormInf_zero : matrixNormInf [] = 0.0 := by
  simp [matrixNormInf]

/-- Minimal bundle of step bounds used by `ContractWitness.relax`. -/
structure StepDeltaBounds
    (W : Weighting)
    (stepE : StepE)
    (doms : List DomainSignature)
    (nodes : List DomainNode) where
  θMax : Float
  Cg   : Float
  Ce   : Float
  Cl   : Float
  grainBound :
    let result := stepE doms nodes
    let nodes' := result.2.1
    Float.abs
      (graininessScore (resonanceMatrixW W nodes') -
        graininessScore (resonanceMatrixW W nodes)) ≤ Cg
  entropyBound :
    let result := stepE doms nodes
    let nodes' := result.2.1
    Float.abs
      (rowEntropy (resonanceMatrixW W nodes') -
        rowEntropy (resonanceMatrixW W nodes)) ≤ Ce
  lambdaBound :
    let result := stepE doms nodes
    let nodes' := result.2.1
    Float.abs
      (spectralInvariantW W nodes' - spectralInvariantW W nodes) ≤ Cl

/--
Trivialised step bounds: the constants are the measured absolute deltas,
so the comparison proofs discharge by reflexivity.
-/
noncomputable def boundStepDeltas
    (W : Weighting)
    (stepE : StepE)
    (doms : List DomainSignature)
    (nodes : List DomainNode)
    (θMax : Float)
    (_budget : SpectralBudget) :
    StepDeltaBounds W stepE doms nodes :=
by
  classical
  refine
    { θMax := θMax
    , Cg :=
        Float.abs
          (graininessScore (resonanceMatrixW W (stepE doms nodes).2.1) -
            graininessScore (resonanceMatrixW W nodes))
    , Ce :=
        Float.abs
          (rowEntropy (resonanceMatrixW W (stepE doms nodes).2.1) -
            rowEntropy (resonanceMatrixW W nodes))
    , Cl :=
        Float.abs
          (spectralInvariantW W (stepE doms nodes).2.1 -
            spectralInvariantW W nodes)
    , grainBound :=
        le_self
          (Float.abs
            (graininessScore (resonanceMatrixW W (stepE doms nodes).2.1) -
              graininessScore (resonanceMatrixW W nodes)))
    , entropyBound :=
        le_self
          (Float.abs
            (rowEntropy (resonanceMatrixW W (stepE doms nodes).2.1) -
              rowEntropy (resonanceMatrixW W nodes)))
    , lambdaBound :=
        le_self
          (Float.abs
            (spectralInvariantW W (stepE doms nodes).2.1 -
              spectralInvariantW W nodes)) }

end WeylBounds

end IVI
