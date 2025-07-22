set(TEST_SOURCES
    test_ClusterModel.cpp
    test_ZmqSubscriber.cpp
    test_BatteryIconObj.cpp
    test_SpeedometerObj.cpp
    test_ZmqMessageParser.cpp
)

# Create test executables
foreach(TEST_SOURCE ${TEST_SOURCES})
    get_filename_component(TEST_NAME ${TEST_SOURCE} NAME_WE)
    add_executable(${TEST_NAME} ${TEST_SOURCE})
    target_link_libraries(${TEST_NAME} PRIVATE
        ClusterDisplayLib
        Qt6::Test
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        Qt6::QuickControls2
        ${GTEST_BOTH_LIBRARIES}
        pthread
        ${ZMQ_LIBRARY}
    )
    add_test(NAME ${TEST_NAME} COMMAND ${TEST_NAME})
endforeach()
