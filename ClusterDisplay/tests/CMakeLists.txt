cmake_minimum_required(VERSION 3.16)

# Enable testing
enable_testing()

# Find required packages
find_package(Qt6 REQUIRED COMPONENTS Test Core Gui Qml Quick QuickControls2)
find_package(GTest REQUIRED)

# Find ZeroMQ if not already found
if(NOT ZMQ_LIBRARY)
    find_library(ZMQ_LIBRARY NAMES zmq libzmq REQUIRED)
    if(NOT ZMQ_LIBRARY)
        message(FATAL_ERROR "ZeroMQ library not found")
    endif()
    message(STATUS "Found ZeroMQ in tests: ${ZMQ_LIBRARY}")
endif()

# Include directories
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/../inc
    ${GTEST_INCLUDE_DIRS}
)

# Add subdirectories
add_subdirectory(unit)
