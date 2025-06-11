cmake_minimum_required(VERSION 3.16)
project(ClusterDisplay VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find Qt6 components
find_package(Qt6 REQUIRED COMPONENTS Core Quick QuickControls2 Widgets)

# Auto-generated MOC, UIC, and RCC
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Find ZeroMQ
find_package(PkgConfig REQUIRED)
pkg_check_modules(ZMQ REQUIRED libzmq)

# Add executable
add_executable(ClusterDisplay
    main.cpp
    qml.qrc
)

# Link Qt6 libraries
target_link_libraries(ClusterDisplay
    Qt6::Core
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Widgets
    ${ZMQ_LIBRARIES}
)

# Include directories
target_include_directories(ClusterDisplay PRIVATE ${ZMQ_INCLUDE_DIRS})

# Compiler flags
target_compile_options(ClusterDisplay PRIVATE ${ZMQ_CFLAGS_OTHER})

# Set application properties
set_target_properties(ClusterDisplay PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)
