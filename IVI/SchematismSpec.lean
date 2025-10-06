/-
  IVI/SchematismSpec.lean
  ℝ-based (proof-side) specs for θ and Δi.
-/

namespace IVI

set_option autoImplicit true
set_option maxHeartbeats 400000

/-- Real 3D vector (spec). -/
structure rVec3 where
  x y z : Real

@[simp] def rnorm3 (v : rVec3) : Real :=
  Real.sqrt (v.x ^ 2 + v.y ^ 2 + v.z ^ 2)

/-- Unit direction; if `‖r‖ = 0` we return `(0,0,0)` so θ stays defined. -/
@[simp] def rdir (v : rVec3) : rVec3 :=
  let n := rnorm3 v
  if h : n = 0 then ⟨0, 0, 0⟩ else ⟨v.x / n, v.y / n, v.z / n⟩

@[simp] def rdot (a b : rVec3) : Real :=
  a.x * b.x + a.y * b.y + a.z * b.z

@[simp] def clampUnit (c : Real) : Real := min 1 (max (-1) c)

@[simp] def rtheta (r̂ uAxis : rVec3) : Real :=
  Real.arccos (clampUnit (rdot r̂ uAxis))

@[simp] def rDeltaI (k : Real) (r : rVec3) (uAxis : rVec3) : Real :=
  k * rnorm3 r * rtheta (rdir r) uAxis

lemma clampUnit_range (c : Real) : -1 ≤ clampUnit c ∧ clampUnit c ≤ 1 := by
  unfold clampUnit
  have h₁ : -1 ≤ max (-1) c := by exact le_max_left _ _
  have h₂ : max (-1) c ≤ 1 := by exact max_le (by linarith) (by linarith)
  refine ⟨?_, ?_⟩
  · exact le_trans (by simp [min_le_iff]) h₁
  · exact le_trans h₂ (by simp [le_of_lt])

/-- θ is in [0, π]. -/
lemma rtheta_range (r̂ uAxis : rVec3) :
  0 ≤ rtheta r̂ uAxis ∧ rtheta r̂ uAxis ≤ Real.pi :=
by
  have h := clampUnit_range (rdot r̂ uAxis)
  have h' : -1 ≤ clampUnit (rdot r̂ uAxis) ∧ clampUnit (rdot r̂ uAxis) ≤ 1 := h
  exact ⟨Real.arccos_nonneg_of_le_one_of_one_le h'.right,
         Real.arccos_le_pi h'.left h'.right⟩

/-- If θ = 0, then Δi = 0. -/
lemma rDeltaI_zero_if_aligned
  (k : Real) (r uAxis : rVec3)
  (hθ : rtheta (rdir r) uAxis = 0) : rDeltaI k r uAxis = 0 :=
by
  unfold rDeltaI; simp [hθ, mul_comm, mul_left_comm, mul_assoc]

/-- Δi is monotone in k when k₁ ≤ k₂. -/
lemma rDeltaI_monotone_in_k
  {k₁ k₂ : Real} (hk : k₁ ≤ k₂) (r uAxis : rVec3) :
  rDeltaI k₁ r uAxis ≤ rDeltaI k₂ r uAxis :=
by
  unfold rDeltaI
  have hn : 0 ≤ rnorm3 r := by
    unfold rnorm3; exact Real.sqrt_nonneg _
  have hθ : 0 ≤ rtheta (rdir r) uAxis := (rtheta_range (rdir r) uAxis).left
  have : 0 ≤ rnorm3 r * rtheta (rdir r) uAxis := mul_nonneg hn hθ
  exact mul_le_mul_of_nonneg_right hk this

end IVI
