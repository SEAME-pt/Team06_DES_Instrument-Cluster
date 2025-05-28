cmake_minimum_required(VERSION 2.8.12)

# Only declare project if not included as sub-project
if(NOT DEFINED PROJECT_NAME)
    project(ClusterDisplay LANGUAGES CXX)
endif()

# Option to build as standalone
option(CLUSTER_DISPLAY_STANDALONE "Build ClusterDisplay as standalone project" OFF)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt5 COMPONENTS Core Quick REQUIRED)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/inc)

add_executable(${PROJECT_NAME} main.cpp
    src/ZmqSubscriber.cpp inc/ZmqSubscriber.hpp
    src/BatteryIconObj.cpp inc/BatteryIconObj.hpp
    src/SpeedometerObj.cpp inc/SpeedometerObj.hpp
    qml.qrc)
target_link_libraries(${PROJECT_NAME} Qt5::Core Qt5::Quick zmq)

# Export targets when used as sub-project
if(NOT CLUSTER_DISPLAY_STANDALONE)
    export(TARGETS ${PROJECT_NAME} FILE ClusterDisplayConfig.cmake)
endif()
