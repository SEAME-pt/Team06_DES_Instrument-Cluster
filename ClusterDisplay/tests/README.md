# ClusterDisplay Tests

This directory contains tests for the ClusterDisplay application.

## Prerequisites

To run the tests, you need to have the following installed:
- CMake (version 3.16 or higher)
- Qt6 (with Test, Core, Gui, Qml, Quick, QuickControls2 components)
- Google Test (gtest and gmock)
- ZeroMQ (zmq)

## Directory Structure

- `unit/`: Contains unit tests for individual classes
  - `test_ClusterModel.cpp`: Tests for the ClusterModel class
  - `test_ZmqSubscriber.cpp`: Tests for the ZmqSubscriber class
  - `test_BatteryIconObj.cpp`: Tests for the BatteryIconObj class
  - `test_SpeedometerObj.cpp`: Tests for the SpeedometerObj class

## Building and Running Tests

To build and run the tests:

1. Make sure you're in the project root directory
2. Create a build directory if it doesn't exist:
   ```
   mkdir -p build && cd build
   ```
3. Configure the project with CMake:
   ```
   cmake ..
   ```
4. Build the tests:
   ```
   make
   ```
5. Run the tests:
   ```
   ctest
   ```

Or run individual tests:
```
./tests/unit/test_ClusterModel
./tests/unit/test_ZmqSubscriber
./tests/unit/test_BatteryIconObj
./tests/unit/test_SpeedometerObj
```

## Test Coverage

The unit tests cover:

- ClusterModel:
  - Initial values
  - Property setters and signal emissions

- ZmqSubscriber:
  - Message reception and signal emission

- BatteryIconObj:
  - Initial values
  - Percentage property setter
  - Message handling

- SpeedometerObj:
  - Initial values
  - Speed property setter
  - Message handling
