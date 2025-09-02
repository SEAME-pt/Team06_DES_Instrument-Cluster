#!/bin/bash

# Clang Tidy script for ClusterDisplay project
# Usage: ./tidy.sh [--fix]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}Running clang-tidy on ClusterDisplay project...${NC}"

# Check if clang-tidy is installed
if ! command -v clang-tidy &> /dev/null; then
    echo -e "${RED}Error: clang-tidy is not installed.${NC}"
    echo "Install it with: sudo apt-get install clang-tidy"
    exit 1
fi

# Check if cmake is installed
if ! command -v cmake &> /dev/null; then
    echo -e "${RED}Error: cmake is not installed.${NC}"
    echo "Install it with: sudo apt-get install cmake"
    exit 1
fi

# Check if .clang-format file exists (to ensure we're in the right directory)
if [ ! -f ".clang-format" ]; then
    echo -e "${RED}Error: .clang-format file not found in current directory.${NC}"
    echo "Make sure you're running this script from the ClusterDisplay directory."
    exit 1
fi

# Create build directory for compile commands
echo -e "${BLUE}Setting up build environment...${NC}"
mkdir -p build_tidy
cd build_tidy

# Generate compile commands
echo -e "${BLUE}Generating compile commands...${NC}"
cmake .. -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

# Go back to project root
cd ..

# Check if compile_commands.json was created
if [ ! -f "build_tidy/compile_commands.json" ]; then
    echo -e "${RED}Error: compile_commands.json not found. CMake configuration may have failed.${NC}"
    exit 1
fi

# Find all .cpp files (excluding build directories)
FILES=$(find . -path "./build*" -prune -o -name "*.cpp" -print)

if [ "$1" = "--fix" ]; then
    echo -e "${YELLOW}Running clang-tidy with automatic fixes...${NC}"
    # Run clang-tidy with fixes
    echo "$FILES" | xargs clang-tidy -p build_tidy/compile_commands.json -fix
    echo -e "${GREEN}✓ Clang-tidy fixes applied!${NC}"
else
    echo -e "${YELLOW}Running clang-tidy analysis...${NC}"
    # Run clang-tidy for analysis only
    echo "$FILES" | xargs clang-tidy -p build_tidy/compile_commands.json
    echo -e "${GREEN}✓ Clang-tidy analysis complete!${NC}"
    echo -e "${BLUE}Tip: Use ./tidy.sh --fix to automatically apply fixes where possible.${NC}"
fi
