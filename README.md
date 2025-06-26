# Automotive Cluster Display

## Overview

A modern automotive cluster display designed for high-end vehicle dashboards. The system receives real-time data via ZeroMQ and presents it through a professional Qt6-based interface featuring:

- Digital speedometer with smooth animations
- Dynamic battery level indicator with color-coded states
- Real-time clock display
- Advanced driver assistance visualizations:
  - Lane departure warnings
  - Object detection alerts
  - 3D perspective road visualization

## Architecture

### UI Layer (QML)
- Built with QtQuick 6.4
- Modern circular gauges and dynamic visual elements
- Responsive animations and transitions
- Dark theme with automotive-grade styling
- High DPI display support

### Application Layer (C++)
- Each display value has a dedicated C++ class
- Properties exposed to QML via Qt's property system
- Signal-based updates for efficient rendering
- C++17 standard compliance

### Communication Layer (ZeroMQ)
- Publisher-Subscriber pattern
- Real-time data reception from external systems
- Each C++ class inherits from ZmqSubscriber base class

## Visual Features

### Border Animation System
The display features a dynamic border that provides visual feedback about battery status:

- **Charging Mode**: Pulsing light blue animation (#B3E5FC)
- **Battery Level Colors**:
  - 80-100%: Light Green (#90EE90)
  - 50-80%: Lighter Green (#C1FFC1)
  - 25-50%: Light Lemon Chiffon Yellow (#FFFACD)
  - 10-25%: Light Orange (#FFDAB9)
  - 0-10%: Light Red (#FFC0CB)

### Alert Systems
- **Lane Departure Warning**: Visual indicators when vehicle deviates from lane
- **Object Detection**: 3D visualization of obstacles detected ahead
- **Color-coded warnings** with intuitive green/yellow/red states

### Animation Effects
- Smooth transitions with professional easing curves
- Speed-responsive road line animations
- Subtle opacity variations for elegant visual feedback
- Gradient backgrounds with proper layering

## Technical Requirements

- **Qt Version**: Qt 6.4+
- **C++ Standard**: C++17
- **Platform**: Linux
- **Dependencies**:
  - ZeroMQ library
  - Google Test (for running tests)

## Build Instructions

```bash
# Clone the repository
git clone <repository-url>
cd cluster

# Create build directory
mkdir build && cd build

# Configure with CMake
cmake ..

# Build the project
make -j4

# Run the application
./ClusterDisplay/ClusterDisplay
```

## Testing

The project includes a comprehensive test suite in the `ClusterDisplay/tests` directory:

```bash
# Build and run all tests
cd build
ctest

# Run specific test
./ClusterDisplay/tests/unit/test_ClusterModel
```

The tests cover core functionality including:
- ClusterModel properties and signals
- ZeroMQ communication
- Battery and speedometer object behavior

See `ClusterDisplay/tests/README.md` for detailed testing information.

## ZeroMQ Configuration

The display expects data on the following endpoints:
- **Speed Data**: `tcp://localhost:5555`
- **Battery Data**: `tcp://localhost:5556`

Data format should be numeric strings (e.g., "45" for 45 km/h or "78" for 78% battery).

## Project Structure

```
ClusterDisplay/
├── main.cpp                         # Application entry point
├── main.qml                         # Main UI layout with border animations
├── CMakeLists.txt                   # Build configuration
├── qml.qrc                          # QML resources
├── inc/                             # Header files
│   ├── ClusterModel.hpp             # Main model class
│   ├── ZmqSubscriber.hpp            # ZeroMQ communication base class
│   ├── SpeedometerObj.hpp           # Speed data handler
│   └── BatteryIconObj.hpp           # Battery data handler
├── src/                             # C++ implementation files
│   ├── ClusterModel.cpp             # Main model implementation
│   ├── ZmqSubscriber.cpp            # ZeroMQ communication implementation
│   ├── SpeedometerObj.cpp           # Speed data implementation
│   └── BatteryIconObj.cpp           # Battery data implementation
├── ui/                              # QML UI components
│   ├── JetracerAlertDisplay.qml     # Road visualization with alerts
│   ├── BatteryPercentDisplay.qml    # Battery indicator with color coding
│   ├── NumberSpeedometer.qml        # Digital speedometer
│   ├── AlertsDisplay.qml            # Alert visualization
│   ├── ClockDisplay.qml             # Time display
│   └── Other components...          # Additional UI elements
└── tests/                           # Test suite
    └── unit/                        # Unit tests for C++ classes
```

## Development Mode

The system includes a mock mode that cycles through battery percentages from 0-100% to demonstrate the different border colors and animations, useful for development and demonstration purposes.
