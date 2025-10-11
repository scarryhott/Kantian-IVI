import Lake
open Lake DSL

package «ivi» where
  -- add any configuration here

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git"

@[default_target]
lean_lib IVI where
  -- add any library configuration here

lean_exe «ivi-demo» where
  root := `IVI.Demo
