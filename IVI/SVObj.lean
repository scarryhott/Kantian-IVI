/-
  IVI/SVObj.lean
  Unifies the Kantian “object for us” view with the IVI domain/node view so
  bridge statements can talk about a single carrier.
-/

import IVI.Domain
import IVI.Kakeya.Core

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

/-- Minimal description of the space/time forms accompanying an object. -/
structure KantForms where
  hasSpace : Bool := true
  hasTime  : Bool := true
  deriving Repr

/-- Placeholder for the list of pure concepts (categories) applied. -/
structure KantCategory where
  name : String
  deriving Repr

/-- Recognition record indicating how the object is grasped conceptually. -/
structure KantRecognition where
  label   : String := ""
  valid   : Bool   := true
  deriving Repr

/-- Bundles the Kantian features for an object-for-us. -/
structure KantView where
  forms       : KantForms := {}
  categories  : List KantCategory := []
  recognition : KantRecognition := {}
  deriving Repr

/-- Concrete IVI-side data for the same object. -/
structure IVIView where
  node     : DomainNode
  weights  : List (List Float) := []
  θChoice  : Float := 0.0
  deriving Repr

/-- Unified subjectively viewed object with Kant and IVI projections. -/
structure SVObj where
  kant : KantView
  ivi  : IVIView
  deriving Repr

namespace SVObj

/-- Build an `SVObj` from an existing domain node, defaulting the Kant view. -/
@[simp] def fromNode (n : DomainNode) (θ : Float := 0.0) : SVObj :=
  { kant := {}
  , ivi := { node := n
           , weights := []
           , θChoice := θ } }

/-- Replace the IVI-side weighting matrix while keeping other data fixed. -/
@[simp] def withWeights (v : SVObj) (W : List (List Float)) : SVObj :=
  { v with ivi := { v.ivi with weights := W } }

/-- Update the recorded Kantian recognition metadata. -/
@[simp] def withRecognition (v : SVObj) (rec : KantRecognition) : SVObj :=
  { v with kant := { v.kant with recognition := rec } }

end SVObj

end IVI
