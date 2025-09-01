#!/bin/bash

# Clang Format script for ClusterDisplay project
# Usage: ./format.sh [--check]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Running clang-format on ClusterDisplay project...${NC}"

# Check if clang-format is installed
if ! command -v clang-format &> /dev/null; then
    echo -e "${RED}Error: clang-format is not installed.${NC}"
    echo "Install it with: sudo apt-get install clang-format"
    exit 1
fi

# Check if .clang-format file exists
if [ ! -f ".clang-format" ]; then
    echo -e "${RED}Error: .clang-format file not found in current directory.${NC}"
    echo "Make sure you're running this script from the ClusterDisplay directory."
    exit 1
fi

# Find all C++ files (excluding build directories)
FILES=$(find . -path "./build*" -prune -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" -print)

if [ "$1" = "--check" ]; then
    echo -e "${YELLOW}Checking formatting without making changes...${NC}"
    # Check formatting without changing files
    if echo "$FILES" | xargs clang-format -style=file --dry-run --Werror > /dev/null 2>&1; then
        echo -e "${GREEN}✓ All files are properly formatted!${NC}"
        exit 0
    else
        echo -e "${RED}✗ Some files need formatting. Run ./format.sh to fix them.${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}Formatting files...${NC}"
    # Format all files
    echo "$FILES" | xargs clang-format -style=file -i
    echo -e "${GREEN}✓ Formatting complete!${NC}"
fi
