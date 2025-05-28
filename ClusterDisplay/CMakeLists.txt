cmake_minimum_required(VERSION 2.8.12)

# Always use ClusterDisplay as project name
project(ClusterDisplay LANGUAGES CXX)

# Option to build as standalone
option(CLUSTER_DISPLAY_STANDALONE "Build ClusterDisplay as standalone project" OFF)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt5 COMPONENTS Core Quick REQUIRED)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/inc)

add_executable(ClusterDisplay main.cpp
    src/ZmqSubscriber.cpp inc/ZmqSubscriber.hpp
    src/BatteryIconObj.cpp inc/BatteryIconObj.hpp
    src/SpeedometerObj.cpp inc/SpeedometerObj.hpp
    qml.qrc)
target_link_libraries(ClusterDisplay Qt5::Core Qt5::Quick zmq)

# Set output directory to match main project
set_target_properties(ClusterDisplay PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)

# Export targets when used as sub-project
if(NOT CLUSTER_DISPLAY_STANDALONE)
    export(TARGETS ClusterDisplay FILE ClusterDisplayConfig.cmake)
endif()
