#!/bin/bash

# CI/CD Clang Format Script
# Provides detailed output for formatting analysis in CI/CD pipeline
# Usage: ./ci-format.sh [--check]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "=== CLANG FORMAT ANALYSIS ==="
echo "Scanning for C++ source files..."

# Find all C++ files (excluding build directories)
FILES=$(find . -name "*.cpp" -o -name "*.h" -o -name "*.hpp" | grep -v "./build")
FILE_COUNT=$(echo "$FILES" | wc -l)
echo "Found $FILE_COUNT C++ files to check"

# Show files being processed
echo "Files to be processed:"
echo "$FILES" | sed 's/^/  /'
echo ""

# Run clang-format based on mode
if [ "$1" = "--check" ]; then
  echo "Running clang-format check (no changes)..."
  if echo "$FILES" | xargs clang-format -style=file --dry-run --Werror > /dev/null 2>&1; then
    echo "✓ All files are properly formatted"
    echo "✓ No formatting changes needed"
  else
    echo "✗ Some files need formatting"
    echo ""
    echo "Files that need formatting:"
    for file in $FILES; do
      if ! clang-format -style=file --dry-run --Werror "$file" > /dev/null 2>&1; then
        echo "  - $file"
      fi
    done
    echo ""
    echo "::error::Clang format check failed. Run clang-format locally and commit changes."
    exit 1
  fi
else
  echo "Running clang-format (applying changes)..."
  if echo "$FILES" | xargs clang-format -style=file -i; then
    echo "✓ clang-format completed successfully"
    echo "✓ Formatting applied to all files"
  else
    echo "✗ clang-format encountered errors"
    exit 1
  fi
fi

echo ""
echo "=== FORMATTING SUMMARY ==="
echo "✓ Files processed: $FILE_COUNT"
echo "✓ Formatting check: PASSED"
echo "✓ All files conform to style guidelines"
