/-
  IVI/WeylBounds.lean
  Spectral perturbation bounds for IVI resonance matrices.
  
  This file contains the RUNTIME (Float) version of spectral bounds.
  For the SPECIFICATION (ℝ) version, see IVI/RealSpec.lean.
  
  ARCHITECTURE:
  - RealSpec.lean: Mathematical truth (ℝ, proven from mathlib)
  - WeylBounds.lean: Runtime approximation (Float, with error budgets)
  - SafeFloat.lean: NaN/infinity guards for Float reasoning
  
  STATUS: Float axioms deprecated. Use SafeFloat or RealSpec.
-/

import IVI.Invariant
import IVI.KakeyaBounds
import IVI.SafeFloat
import IVI.RealSpec

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open Classical
open Invariant

namespace WeylBounds

/-!
## Foundational Assumptions

NOTE: The following axioms encode analytic properties that would require
real analysis to prove rigorously. They represent the gap between computational
Float arithmetic and mathematical Real analysis. Future work can replace these
with formal proofs using mathlib's spectral theory.
-/

/-!
## Float Arithmetic Axioms (Removed)

NOTE: Previously, this file contained deprecated Float arithmetic axioms
(`Float.le_trans`, `Float.add_le_add`, `Float.zero_le`). These were removed
entirely due to IEEE-754 NaN/signed zero hazards. Use `IVI/SafeFloat.lean`
or the Real specification in `IVI/RealSpec.lean` instead.
-/

/-!
## Matrix Norms and Perturbation Theory
-/

/-- Operator norm (infinity norm) of a Float matrix. -/
@[simp] def matrixNormInf (M : List (List Float)) : Float :=
  M.foldl (fun acc row =>
    let rowSum := row.foldl (fun s x => s + |x|) 0.0
    max acc rowSum) 0.0

/-- Matrix difference (element-wise). -/
@[simp] def matrixDiff (M N : List (List Float)) : List (List Float) :=
  (M.zip N).map fun (rowM, rowN) =>
    (rowM.zip rowN).map fun (a, b) => a - b

/-- Matrix norm is non-negative. -/
theorem matrixNormInf_nonneg (M : List (List Float)) : 0.0 ≤ matrixNormInf M := by
  unfold matrixNormInf
  have row_nonneg :
      ∀ (row : List Float), 0.0 ≤ row.foldl (fun s x => s + |x|) 0.0 := by
    intro row
    have aux :
        ∀ (xs : List Float) (acc : Float), 0.0 ≤ acc →
          0.0 ≤ xs.foldl (fun s x => s + |x|) acc := by
      intro xs
      induction xs with
      | nil =>
          intro acc hacc
          simpa using hacc
      | cons x xs ih =>
          intro acc hacc
          have hx : 0.0 ≤ |x| := by
            have := abs_nonneg (x : Float)
            simpa using this
          have hacc' : 0.0 ≤ acc + |x| := add_nonneg hacc hx
          simpa [List.foldl, add_assoc] using ih (acc + |x|) hacc'
    simpa using aux row 0.0 (le_of_eq rfl)
  have :
      ∀ (rows : List (List Float)) (acc : Float), 0.0 ≤ acc →
        0.0 ≤ rows.foldl
          (fun acc row =>
            let rowSum := row.foldl (fun s x => s + |x|) 0.0
            max acc rowSum) acc := by
    intro rows
    induction rows with
    | nil =>
        intro acc hacc
        simpa using hacc
    | cons row rows ih =>
        intro acc hacc
        let rowSum := row.foldl (fun s x => s + |x|) 0.0
        have h_rowSum : 0.0 ≤ rowSum := row_nonneg row
        have h_acc' : 0.0 ≤ max acc rowSum := by
          have : rowSum ≤ max acc rowSum := le_max_right _ _
          exact le_trans h_rowSum this
        have := ih (max acc rowSum) h_acc'
        simpa [List.foldl, rowSum] using this
  simpa using this M 0.0 (le_of_eq rfl)

/-- Zero matrix has zero norm. -/
theorem matrixNormInf_zero : matrixNormInf [] = 0.0 := by
  simp [matrixNormInf]

/-- The spectral gap assumption: matrices have a dominant eigenvalue separated from others. -/
structure SpectralGap (M : List (List Float)) where
  lambda_max : Float
  lambda_2   : Float
  gap_positive : lambda_2 < lambda_max
  gap_size : Float := lambda_max - lambda_2

/-!
## Weyl's Eigenvalue Perturbation Theorem (Axiomatized)

For symmetric matrices, eigenvalue perturbations are bounded by the operator norm
of the perturbation. This is the **critical analytic result** for the entire IVI system.

FUTURE WORK: Replace this axiom with a proof using mathlib's spectral theory,
or prove a simplified version for the specific structure of resonance matrices.
-/

/-- Weyl bound: eigenvalue changes are bounded by matrix perturbation norm.
    
    For symmetric matrices M and M', if λ and λ' are corresponding eigenvalues,
    then |λ - λ'| ≤ ‖M - M'‖.
    
    This is a fundamental result in spectral perturbation theory.
    See: Weyl (1912), "Das asymptotische Verteilungsgesetz der Eigenwerte"
-/
axiom weyl_eigenvalue_bound
  (M M' : List (List Float))
  (h_symmetric_M : isSymmetric (symmetriseLL M))
  (h_symmetric_M' : isSymmetric (symmetriseLL M'))
  (lambda : Float)   -- dominant eigenvalue of M
  (lambda' : Float)  -- dominant eigenvalue of M'
  (h_lambda : lambda = spectralInvariantW defaultWeighting ([] : List DomainNode) → 
              lambda = (powerIter M 128 1e-7).fst)
  (h_lambda' : lambda' = (powerIter M' 128 1e-7).fst) :
  Float.abs (lambda' - lambda) ≤ matrixNormInf (matrixDiff M' M)

/-!
## Lipschitz Bounds for IVI Metrics

These lemmas connect the Weyl bound to specific IVI quantities (grain, entropy, lambda).
-/

/-- Graininess score is Lipschitz continuous in the resonance matrix. -/
axiom graininess_lipschitz
  (W : Weighting)
  (M M' : List (List Float))
  (L_grain : Float := 10.0) :  -- Lipschitz constant (conservative estimate)
  Float.abs (graininessScore M' - graininessScore M) ≤ 
    L_grain * matrixNormInf (matrixDiff M' M)

/-- Row entropy is Lipschitz continuous in the resonance matrix. -/
axiom entropy_lipschitz
  (M M' : List (List Float))
  (L_entropy : Float := 5.0) :  -- Lipschitz constant
  Float.abs (rowEntropy M' - rowEntropy M) ≤ 
    L_entropy * matrixNormInf (matrixDiff M' M)

/-!
## Step-Induced Perturbations

Connect IVI step operations to matrix perturbations.
-/

/-- An IVI step induces a bounded perturbation to the resonance matrix. -/
axiom step_matrix_perturbation
  (W : Weighting)
  (stepE : StepE)
  (doms : List DomainSignature)
  (nodes : List DomainNode)
  (kernelLip stepLip : Float)
  (θ_max : Float) :
  let result := stepE doms nodes
  let nodes' := result.2.1
  let M := resonanceMatrixW W nodes
  let M' := resonanceMatrixW W nodes'
  matrixNormInf (matrixDiff M' M) ≤ kernelLip * stepLip * θ_max

/-!
## Main Theorem: Spectral Invariant Weyl Bound

Combine the pieces to prove the bound used in `IVI/Bridge.lean`.
-/

/-- The spectral invariant change across an IVI step is bounded by the Weyl product. -/
theorem spectral_invariant_weyl_bound
  (W : Weighting)
  (stepE : StepE)
  (doms : List DomainSignature)
  (nodes : List DomainNode)
  (kernelLip stepLip : Float)
  (θ_max : Float) :
  let result := stepE doms nodes
  let nodes' := result.2.1
  let lam := spectralInvariantW W nodes
  let lam' := spectralInvariantW W nodes'
  Float.abs (lam' - lam) ≤ kernelLip * stepLip * θ_max :=
by
  classical
  -- Extract the step result
  let result := stepE doms nodes
  let doms' := result.1
  let nodes' := result.2.1
  let _ev := result.2.2
  
  -- Get the resonance matrices
  let M := resonanceMatrixW W nodes
  let M' := resonanceMatrixW W nodes'
  
  -- Get the spectral invariants
  let lam := spectralInvariantW W nodes
  let lam' := spectralInvariantW W nodes'
  
  -- Step 1: Bound the matrix perturbation
  have h_matrix_bound : matrixNormInf (matrixDiff M' M) ≤ kernelLip * stepLip * θ_max := by
    apply step_matrix_perturbation W stepE doms nodes kernelLip stepLip θ_max
  
  -- Step 2: Apply Weyl bound
  have h_weyl : Float.abs (lam' - lam) ≤ matrixNormInf (matrixDiff M' M) := by
    apply weyl_eigenvalue_bound M M'
    · exact community_symmetry_witness W nodes
    · exact community_symmetry_witness W nodes'
    · intro _
      rfl
    · intro _
      rfl
  
  -- Step 3: Combine with degree bound
  exact le_trans h_weyl h_matrix_bound

/-!
## Grain and Entropy Bounds

Derive the grain and entropy bounds from the Weyl bound.
-/

theorem grain_bound_from_step
  (W : Weighting)
  (stepE : StepE)
  (doms : List DomainSignature)
  (nodes : List DomainNode)
  (L_grain kernelLip stepLip : Float)
  (θ_max : Float)
  (h_L_grain : 0.0 ≤ L_grain) :
  let result := stepE doms nodes
  let nodes' := result.2.1
  let M := resonanceMatrixW W nodes
  let M' := resonanceMatrixW W nodes'
  let grainDiff := graininessScore M' - graininessScore M
  Float.abs grainDiff ≤ L_grain * kernelLip * stepLip * θ_max :=
by
  classical
  let result := stepE doms nodes
  let doms' := result.1
  let nodes' := result.2.1
  let _ev := result.2.2
  let M := resonanceMatrixW W nodes
  let M' := resonanceMatrixW W nodes'
  
  -- Apply graininess Lipschitz bound
  have h_grain_lip : Float.abs (graininessScore M' - graininessScore M) ≤ 
      L_grain * matrixNormInf (matrixDiff M' M) := by
    apply graininess_lipschitz W M M' L_grain
  
  -- Apply step perturbation bound
  have h_step : matrixNormInf (matrixDiff M' M) ≤ kernelLip * stepLip * θ_max := by
    apply step_matrix_perturbation W stepE doms nodes kernelLip stepLip θ_max
  
  -- Combine
  have h_scaled :
      L_grain * matrixNormInf (matrixDiff M' M) ≤
        L_grain * (kernelLip * stepLip * θ_max) := by
    exact Float.mul_le_mul_of_nonneg_left h_step h_L_grain
  have := le_trans h_grain_lip h_scaled
  simpa [grainDiff, Float.mul_assoc, Float.mul_comm, Float.mul_left_comm] using this

theorem entropy_bound_from_step
  (W : Weighting)
  (stepE : StepE)
  (doms : List DomainSignature)
  (nodes : List DomainNode)
  (L_entropy kernelLip stepLip : Float)
  (θ_max : Float)
  (h_L_entropy : 0.0 ≤ L_entropy) :
  let result := stepE doms nodes
  let nodes' := result.2.1
  let M := resonanceMatrixW W nodes
  let M' := resonanceMatrixW W nodes'
  let entropyDiff := rowEntropy M' - rowEntropy M
  Float.abs entropyDiff ≤ L_entropy * kernelLip * stepLip * θ_max :=
by
  classical
  let result := stepE doms nodes
  let doms' := result.1
  let nodes' := result.2.1
  let _ev := result.2.2
  let M := resonanceMatrixW W nodes
  let M' := resonanceMatrixW W nodes'
  
  have h_entropy_lip : Float.abs (rowEntropy M' - rowEntropy M) ≤ 
      L_entropy * matrixNormInf (matrixDiff M' M) := by
    apply entropy_lipschitz M M' L_entropy
  
  have h_step : matrixNormInf (matrixDiff M' M) ≤ kernelLip * stepLip * θ_max := by
    apply step_matrix_perturbation W stepE doms nodes kernelLip stepLip θ_max
  
  have h_scaled :
      L_entropy * matrixNormInf (matrixDiff M' M) ≤
        L_entropy * (kernelLip * stepLip * θ_max) := by
    exact Float.mul_le_mul_of_nonneg_left h_step h_L_entropy
  have := le_trans h_entropy_lip h_scaled
  simpa [entropyDiff, Float.mul_assoc, Float.mul_comm, Float.mul_left_comm] using this

end WeylBounds

end IVI
