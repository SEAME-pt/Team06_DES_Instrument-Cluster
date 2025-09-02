cmake_minimum_required(VERSION 3.16)
project(ClusterDisplay
    VERSION 1.0.0
    LANGUAGES CXX
    DESCRIPTION "Modern automotive cluster display using Qt6 and ZeroMQ"
)

#------------------------------------------------------
# Build configuration
#------------------------------------------------------
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Qt specific settings
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

#------------------------------------------------------
# Options
#------------------------------------------------------
option(CODE_COVERAGE "Enable coverage reporting" OFF)
option(BUILD_TESTS "Build test suite" ON)

#------------------------------------------------------
# Dependencies
#------------------------------------------------------
# Find Qt6 components
find_package(Qt6 REQUIRED COMPONENTS
    Core
    Gui
    Qml
    Quick
    QuickControls2
)

# Find ZeroMQ
find_library(ZMQ_LIBRARY NAMES zmq libzmq REQUIRED)
if(NOT ZMQ_LIBRARY)
    message(FATAL_ERROR "ZeroMQ library not found")
endif()
message(STATUS "Found ZeroMQ: ${ZMQ_LIBRARY}")

#------------------------------------------------------
# Source files
#------------------------------------------------------
set(SOURCES
    src/ClusterModel.cpp
    src/ZmqSubscriber.cpp
    src/BatteryIconObj.cpp
    src/SpeedometerObj.cpp
    src/ZmqMessageParser.cpp
    src/ClusterDataSubscriber.cpp
)

set(HEADERS
    inc/ClusterModel.hpp
    inc/ZmqSubscriber.hpp
    inc/BatteryIconObj.hpp
    inc/SpeedometerObj.hpp
    inc/ZmqMessageParser.hpp
    inc/ClusterDataSubscriber.hpp
)

#------------------------------------------------------
# Core library
#------------------------------------------------------
# Create a library for the core functionality (used by main app and tests)
add_library(ClusterDisplayLib STATIC ${SOURCES} ${HEADERS})
target_include_directories(ClusterDisplayLib PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/inc
)
target_link_libraries(ClusterDisplayLib PUBLIC
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
    ${ZMQ_LIBRARY}
)

# Add code coverage flags if enabled
if(CODE_COVERAGE AND CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(ClusterDisplayLib PUBLIC --coverage -g -O0)
    target_link_options(ClusterDisplayLib PUBLIC --coverage)
endif()

#------------------------------------------------------
# Main executable
#------------------------------------------------------
qt_add_executable(ClusterDisplay
    main.cpp
    qml.qrc
)

target_include_directories(ClusterDisplay PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/inc
)

target_link_libraries(ClusterDisplay PRIVATE
    ClusterDisplayLib
)

#------------------------------------------------------
# Testing
#------------------------------------------------------
if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()
