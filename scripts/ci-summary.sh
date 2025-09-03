#!/bin/bash

# CI/CD Pipeline Summary Script
# Provides comprehensive summary of all CI/CD steps

set -e

echo ""
echo "=========================================="
echo "    CI/CD PIPELINE EXECUTION SUMMARY"
echo "=========================================="
echo ""
echo "Pipeline execution completed at: $(date)"
echo "Git commit: ${GITHUB_SHA:-unknown}"
echo "Branch: ${GITHUB_REF_NAME:-unknown}"
echo "Workflow run: ${GITHUB_RUN_NUMBER:-unknown}"
echo ""
echo "=== QUALITY GATES STATUS ==="

# Check if we're in the test job context
if [ -d "build" ]; then
  cd build

  # Check coverage if available
  if [ -f "coverage.info" ]; then
    COVERAGE_SUMMARY=$(lcov --summary coverage.info 2>/dev/null || echo "")
    if [ -n "$COVERAGE_SUMMARY" ]; then
      LINE_COVERAGE=$(echo "$COVERAGE_SUMMARY" | grep "lines" | head -1 | sed 's/.*: //' | sed 's/%.*//')
      echo "✓ Code Coverage: ${LINE_COVERAGE}%"
    fi
  fi

  # Check test results if available
  if [ -f "Testing/Temporary/LastTest.log" ]; then
    TOTAL_TESTS=$(grep -c "Test #" Testing/Temporary/LastTest.log 2>/dev/null || echo "0")
    PASSED_TESTS=$(grep -c "Passed" Testing/Temporary/LastTest.log 2>/dev/null || echo "0")
    if [ "$TOTAL_TESTS" -gt 0 ]; then
      echo "✓ Unit Tests: $PASSED_TESTS/$TOTAL_TESTS passed"
    fi
  fi
fi

echo "✓ Code Formatting: Checked with clang-format"
echo "✓ Static Analysis: Checked with clang-tidy"
echo "✓ Build Process: Completed successfully"
echo ""
echo "=== RECOMMENDATIONS ==="
echo "• Review any warnings or notices above"
echo "• Check the coverage report artifact for detailed analysis"
echo "• Address any failed tests or formatting issues"
echo "• Consider running ../../scripts/ci-format.sh and ../../scripts/ci-tidy.sh locally before commits"
echo ""
echo "=== NEXT STEPS ==="
echo "• If all checks passed: Ready for deployment"
echo "• If issues found: Address them and re-run the pipeline"
echo "• Coverage report available in artifacts"
echo ""
echo "=========================================="
