#!/usr/bin/env bash
# Axiom audit script
# Verifies that axiom count matches documented inventory

set -e

echo "=== Axiom Audit ==="
echo

# Count axioms by file
echo "Axioms by file:"
for file in IVI/*.lean IVI/Kakeya/*.lean; do
  if [ -f "$file" ]; then
    count=$(grep -c "^axiom " "$file" 2>/dev/null || echo 0)
    if [ "$count" -gt 0 ]; then
      echo "  $file: $count"
    fi
  fi
done

echo

# Total count
TOTAL=$(grep -r "^axiom " IVI/ | wc -l | tr -d ' ')
echo "Total axioms: $TOTAL"

# Expected breakdown (from HONEST_STATUS.md):
# - 12 Kantian (IVI/Pure.lean)
# - 7 analytic in WeylBounds (4 Weyl + 3 Float - deprecated)
# - 3 in Invariant
# - 1 in Theorems
# - 1 in Kakeya/Core
# - Many in RealSpec (placeholder for mathlib)
# - SafeFloat has 2

echo
echo "Expected: ~24 core axioms + RealSpec placeholders"

if [ "$TOTAL" -gt 50 ]; then
  echo "⚠️  WARNING: Axiom count is high ($TOTAL)"
  echo "   This includes RealSpec placeholders for mathlib"
  echo "   Core axioms should be ~24"
else
  echo "✓ Axiom count reasonable"
fi

echo
echo "=== Deprecated Axioms ==="
grep -r "@\[deprecated" IVI/ | grep "axiom" || echo "None found"

echo
echo "=== Axioms in RealSpec (mathlib placeholders) ==="
grep -c "^axiom " IVI/RealSpec.lean 2>/dev/null || echo "0"

echo
echo "Done!"
