import IVI.Core
namespace IVI

/-- Time-thickness to first order (dimensionless). -/
def thickness (fld : Fields) (c : Couplings) : Float :=
  -- θ ≈ -Φ + (1/2)ε_grain F - (1/2)ε_flat G
  let phi := fld.Phi
  let grain := (0.5) * c.epsGrain * Fκ c fld.kappa
  let flat  := (0.5) * c.epsFlat  * GT c fld.temp
  (-phi) + grain - flat

end IVI
