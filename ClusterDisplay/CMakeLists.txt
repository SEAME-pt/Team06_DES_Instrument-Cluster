cmake_minimum_required(VERSION 3.16)
project(ClusterDisplay VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Enable testing
enable_testing()

# Option for code coverage
option(CODE_COVERAGE "Enable coverage reporting" OFF)

# Add code coverage flags if enabled
if(CODE_COVERAGE AND CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
  add_compile_options(--coverage -g -O0)
  add_link_options(--coverage)
endif()

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2)

# Define source files
set(SOURCES
    src/ClusterModel.cpp
    src/ZmqSubscriber.cpp
    src/BatteryIconObj.cpp
    src/SpeedometerObj.cpp
)

set(HEADERS
    inc/ClusterModel.hpp
    inc/ZmqSubscriber.hpp
    inc/BatteryIconObj.hpp
    inc/SpeedometerObj.hpp
)

# Create a library for the core functionality (to be used by tests)
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
)

# Main executable
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

# Add tests subdirectory
add_subdirectory(tests)
