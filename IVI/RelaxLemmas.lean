/-
  IVI/RelaxLemmas.lean
  Helper lemmas connecting Kakeya witnesses to the relaxed inequality layer.
-/

import IVI.Relax

namespace IVI

lemma abs_le_scaled (x θ : Float) (hθ : (1.0 : Float) ≤ θ) :
    Float.abs x ≤ Float.abs x * θ := by
  have hx : 0.0 ≤ Float.abs x := Float.abs_nonneg _
  have := Float.mul_le_mul_of_nonneg_left hθ hx
  simpa [hx, mul_comm] using this

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
  let result := stepE doms nodes
  let nodes' := result.2.1
  let collapseCfg : ICollapseCfg := {}
  let W := collapseCfg.W
  let weightsPrev := resonanceMatrixW W nodes
  let weightsNext := resonanceMatrixW W nodes'
  let symPrev := symmetriseLL weightsPrev
  let symNext := symmetriseLL weightsNext
  let grainPrev := graininessScore weightsPrev
  let grainNext := graininessScore weightsNext
  let entropyPrev := rowEntropy symPrev
  let entropyNext := rowEntropy symNext
  let lamPrev := spectralInvariantW W nodes
  let lamNext := spectralInvariantW W nodes'
  let θMeasured := KakeyaBounds.thetaSpan (nodes.zip nodes')
  let θCap := ctx.bounds.θCap
  let θBound := if θCap ≤ θMeasured then θMeasured else θCap
  let θMaxContract := Float.max θBound 1.0
  let deltaPack :
      KakeyaBounds.DeltaPack :=
    { grainDiff := grainNext - grainPrev
    , entropyDiff := entropyNext - entropyPrev
    , lambdaDiff := lamNext - lamPrev
    , θMeasured := θMeasured
    , θMax := θMaxContract }
  let contract :
      KakeyaContract :=
    { Cg := KakeyaBounds.DeltaPack.Δgrain deltaPack
    , Ce := KakeyaBounds.DeltaPack.Δentropy deltaPack
    , Cl := KakeyaBounds.DeltaPack.Δlambda deltaPack
    , θMax := θMaxContract
    , grain_ok := Float.abs (grainNext - grainPrev) ≤ KakeyaBounds.DeltaPack.Δgrain deltaPack
    , entropy_ok := Float.abs (entropyNext - entropyPrev) ≤ KakeyaBounds.DeltaPack.Δentropy deltaPack
    , lam_ok := Float.abs (lamNext - lamPrev) ≤ KakeyaBounds.DeltaPack.Δlambda deltaPack }
  have hθ : (1.0 : Float) ≤ θMaxContract := by
    have := (le_max_right θBound (1.0 : Float))
    simpa [θMaxContract] using this
  have hgr :
      Float.abs (grainNext - grainPrev) ≤ Float.abs (grainNext - grainPrev) * θMaxContract :=
    abs_le_scaled _ _ hθ
  have hen :
      Float.abs (entropyNext - entropyPrev) ≤ Float.abs (entropyNext - entropyPrev) * θMaxContract :=
    abs_le_scaled _ _ hθ
  have hlam :
      Float.abs (lamNext - lamPrev) ≤ Float.abs (lamNext - lamPrev) * θMaxContract :=
    abs_le_scaled _ _ hθ
  have h_relaxed :
      relaxedHolds contract deltaPack := by
    dsimp [relaxedHolds, grain_ok_LE, entropy_ok_LE,
      lambda_ok_LE, contract, deltaPack, KakeyaBounds.DeltaPack.Δgrain,
      KakeyaBounds.DeltaPack.Δentropy, KakeyaBounds.DeltaPack.Δlambda] at hgr hen hlam ⊢
    refine And.intro ?_ ?_
    · simpa [θMaxContract]
    · refine And.intro ?_ ?_
      · simpa [θMaxContract]
      · simpa [θMaxContract]
  have h_pack :
      (KakeyaBounds.buildContract stepE doms nodes ctx will).deltas = deltaPack := by
    simp [KakeyaBounds.buildContract, deltaPack, θMaxContract, θBound, θCap, θMeasured,
      lamPrev, lamNext, entropyPrev, entropyNext, grainPrev, grainNext,
      symPrev, symNext, weightsPrev, weightsNext, W, collapseCfg, result]
  have h_contract :
      (KakeyaBounds.buildContract stepE doms nodes ctx will).contract = contract := by
    simp [KakeyaBounds.buildContract, contract, deltaPack, θMaxContract, θBound, θCap,
      θMeasured, lamPrev, lamNext, entropyPrev, entropyNext, grainPrev, grainNext,
      symPrev, symNext, weightsPrev, weightsNext, W, collapseCfg, result, h_pack]
  simpa [h_pack, h_contract] using h_relaxed

end IVI
