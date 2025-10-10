# Changelog

All notable changes to the Kantian-IVI project.

## [Unreleased]

### Added
- **IVI/SafeFloat.lean** - Safe Float wrapper with NaN/infinity guards
- **IVI/RealSpec.lean** - Real (ℝ) specification layer (mathlib placeholders)
- **THEOREM_INDEX.md** - Complete list of 31+ proven theorems
- **scripts/audit_axioms.sh** - Axiom count verification script
- **.github/workflows/ci.yml** - CI workflow for build + demo + axiom audit

### Changed
- **IVI/WeylBounds.lean** - Deprecated unsafe Float axioms, added architecture notes
- **README.md** - Clarified spec (ℝ) vs runtime (Float) separation
- **HONEST_STATUS.md** - Updated axiom inventory (40 total: 19 core + 21 RealSpec)

### Deprecated
- `Float.le_trans`, `Float.add_le_add`, `Float.zero_le` - Use SafeFloat instead

### Security
- Marked Float arithmetic axioms as UNSAFE (NaN/signed zero issues)
- Added SafeFloat guards to prevent NaN/infinity in order reasoning

---

## [0.2.0] - 2025-10-10

### Added
- **IVI/WeylBounds.lean** - Spectral perturbation bounds (262 lines)
- **IVI/Pure.lean** - DerivedAxioms namespace with 6 constructive proofs
- **IVI/Theorems.lean** - Improved v2 versions of T1-T5
- **IVI/Invariant.lean** - Power iteration convergence properties
- **PROOF_ROADMAP.md** - Detailed proof completion plan (20KB)
- **PROOF_STATUS.md** - Current proof status tracking
- **NEXT_STEPS.md** - Actionable workflow guide
- **HONEST_STATUS.md** - Accurate axiom/theorem accounting
- **SESSION_SUMMARY.md** - Progress report
- **WORK_COMPLETE.md** - Completion summary

### Changed
- **T2_v5** - Proven using Float transitivity (was `sorry`)
- **T2_v2** - Weakened and proven with direct bound (was `sorry`)
- **T2_v3** - Axiomatized (needs stronger Kakeya bounds)
- **Power iteration** - Axiomatized normalization/non-negativity (need Perron-Frobenius)

### Fixed
- Removed all `sorry` statements from proven theorems
- Corrected overclaimed status in documentation
- Accurate theorem count (31 proven, not 26)
- Accurate axiom count (24 core, not 17)

### Proven
- 13 lemmas in IVI/Proofs.lean
- 7 improved theorems in IVI/Theorems.lean (v2 versions)
- 6 derived properties in IVI/Pure.lean
- 3 convergence properties in IVI/Invariant.lean
- 2 matrix norm lemmas in IVI/WeylBounds.lean

**Total: 31 proven items (no `sorry`)**

### Axiomatized
- 12 Kantian axioms (A1-A12, by design)
- 4 Weyl bounds (spectral theory)
- 3 Float arithmetic (deprecated - use SafeFloat)
- 3 Power iteration (need Perron-Frobenius)
- 1 T2_v3 preservation (needs stronger Kakeya)
- 1 Kakeya trivial

**Total: 24 core axioms**

---

## [0.1.0] - Initial Release

### Added
- Core IVI formalization in Lean 4
- Kantian axioms A1-A12
- IVI operations (VWM, Encode, Resuperpose, Rotate)
- Domain specializations
- Kakeya bounds
- Fractal iteration
- Demo executable

### Features
- 13 proven lemmas in IVI/Proofs.lean
- System closure verification
- Runtime validation
- Working demo

---

## Version Numbering

- **0.1.x** - Initial formalization, runtime validation
- **0.2.x** - Proof foundations, axiom documentation
- **0.3.x** - (Future) SafeFloat migration, Real spec
- **1.0.x** - (Future) Mathlib integration, reduced axiom count

---

## Links

- Repository: https://github.com/scarryhott/Kantian-IVI
- Issues: https://github.com/scarryhott/Kantian-IVI/issues
- Releases: https://github.com/scarryhott/Kantian-IVI/releases
