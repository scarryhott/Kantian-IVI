/-
  IVI/SchemaLaw.lean
  Captures the link between pure concepts (schemas) and the directional
  choices used in the Kakeya/IVI step.
-/

import IVI.Kakeya.Core
import IVI.SVObj

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

/-- Designates a schema/pure concept index. -/
abbrev SchemaId := String

/-- Inputs the schematism law may use when choosing θ. -/
structure SchemaContext where
  schema   : SchemaId
  concept  : String := ""
  direction : Dir3
  intensity : Float := 1.0
  deriving Repr

/-- Abstract schematism law returning the θ to be used in Δi updates. -/
structure SchemaLaw where
  chooseTheta : SchemaContext → Float
  monotone    : Prop := True

namespace SchemaLaw

/-- Default law that yields the magnitude of the direction vector. -/
@[simp] def default : SchemaLaw :=
  { chooseTheta := fun ctx => dirNorm ctx.direction
  , monotone := True }

end SchemaLaw

end IVI
