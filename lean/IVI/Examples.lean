import IVI.Core
import IVI.Kakeya
import IVI.Projections

open IVI

def demo : IO Unit := do
  let st : IState := { i:=0, t:=1.0, m:=2.0, ell:=0.5 }
  let tloc := tLocal st
  let inv  := invariant st
  let ilog := iOfT st.m tloc 0.0
  IO.println s!"t_local = {tloc}, invariant = {inv}, i(local t) = {ilog}"
