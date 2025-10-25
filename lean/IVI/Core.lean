namespace IVI

structure IState where
  i   : Float          -- noumenal coord
  t   : Float          -- phenomenal time (emergent)
  m   : Float          -- mass/moment parameter
  ell : Float          -- local length scale
deriving Repr

structure Fields where
  Phi   : Float      -- potential (weak-field)
  kappa : Float      -- grain density (dimensionless)
  temp  : Float      -- temperature (K or normalized)
deriving Repr

structure Couplings where
  epsGrain : Float
  epsFlat  : Float
  kappa0   : Float
  E0       : Float
  p        : Float
  q        : Float
deriving Repr

def Fκ (c : Couplings) (κ : Float) : Float :=
  let r := κ / c.kappa0
  if r <= 0 then 0 else r ** c.p

def GT (c : Couplings) (T : Float) : Float :=
  let r := T / c.E0
  if r <= 0 then 0 else r ** c.q

/-- Weak-field g00 lapse deformation. -/
def g00 (fld : Fields) (c : Couplings) : Float :=
  let base := 1.0 + 2.0 * fld.Phi
  let grain := c.epsGrain * Fκ c fld.kappa
  let flat  := c.epsFlat  * GT c fld.temp
  - (base - grain + flat)

end IVI
