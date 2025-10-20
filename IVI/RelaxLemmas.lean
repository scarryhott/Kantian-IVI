/-
  IVI/RelaxLemmas.lean
  Helper lemmas connecting Kakeya witnesses to the relaxed inequality layer.
-/

import IVI.Relax

namespace IVI

open KakeyaBounds

lemma buildContract_relaxed
    (stepE : StepE)
    (doms : List DomainSignature)
    (nodes : List DomainNode)
    (ctx : WillCtx := {})
    (will : Will := Will.idle) :
    relaxedHolds
      (KakeyaBounds.buildContract stepE doms nodes ctx will).contract
      (KakeyaBounds.buildContract stepE doms nodes ctx will).deltas := by
  classical
  set w := KakeyaBounds.buildContract stepE doms nodes ctx will with hw
  change relaxedHolds w.contract w.deltas
  have hGrain : Float.abs w.deltas.grainDiff ≤ w.contract.Cg := by
    simpa [hw, KakeyaBounds.buildContract, DeltaPack.Δgrain]
      using w.grainWitness
  have hEntropy : Float.abs w.deltas.entropyDiff ≤ w.contract.Ce := by
    simpa [hw, KakeyaBounds.buildContract, DeltaPack.Δentropy]
      using w.entropyWitness
  have hLambda : Float.abs w.deltas.lambdaDiff ≤ w.contract.Cl := by
    simpa [hw, KakeyaBounds.buildContract, DeltaPack.Δlambda]
      using w.lamWitness
  have hθ : w.contract.θMax = 1.0 := by
    simp [hw, KakeyaBounds.buildContract]
  have hCg : w.contract.Cg = Float.abs w.deltas.grainDiff := by
    simp [hw, KakeyaBounds.buildContract, DeltaPack.Δgrain]
  have hCe : w.contract.Ce = Float.abs w.deltas.entropyDiff := by
    simp [hw, KakeyaBounds.buildContract, DeltaPack.Δentropy]
  have hCl : w.contract.Cl = Float.abs w.deltas.lambdaDiff := by
    simp [hw, KakeyaBounds.buildContract, DeltaPack.Δlambda]
  have hGrain0 : Float.abs w.deltas.grainDiff ≤ Float.abs w.deltas.grainDiff :=
    IVI.le_self _
  have hEntropy0 : Float.abs w.deltas.entropyDiff ≤ Float.abs w.deltas.entropyDiff :=
    IVI.le_self _
  have hLambda0 : Float.abs w.deltas.lambdaDiff ≤ Float.abs w.deltas.lambdaDiff :=
    IVI.le_self _
  dsimp [relaxedHolds, grain_ok_LE, entropy_ok_LE, lambda_ok_LE]
  refine And.intro ?_ ?_
  · simpa [hCg, hθ, hw, KakeyaBounds.buildContract]
      using hGrain0
  · refine And.intro ?_ ?_
    · simpa [hCe, hθ, hw, KakeyaBounds.buildContract]
        using hEntropy0
    · simpa [hCl, hθ, hw, KakeyaBounds.buildContract]
        using hLambda0

end IVI
