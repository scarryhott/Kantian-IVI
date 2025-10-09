/-
  IVI/KakeyaAssemble.lean
  Helper lemmas wrapping the contract witness into `preservesKakeya`
  and exposing a relaxation-friendly variant.
-/

import IVI.KakeyaBounds
import IVI.Relax

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

open KakeyaBounds

/-- Restatement of the witness-to-preservation bridge. -/
@[simp] def preserves_of_witness
    {stepE : StepE} {doms : List DomainSignature} {nodes : List DomainNode}
    (w : KakeyaBounds.ContractWitness stepE doms nodes) :
    preservesKakeya w.K stepE doms nodes :=
  KakeyaBounds.assemble_preservation_from_components (w := w)

/-- Relax a witness using external bounds before assembling the preservation fact. -/
@[simp] def preserves_of_relaxed
    {stepE : StepE} {doms : List DomainSignature} {nodes : List DomainNode}
    (w : KakeyaBounds.ContractWitness stepE doms nodes)
    (Cg Ce Cl θMax : Float)
    (hCg : w.deltas.Δgrain ≤ Cg)
    (hCe : w.deltas.Δentropy ≤ Ce)
    (hCl : w.deltas.Δlambda ≤ Cl) :
    preservesKakeya w.K stepE doms nodes :=
by
  have relaxed := KakeyaBounds.ContractWitness.relax
    (w := w) Cg Ce Cl θMax hCg hCe hCl
  simpa using preserves_of_witness (w := relaxed)

end IVI
