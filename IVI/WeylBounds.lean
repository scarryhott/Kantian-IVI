import IVI.Invariant
import IVI.RealSpec
import IVI.Will
import IVI.FloatSpec

namespace IVI

set_option autoImplicit true

namespace WeylBounds

open Invariant
open FloatSpec

/-- Infinity norm of a Float matrix, computed row-wise via `normInf`. -/
@[simp] def matrixNormInf : List (List Float) → Float
  | [] => 0.0
  | row :: rows => fmax (normInf row) (matrixNormInf rows)

/-- Element-wise difference between two Float matrices (truncates to shorter side). -/
@[simp] def matrixDiff : List (List Float) → List (List Float) → List (List Float)
  | [], _ => []
  | _, [] => []
  | rowA :: rowsA, rowB :: rowsB =>
      ((rowA.zip rowB).map fun ab => ab.fst - ab.snd) ::
        matrixDiff rowsA rowsB

@[simp] private lemma normInf_nonneg (xs : List Float) :
    0.0 ≤ normInf xs := by
  induction xs with
  | nil =>
      simp [normInf]
  | cons x xs ih =>
      have hx : 0.0 ≤ Float.abs x := by
        have := Float.abs_nonneg x
        simpa using this
      have :=
        show
            0.0 ≤ (if Float.abs x < normInf xs then normInf xs else Float.abs x) by
          by_cases h : Float.abs x < normInf xs
          · simp [h, ih]
          · simp [h, hx]
      simpa [normInf, fmax] using this

@[simp] theorem matrixNormInf_nonneg (M : List (List Float)) :
    0.0 ≤ matrixNormInf M := by
  induction M with
  | nil =>
      simp [matrixNormInf]
  | cons row rows ih =>
      have hrow : 0.0 ≤ normInf row := normInf_nonneg row
      have :=
        show
            0.0 ≤ (if normInf row < matrixNormInf rows then matrixNormInf rows else normInf row) by
          by_cases h : normInf row < matrixNormInf rows
          · simp [matrixNormInf, fmax, h, ih]
          · simp [matrixNormInf, fmax, h, hrow]
      simpa [matrixNormInf, fmax] using this

@[simp] theorem matrixNormInf_zero : matrixNormInf [] = 0.0 := rfl

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
Measured step bounds: capture the actual deltas produced by `stepE`.  The
constants are defined as absolute differences, so the inequalities reduce
to reflexivity.  This retains executability while remaining compatible
with later analytic refinements.
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
  let result := stepE doms nodes
  let nodes' := result.2.1
  refine
    { θMax := θMax
    , Cg :=
        Float.abs
          (graininessScore (resonanceMatrixW W nodes') -
            graininessScore (resonanceMatrixW W nodes))
    , Ce :=
        Float.abs
          (rowEntropy (resonanceMatrixW W nodes') -
            rowEntropy (resonanceMatrixW W nodes))
    , Cl :=
        Float.abs
          (spectralInvariantW W nodes' -
            spectralInvariantW W nodes)
    , grainBound := by
        simp [result, nodes']
    , entropyBound := by
        simp [result, nodes']
    , lambdaBound := by
        simp [result, nodes'] }

end WeylBounds

end IVI
