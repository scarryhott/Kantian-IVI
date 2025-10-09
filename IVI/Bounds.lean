/-
  IVI/Bounds.lean
  Minimal configurable bounds wrapper used by Kakeya builders.
-/

namespace IVI

/-- Conservative fallback constants for contract construction. -/
structure Bounds where
  Cg   : Float := 1e-3
  Ce   : Float := 1e-3
  Cl   : Float := 1e-3
  θCap : Float := 1.0
  deriving Repr, Inhabited

@[simp] def defaultBounds : Bounds := {}

end IVI
