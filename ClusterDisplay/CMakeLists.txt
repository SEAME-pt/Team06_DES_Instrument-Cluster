cmake_minimum_required(VERSION 2.8.12)

project(ClusterDisplay LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt5 COMPONENTS Core Quick REQUIRED)

include_directories(inc)

add_executable(${PROJECT_NAME} main.cpp
    src/ZmqSubscriber.cpp inc/ZmqSubscriber.hpp
    src/BatteryIconObj.cpp inc/BatteryIconObj.hpp
    src/SpeedometerObj.cpp inc/SpeedometerObj.hpp
    qml.qrc)
target_link_libraries(${PROJECT_NAME} Qt5::Core Qt5::Quick zmq)
