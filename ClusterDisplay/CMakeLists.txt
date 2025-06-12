cmake_minimum_required(VERSION 3.16)
project(ClusterDisplay VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Configure strict moc compilations
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Find Qt6 components
find_package(Qt6 REQUIRED COMPONENTS Core Quick QuickControls2 Widgets)

# Force full moc processing
qt_wrap_cpp(MOC_FILES
    inc/ClusterModel.hpp
)

# Include directories
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/inc)

# Add executable
add_executable(ClusterDisplay
    main.cpp
    qml.qrc
    src/ClusterModel.cpp
    ${MOC_FILES}
)

# Link Qt6 libraries
target_link_libraries(ClusterDisplay
    Qt6::Core
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Widgets
)

# Set application properties
set_target_properties(ClusterDisplay PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)
