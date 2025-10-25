namespace IVI

/-- Global noumenal time map: i(t) = (2/3) m^{3/2} ln |t| + C. -/
def iOfT (m t C : Float) : Float :=
  (2.0/3.0) * (m ** 1.5) * (Float.log (abs t)) + C

end IVI
