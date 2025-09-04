# ClusterDisplay Tests

This directory contains the test suite for the Automotive Cluster Display application.

## Prerequisites

To run the tests, you need:
- CMake (version 3.16 or higher)
- Qt6 (with Test, Core, Gui, Qml, Quick, QuickControls2 components)
- Google Test (gtest and gmock)
- ZeroMQ (zmq)

## Directory Structure

```
tests/
├── CMakeLists.txt                   # Test build configuration
└── unit/                            # Unit tests
    ├── test_ClusterModel.cpp        # Tests for ClusterModel class
    ├── test_ClusterDataSubscriber.cpp # Tests for ClusterDataSubscriber class
    ├── test_ZmqSubscriber.cpp       # Tests for ZmqSubscriber class
    ├── test_BatteryIconObj.cpp      # Tests for BatteryIconObj class
    ├── test_SpeedometerObj.cpp      # Tests for SpeedometerObj class
    └── test_ZmqMessageParser.cpp    # Tests for ZmqMessageParser class
```

## Building and Running Tests

### From Project Root

```bash
# Create build directory
mkdir -p build && cd build

# Configure with CMake (enable code coverage if needed)
cmake -DCODE_COVERAGE=ON ..

# Build the tests
make -j4

# Run all tests
ctest

# Generate coverage report (if enabled)
make coverage
```

### Running Individual Tests

```bash
# From build directory
./ClusterDisplay/tests/unit/test_ClusterModel
./ClusterDisplay/tests/unit/test_ClusterDataSubscriber
./ClusterDisplay/tests/unit/test_ZmqSubscriber
./ClusterDisplay/tests/unit/test_BatteryIconObj
./ClusterDisplay/tests/unit/test_SpeedometerObj
./ClusterDisplay/tests/unit/test_ZmqMessageParser
```

## Test Coverage

The test suite achieves **100% line coverage** and **96% function coverage** with comprehensive testing of:

### ClusterModel
- Initial property values
- Property setters and getters
- Signal emission on property changes
- DateTime updates
- Mock data simulation

### ClusterDataSubscriber
- Mocking enable/disable functionality
- Message processing for critical and non-critical data
- Data processing for all vehicle parameters (speed, battery, charging, lane detection, etc.)
- Traffic sign processing (speed limits, stop signs, crosswalks, yield signs)
- Error handling and edge cases

### ZmqSubscriber
- Socket initialization
- Message reception
- Signal emission with received data

### ZmqMessageParser
- Message parsing with key-value format
- Data type conversion (int, bool, string)
- Error handling for invalid formats
- Edge cases and boundary conditions

### BatteryIconObj
- Initial values
- Percentage property handling
- ZeroMQ message processing

### SpeedometerObj
- Initial values
- Speed property handling
- ZeroMQ message processing
- mm/s to km/h conversion
