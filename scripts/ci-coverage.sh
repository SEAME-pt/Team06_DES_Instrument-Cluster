#!/bin/bash

# CI/CD Coverage Report Script
# Provides detailed output for code coverage analysis in CI/CD pipeline

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "=== CODE COVERAGE ANALYSIS ==="
echo "Generating comprehensive coverage report..."

# Capture coverage data with exclusions already applied
echo "Capturing coverage data..."
if lcov --directory . --capture --output-file coverage.info --ignore-errors mismatch; then
  echo "✓ Coverage data captured successfully"
else
  echo "✗ Failed to capture coverage data"
  exit 1
fi

# Remove system and test files
echo "Filtering coverage data..."
lcov --remove coverage.info '/usr/*' --output-file coverage.info --ignore-errors unused
lcov --remove coverage.info '*/tests/unit/*' --output-file coverage.info --ignore-errors unused
lcov --remove coverage.info '*/ClusterDisplayLib_autogen/*' --output-file coverage.info --ignore-errors unused
lcov --remove coverage.info '*/moc_*' --output-file coverage.info --ignore-errors unused
lcov --remove coverage.info '*/qrc_*' --output-file coverage.info --ignore-errors unused
lcov --remove coverage.info '*/inc/*.hpp' --output-file coverage.info --ignore-errors unused
echo "✓ Coverage data filtered"

# Extract coverage statistics
echo ""
echo "=== COVERAGE STATISTICS ==="
COVERAGE_SUMMARY=$(lcov --summary coverage.info)
echo "$COVERAGE_SUMMARY"
echo ""

# Parse coverage percentages and ensure they're clean numbers
LINE_COVERAGE=$(echo "$COVERAGE_SUMMARY" | grep "lines" | head -1 | sed 's/.*: //' | sed 's/%.*//' | tr -d ' \t\n\r' || echo "0")
FUNCTION_COVERAGE=$(echo "$COVERAGE_SUMMARY" | grep "functions" | head -1 | sed 's/.*: //' | sed 's/%.*//' | tr -d ' \t\n\r' || echo "0")
BRANCH_COVERAGE=$(echo "$COVERAGE_SUMMARY" | grep "branches" | head -1 | sed 's/.*: //' | sed 's/%.*//' | tr -d ' \t\n\r' || echo "N/A")

# Ensure LINE_COVERAGE is a valid number
if ! [[ "$LINE_COVERAGE" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
  echo "Warning: Invalid line coverage value '$LINE_COVERAGE', defaulting to 0"
  LINE_COVERAGE="0"
fi

echo "Coverage Summary:"
echo "  - Line coverage: ${LINE_COVERAGE}%"
echo "  - Function coverage: ${FUNCTION_COVERAGE}%"
if [ "$BRANCH_COVERAGE" != "N/A" ]; then
  echo "  - Branch coverage: ${BRANCH_COVERAGE}%"
fi
echo ""

# Debug: Show parsed values
echo "Debug - Parsed coverage values:"
echo "  - LINE_COVERAGE='$LINE_COVERAGE'"
echo "  - FUNCTION_COVERAGE='$FUNCTION_COVERAGE'"
echo "  - BRANCH_COVERAGE='$BRANCH_COVERAGE'"
echo ""

# Show detailed coverage by file
echo "=== DETAILED COVERAGE BY FILE ==="
lcov --list coverage.info | grep -E "(ClusterDisplay/src/|Total:)" | sed 's/^/  /'
echo ""

# Show files with low coverage
echo "=== FILES WITH LOW COVERAGE ==="
LOW_COVERAGE_FILES=$(lcov --list coverage.info | grep "ClusterDisplay/src/" | awk '$2 < 80 {print $0}')
if [ -n "$LOW_COVERAGE_FILES" ]; then
  echo "Files with coverage below 80%:"
  echo "$LOW_COVERAGE_FILES" | sed 's/^/  /'
  echo ""
else
  echo "✓ All source files have good coverage (≥80%)"
  echo ""
fi

# Generate HTML report
echo "=== GENERATING HTML REPORT ==="
if genhtml coverage.info --output-directory coverage_report --title "ClusterDisplay Coverage Report"; then
  echo "✓ HTML coverage report generated successfully"
  echo "  Report location: coverage_report/index.html"
else
  echo "✗ Failed to generate HTML report"
  exit 1
fi

# Coverage quality assessment
echo ""
echo "=== COVERAGE QUALITY ASSESSMENT ==="
if [ "$LINE_COVERAGE" -ge 90 ]; then
  echo "✓ Excellent coverage: ${LINE_COVERAGE}% (≥90%)"
elif [ "$LINE_COVERAGE" -ge 80 ]; then
  echo "✓ Good coverage: ${LINE_COVERAGE}% (≥80%)"
elif [ "$LINE_COVERAGE" -ge 70 ]; then
  echo "⚠ Acceptable coverage: ${LINE_COVERAGE}% (≥70%)"
else
  echo "✗ Low coverage: ${LINE_COVERAGE}% (<70%)"
  echo "::warning::Code coverage is below recommended threshold"
fi
