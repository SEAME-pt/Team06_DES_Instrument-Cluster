#!/bin/bash

# CI/CD Clang Format Script
# Provides detailed output for formatting analysis in CI/CD pipeline

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "=== CLANG FORMAT ANALYSIS ==="
echo "Scanning for C++ source files..."

# Find all C++ files
FILES=$(find . -path "./build*" -prune -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" -print)
FILE_COUNT=$(echo "$FILES" | wc -l)
echo "Found $FILE_COUNT C++ files to check"

# Show files being processed
echo "Files to be processed:"
echo "$FILES" | sed 's/^/  /'
echo ""

# Run clang-format and capture output
echo "Running clang-format..."
if echo "$FILES" | xargs clang-format -style=file -i; then
  echo "✓ clang-format completed successfully"
else
  echo "✗ clang-format encountered errors"
  exit 1
fi

# Check for changes
echo ""
echo "=== FORMATTING CHANGES DETECTED ==="
if git diff --exit-code; then
  echo "✓ All files are properly formatted"
  echo "✓ No formatting changes needed"
else
  echo "✗ Formatting issues found:"
  echo ""
  echo "Files with formatting issues:"
  git diff --name-only | sed 's/^/  - /'
  echo ""
  echo "Detailed changes:"
  git diff --stat
  echo ""
  echo "Sample of changes (first 50 lines):"
  git diff | head -50
  echo ""
  echo "::error::Clang format check failed. Run clang-format locally and commit changes."
  exit 1
fi

echo ""
echo "=== FORMATTING SUMMARY ==="
echo "✓ Files processed: $FILE_COUNT"
echo "✓ Formatting check: PASSED"
echo "✓ All files conform to style guidelines"
