#!/bin/bash

# CI/CD Unit Test Script
# Provides detailed output for build and test execution in CI/CD pipeline

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "=== BUILD AND TEST EXECUTION ==="

# Create build directory
mkdir -p build
cd build

# Clean any existing CMake cache
echo "Cleaning build environment..."
rm -rf CMakeCache.txt CMakeFiles/
echo "✓ Build environment cleaned"

# Configure with CMake
echo ""
echo "=== CMAKE CONFIGURATION ==="
echo "Configuring project with coverage enabled..."
if cmake .. -DCODE_COVERAGE=ON; then
  echo "✓ CMake configuration successful"
else
  echo "✗ CMake configuration failed"
  exit 1
fi

# Show build configuration
echo ""
echo "Build configuration:"
echo "  - Build type: $(cmake -LA | grep CMAKE_BUILD_TYPE | cut -d= -f2)"
echo "  - Coverage enabled: $(cmake -LA | grep CODE_COVERAGE | cut -d= -f2)"
echo "  - Compiler: $(cmake -LA | grep CMAKE_CXX_COMPILER | cut -d= -f2)"
echo ""

# Build the project
echo "=== BUILDING PROJECT ==="
echo "Starting build process..."
BUILD_START=$(date +%s)

if make -j$(nproc); then
  BUILD_END=$(date +%s)
  BUILD_TIME=$((BUILD_END - BUILD_START))
  echo "✓ Build completed successfully in ${BUILD_TIME}s"
else
  echo "✗ Build failed"
  exit 1
fi

# Show build artifacts
echo ""
echo "Build artifacts:"
find . -name "*.so" -o -name "*.a" -o -name "*test*" -type f | sed 's/^/  /'
echo ""

# Run tests with detailed output
echo "=== RUNNING UNIT TESTS ==="
echo "Starting test execution..."
TEST_START=$(date +%s)

# Create test output file
TEST_OUTPUT=$(mktemp)

# Run tests and capture output
if ctest --output-on-failure --verbose > "$TEST_OUTPUT" 2>&1; then
  TEST_EXIT_CODE=0
else
  TEST_EXIT_CODE=$?
fi

TEST_END=$(date +%s)
TEST_TIME=$((TEST_END - TEST_START))

# Process test results
echo ""
echo "=== TEST RESULTS ANALYSIS ==="

# Extract test statistics and ensure they're clean integers
TOTAL_TESTS=$(grep -c "Test #" "$TEST_OUTPUT" 2>/dev/null | tr -d '\n\r' || echo "0")
PASSED_TESTS=$(grep -c "Passed" "$TEST_OUTPUT" 2>/dev/null | tr -d '\n\r' || echo "0")
FAILED_TESTS=$(grep -c "Failed" "$TEST_OUTPUT" 2>/dev/null | tr -d '\n\r' || echo "0")
NOT_RUN_TESTS=$(grep -c "Not Run" "$TEST_OUTPUT" 2>/dev/null | tr -d '\n\r' || echo "0")

# Ensure variables are numeric and clean
TOTAL_TESTS=$(echo "${TOTAL_TESTS:-0}" | tr -d ' \t\n\r')
PASSED_TESTS=$(echo "${PASSED_TESTS:-0}" | tr -d ' \t\n\r')
FAILED_TESTS=$(echo "${FAILED_TESTS:-0}" | tr -d ' \t\n\r')
NOT_RUN_TESTS=$(echo "${NOT_RUN_TESTS:-0}" | tr -d ' \t\n\r')

echo "Test Execution Summary:"
echo "  - Total tests: $TOTAL_TESTS"
echo "  - Passed: $PASSED_TESTS"
echo "  - Failed: $FAILED_TESTS"
echo "  - Not run: $NOT_RUN_TESTS"
echo "  - Execution time: ${TEST_TIME}s"
echo ""

# Debug: Show variable values for troubleshooting
echo "Debug - Variable values:"
echo "  - TOTAL_TESTS='$TOTAL_TESTS'"
echo "  - PASSED_TESTS='$PASSED_TESTS'"
echo "  - FAILED_TESTS='$FAILED_TESTS'"
echo "  - NOT_RUN_TESTS='$NOT_RUN_TESTS'"
echo ""

# Show test details
echo "=== DETAILED TEST RESULTS ==="
cat "$TEST_OUTPUT"
echo ""

# Analyze failures if any
if [ "$FAILED_TESTS" -gt 0 ]; then
  echo "=== FAILURE ANALYSIS ==="
  echo "Failed tests:"
  grep -A 5 -B 2 "Failed" "$TEST_OUTPUT" | sed 's/^/  /'
  echo ""

  # Show individual test failures
  echo "Individual test failures:"
  grep -A 10 "Test #.*Failed" "$TEST_OUTPUT" | sed 's/^/  /'
  echo ""
fi

# Show test timing information
echo "=== TEST TIMING INFORMATION ==="
if grep -q "Test time" "$TEST_OUTPUT"; then
  echo "Per-test timing:"
  grep "Test time" "$TEST_OUTPUT" | sed 's/^/  /'
  echo ""
fi

# Show memory and performance info if available
if grep -q "Memory" "$TEST_OUTPUT"; then
  echo "Memory usage:"
  grep "Memory" "$TEST_OUTPUT" | sed 's/^/  /'
  echo ""
fi

# Clean up
rm -f "$TEST_OUTPUT"

echo "=== TEST SUMMARY ==="
if [ "$FAILED_TESTS" -eq 0 ]; then
  echo "✓ All tests passed successfully"
  echo "✓ Test coverage: $PASSED_TESTS/$TOTAL_TESTS tests"
  echo "✓ Build and test pipeline: PASSED"
  exit 0
else
  echo "✗ $FAILED_TESTS test(s) failed"
  echo "✗ Test success rate: $(( (PASSED_TESTS * 100) / TOTAL_TESTS ))%"
  echo "::error::Unit tests failed. Please review the test failures above."
  exit 1
fi
