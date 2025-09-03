# CI/CD Scripts

This folder contains dedicated scripts for CI/CD pipeline operations. Each script provides detailed output and analysis for its specific task.

## Scripts Overview

### `ci-format.sh`
**Purpose**: Clang Format analysis and enforcement
- Scans for C++ source files
- Runs clang-format with detailed output
- Shows formatting changes and statistics
- Provides actionable feedback for formatting issues

**Usage**:
```bash
cd ClusterDisplay
# Check formatting without making changes (for CI/CD)
../scripts/ci-format.sh --check

# Apply formatting changes (for local development)
../scripts/ci-format.sh
```

### `ci-tidy.sh`
**Purpose**: Clang Tidy static analysis
- Sets up build environment for analysis
- Runs comprehensive static analysis
- Categorizes issues by type and severity
- Provides detailed issue breakdown and recommendations

**Usage**:
```bash
cd ClusterDisplay
../../scripts/ci-tidy.sh
```

### `ci-test.sh`
**Purpose**: Build and unit test execution
- Configures CMake with coverage enabled
- Builds the project with timing information
- Runs unit tests with detailed analysis
- Provides test statistics and failure analysis

**Usage**:
```bash
cd ClusterDisplay
../../scripts/ci-test.sh
```

### `ci-coverage.sh`
**Purpose**: Code coverage analysis and reporting
- Captures and filters coverage data
- Generates comprehensive coverage statistics
- Identifies files with low coverage
- Creates HTML coverage reports

**Usage**:
```bash
cd ClusterDisplay/build
../../../scripts/ci-coverage.sh
```

### `ci-summary.sh`
**Purpose**: Pipeline execution summary
- Provides comprehensive overview of all CI/CD steps
- Shows quality gates status
- Gives recommendations and next steps
- Displays pipeline metadata

**Usage**:
```bash
cd ClusterDisplay/build
../../../scripts/ci-summary.sh
```

## Local Development

These scripts can also be used locally for development:

```bash
# Check formatting (no changes)
cd ClusterDisplay
../scripts/ci-format.sh --check

# Apply formatting changes
../scripts/ci-format.sh

# Run static analysis
../scripts/ci-tidy.sh

# Run tests
../scripts/ci-test.sh

# Generate coverage report
cd build
../../scripts/ci-coverage.sh
```

## Benefits

1. **Modularity**: Each script handles one specific task
2. **Reusability**: Scripts can be used in CI/CD and locally
3. **Maintainability**: Easy to update individual components
4. **Detailed Output**: Comprehensive analysis and reporting
5. **Consistency**: Same detailed output across environments

## Integration with CI/CD

The main CI/CD workflow (`.github/workflows/ci-cd.yml`) uses these scripts to provide detailed output while keeping the workflow file clean and maintainable.

## Dependencies

- `clang-format` - Code formatting
- `clang-tidy` - Static analysis
- `cmake` - Build configuration
- `make` - Build execution
- `ctest` - Test execution
- `lcov` - Coverage analysis
- `genhtml` - HTML report generation
