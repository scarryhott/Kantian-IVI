/-
  IVI/TiTranslator.lean

  i-dimension translator (Tᵢ) formulated in terms of the IVI moral dimensionality
  intuition. The translator carries an explicit float-based context that tracks
  identity, memory, trust, and dimensional lift; these quantities control the
  zoom angle and scaling applied to C3 vectors.
-/

import IVI.C3Model
import IVI.Invariant
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

namespace IVI

namespace TiTranslator

open scoped Classical

/-- Clamp a float to the `[0,1]` interval. -/
@[simp] def clamp01 (x : Float) : Float :=
  if x < 0 then 0
  else if x > 1 then 1 else x

/--
Context describing the verification environment that drives I-directed zoom.
All fields are normalised to `[0,1]` unless otherwise noted.
-/
structure Context where
  identityPersistence   : Float
  identityCollision     : Float
  memoryImmutability    : Float
  memoryAvailability    : Float
  trustDecentralization : Float
  trustVerifiability    : Float
  contexts              : Nat
  independence          : Float
  hypocrisyRate         : Float := 0.25
  deriving Repr

/-- Default context representing a moderately high-trust, high-dimensional regime. -/
@[simp] def defaultContext : Context :=
  { identityPersistence := (0.65 : Float)
  , identityCollision := (0.70 : Float)
  , memoryImmutability := (0.68 : Float)
  , memoryAvailability := (0.74 : Float)
  , trustDecentralization := (0.78 : Float)
  , trustVerifiability := (0.82 : Float)
  , contexts := 5
  , independence := (0.70 : Float)
  , hypocrisyRate := (0.18 : Float)
  }

/-- Effective lift produced by identity, memory, and trust. -/
@[simp] def lift (ctx : Context) : Float :=
  let i := (ctx.identityPersistence + ctx.identityCollision) / 2
  let m := (ctx.memoryImmutability + ctx.memoryAvailability) / 2
  let t := (ctx.trustDecentralization + ctx.trustVerifiability) / 2
  clamp01 (0.6 * i + 0.8 * m + t)

/-- Dimensionality proxy incorporating the number of contexts and independence. -/
@[simp] def realD (ctx : Context) : Float :=
  Float.ofNat ctx.contexts * clamp01 ctx.independence

/-- Visibility of hypocrisy increases with dimensionality and lift. -/
@[simp] def visibleHypocrisy (ctx : Context) : Float :=
  let base := realD ctx
  let ℓ := lift ctx
  ctx.hypocrisyRate * (1 + 0.5 * Float.log (1 + base * (1 + ℓ)))

/-- Base contradiction energy decreases with more contextual checks. -/
@[simp] def baseEnergy (ctx : Context) : Float :=
  let base := realD ctx
  let ℓ := lift ctx
  1 / (1 + base * ℓ)

/-- Total contradiction energy after accounting for hypocrisy visibility. -/
@[simp] def contradictionEnergy (ctx : Context) : Float :=
  baseEnergy ctx * (1 + visibleHypocrisy ctx)

/-- Moral stability approximation derived from the context. -/
@[simp] def stability (ctx : Context) : Float :=
  1 / (1 + contradictionEnergy ctx)

/-- Rotation angle (radians) used by the I-directed zoom. -/
@[simp] def rotationAngle (ctx : Context) : Float :=
  Float.atan (lift ctx * (1 + stability ctx))

/-- Real-axis scaling emphasises identity persistence. -/
@[simp] def realScale (ctx : Context) : Float :=
  1 + lift ctx

/-- Imaginary-axis scaling emphasises verification resonance. -/
@[simp] def imagScale (ctx : Context) : Float :=
  1 + stability ctx

/-- Human-readable tags describing the current context. -/
@[simp] def tags (ctx : Context) : List String :=
  [ s!"D={ctx.contexts}"
  , s!"Λ={lift ctx |> Float.toString}"
  , s!"S={stability ctx |> Float.toString}"
  ]

private def rotatePair (θ r i : Float) : Float × Float :=
  let cosθ := Float.cos θ
  let sinθ := Float.sin θ
  (r * cosθ - i * sinθ, r * sinθ + i * cosθ)

/-- Apply the I-directed zoom driven by the contextual lift and stability. -/
@[simp] def iDirectedZoom (ctx : Context) (v : C3Vec) : C3Vec :=
  let θ := rotationAngle ctx
  let (r1, i1) := rotatePair θ v.r1 v.i1
  let (r2, i2) := rotatePair θ v.r2 v.i2
  let (r3, i3) := rotatePair θ v.r3 v.i3
  let realScaleFactor := realScale ctx
  let imagScaleFactor := imagScale ctx
  { r1 := r1 * realScaleFactor
  , i1 := i1 * imagScaleFactor
  , r2 := r2 * realScaleFactor
  , i2 := i2 * imagScaleFactor
  , r3 := r3 * realScaleFactor
  , i3 := i3 * imagScaleFactor }

end TiTranslator

/-- Legacy helper: default-context I-directed zoom. -/
@[simp] def iDirectedZoom (v : C3Vec) : C3Vec :=
  TiTranslator.iDirectedZoom TiTranslator.defaultContext v

/-- A meta-vector carrying a direction, translation context, and tags. -/
structure MetaVec (α : Type) where
  /-- Directional component. -/
  dir : α
  /-- Context controlling the i-translation dynamics. -/
  ctx : TiTranslator.Context := TiTranslator.defaultContext
  /-- Metadata tags for tracing the translation history. -/
  tags : List String := []

/-- Types that can be translated along the i-dimension w.r.t. a context. -/
class ITranslatable (α : Type) where
  /-- Prepare a vector (λ-invariant normalisation). -/
  prep : α → α
  /-- Apply the contextual I-directed zoom. -/
  izoom : TiTranslator.Context → α → α
  /-- Align phase and branch cuts. -/
  commit : α → α

open Invariant

/-- Instance for the `C3Vec` carrier using the contextual zoom. -/
instance : ITranslatable C3Vec where
  prep := Invariant.lambdaNormalize
  izoom := TiTranslator.iDirectedZoom
  commit := alignPhase

/--
  i-dimension meta-vector translator (Tᵢ).

  Core transformation sequence:
  1. λ-invariant preparation
  2. Context-driven I-directed zoom
  3. Phase alignment
-/
def T_i (m : MetaVec C3Vec) : MetaVec C3Vec :=
  let ctx := m.ctx
  let v₁ := ITranslatable.prep m.dir
  let v₂ := ITranslatable.izoom ctx v₁
  let v₃ := ITranslatable.commit v₂
  { dir := v₃
  , ctx := ctx
  , tags := "T_i" :: (TiTranslator.tags ctx ++ m.tags) }

/-- Convenience wrapper exposing the transformed direction. -/
def T_i' (v : C3Vec) (ctx : TiTranslator.Context := TiTranslator.defaultContext) : C3Vec :=
  (T_i { dir := v, ctx := ctx }).dir

export ITranslatable (prep izoom commit)

end IVI
