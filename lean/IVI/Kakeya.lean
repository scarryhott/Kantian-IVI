namespace IVI

/-- Kakeya saturation: j * ell^2 = 1 with j = m ell^2 / t^2. -/
def kakeyaSaturated (st : IState) : Bool :=
  let j := st.m * (st.ell*st.ell) / (st.t*st.t)
  let lhs := j * (st.ell*st.ell)
  abs (lhs - 1.0) < 1e-9

/-- Solve for local t on saturation: t = sqrt(m) * ell^2. -/
def tLocal (st : IState) : Float :=
  Float.sqrt st.m * (st.ell*st.ell)

/-- Invariant at saturation: j dt^2 = m ell^2 (time cancels). -/
def invariant (st : IState) : Float :=
  st.m * (st.ell*st.ell)

end IVI
