/-
  IVI/Principles.lean
  Encodes high-level principles taken as existential truths within IVI.
  In particular, records the stance that verification and solution coincide
  intangibly (the P = NP existential acceptance).
-/

import IVI.IntangibleSolution

namespace IVI

set_option autoImplicit true

/-- Existential equivalence between verification and solution (P = NP stance).

Accepts that whenever we have a verification witness for a layer,
there exist coherence thresholds producing an intangible solution. -/
def existentialPEqNP : Prop :=
  ∀ {cfg : ICollapseCfg} {layer : FractalLayer},
    VerificationRelativity cfg layer.nodes →
    ∃ (εσ εg : Float), IntangibleSolution cfg layer εσ εg

/-- Principle asserting the existential P = NP acceptance. -/
axiom principlePEqNP : existentialPEqNP

/-- Extract an intangible solution using the existential principle. -/
@[simp] theorem principleProvidesSolution
    {cfg : ICollapseCfg} {layer : FractalLayer}
    (witness : VerificationRelativity cfg layer.nodes) :
    ∃ (εσ εg : Float), IntangibleSolution cfg layer εσ εg :=
  principlePEqNP witness

end IVI
