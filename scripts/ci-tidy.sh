#!/bin/bash

# CI/CD Clang Tidy Script
# Provides detailed output for static analysis in CI/CD pipeline

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "=== CLANG TIDY ANALYSIS ==="
echo "Setting up build environment for static analysis..."

# Create build directory for compile commands
mkdir -p build_tidy
cd build_tidy
echo "Generating compile commands..."
if cmake .. -DCMAKE_EXPORT_COMPILE_COMMANDS=ON; then
  echo "✓ CMake configuration successful"
else
  echo "✗ CMake configuration failed"
  exit 1
fi
cd ..

# Verify compile commands were created
if [ ! -f "build_tidy/compile_commands.json" ]; then
  echo "✗ compile_commands.json not found"
  exit 1
fi
echo "✓ Compile commands generated successfully"

# Find all .cpp files
FILES=$(find . -path "./build*" -prune -o -name "*.cpp" -print)
FILE_COUNT=$(echo "$FILES" | wc -l)
echo "Found $FILE_COUNT C++ source files to analyze"

# Show files being analyzed
echo "Files to be analyzed:"
echo "$FILES" | sed 's/^/  /'
echo ""

# Run clang-tidy and capture output
echo "Running clang-tidy static analysis..."
echo "This may take a few minutes..."

# Create temporary files for output
TIDY_OUTPUT=$(mktemp)
TIDY_ERRORS=$(mktemp)

# Run clang-tidy and capture both stdout and stderr
if echo "$FILES" | xargs clang-tidy -p build_tidy/compile_commands.json > "$TIDY_OUTPUT" 2> "$TIDY_ERRORS"; then
  TIDY_EXIT_CODE=0
else
  TIDY_EXIT_CODE=$?
fi

# Process and display results
echo ""
echo "=== CLANG TIDY RESULTS ==="

# Count issues by severity
WARNING_COUNT=$(grep -c "warning:" "$TIDY_OUTPUT" || echo "0")
ERROR_COUNT=$(grep -c "error:" "$TIDY_OUTPUT" || echo "0")
NOTE_COUNT=$(grep -c "note:" "$TIDY_OUTPUT" || echo "0")

echo "Analysis Summary:"
echo "  - Files analyzed: $FILE_COUNT"
echo "  - Warnings: $WARNING_COUNT"
echo "  - Errors: $ERROR_COUNT"
echo "  - Notes: $NOTE_COUNT"
echo ""

# Show detailed results if any issues found
if [ "$WARNING_COUNT" -gt 0 ] || [ "$ERROR_COUNT" -gt 0 ]; then
  echo "=== DETAILED ISSUES ==="
  cat "$TIDY_OUTPUT"
  echo ""

  # Categorize issues by type
  echo "=== ISSUE CATEGORIZATION ==="
  if [ "$WARNING_COUNT" -gt 0 ]; then
    echo "Warnings by category:"
    grep "warning:" "$TIDY_OUTPUT" | sed 's/.*warning: //' | cut -d' ' -f1 | sort | uniq -c | sort -nr | sed 's/^/  /'
    echo ""
  fi

  if [ "$ERROR_COUNT" -gt 0 ]; then
    echo "Errors by category:"
    grep "error:" "$TIDY_OUTPUT" | sed 's/.*error: //' | cut -d' ' -f1 | sort | uniq -c | sort -nr | sed 's/^/  /'
    echo ""
  fi

  # Show files with most issues
  echo "Files with most issues:"
  grep -E "(warning:|error:)" "$TIDY_OUTPUT" | sed 's/:.*//' | sort | uniq -c | sort -nr | head -10 | sed 's/^/  /'
  echo ""
else
  echo "✓ No static analysis issues found!"
  echo "✓ All code passes clang-tidy checks"
fi

# Show any build errors
if [ -s "$TIDY_ERRORS" ]; then
  echo "=== BUILD ERRORS ==="
  cat "$TIDY_ERRORS"
  echo ""
fi

# Clean up temporary files
rm -f "$TIDY_OUTPUT" "$TIDY_ERRORS"

echo "=== TIDY SUMMARY ==="
if [ "$ERROR_COUNT" -eq 0 ] && [ "$WARNING_COUNT" -eq 0 ]; then
  echo "✓ Static analysis: PASSED"
  echo "✓ No code quality issues detected"
else
  echo "⚠ Static analysis: ISSUES FOUND"
  echo "  - Consider addressing $ERROR_COUNT errors and $WARNING_COUNT warnings"
  echo "  - Use ../../scripts/ci-tidy.sh --fix to automatically fix some issues"
fi

# Exit with appropriate code
if [ "$ERROR_COUNT" -gt 0 ]; then
  echo "::warning::Clang-tidy found $ERROR_COUNT errors that should be addressed"
  exit 1
elif [ "$WARNING_COUNT" -gt 0 ]; then
  echo "::notice::Clang-tidy found $WARNING_COUNT warnings (non-blocking)"
fi
