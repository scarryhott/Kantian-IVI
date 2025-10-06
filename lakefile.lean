import Lake
open Lake DSL

package «ivi» where
  -- add any configuration here

@[default_target]
lean_lib IVI where
  -- add any library configuration here

lean_exe «ivi-demo» where
  root := `IVI.Demo
