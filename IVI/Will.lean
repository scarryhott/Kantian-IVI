/-
  IVI/Will.lean
  Abstracts the Kantian "will" as an operator over subjectively viewed
  objects.  The interface keeps the schema/θ choice explicit so proofs can
  require guards (reciprocity, non-collapse, etc.).
-/

import IVI.SVObj
import IVI.Bounds
import IVI.SchemaLaw

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

/-- Lipschitz data used to bound the spectral perturbation. -/
structure SpectralBudget where
  kernelLip : Float := 0.0
  stepLip   : Float := 0.0
  degBound  : Float := 0.0
  deriving Repr, Inhabited

@[simp] def SpectralBudget.eps (B : SpectralBudget) (θMax : Float) : Float :=
  B.kernelLip * B.stepLip * θMax * B.degBound

/--
Environment data the will may consult when making choices.  Currently this is
just the Kakeya bounds, but more analytic witnesses can be added later.
-/
structure WillCtx where
  bounds : Bounds := defaultBounds
  law    : SchemaLaw := SchemaLaw.default
  spectral : SpectralBudget := {}

/--
Abstract will operator.  Supplies:
* `selectSchema` – which pure concept/schema is applied to this object;
* `chooseTheta` – the directional stance chosen for the next step;
* `apply` – the updated subjectively-viewed object after the will acts;
* `respectsGuard` – proof obligation that the update honours a guard.
-/
structure Will where
  selectSchema  : WillCtx → SVObj → SchemaId
  chooseTheta   : WillCtx → SVObj → Float
  apply         : WillCtx → SVObj → SVObj
  respectsGuard : WillCtx → SVObj → Prop

namespace Will

/-- Default will that leaves the object unchanged and records a dummy schema. -/
@[simp] def idle : Will :=
  { selectSchema := fun _ _ => "idle"
  , chooseTheta := fun _ obj => obj.ivi.θChoice
  , apply := fun _ obj => obj
  , respectsGuard := fun _ _ => True }

/-- Witness that the idle will always satisfies its guard. -/
@[simp] theorem idle_respects (ctx : WillCtx) (obj : SVObj) :
    Will.idle.respectsGuard ctx obj := trivial

end Will

end IVI
