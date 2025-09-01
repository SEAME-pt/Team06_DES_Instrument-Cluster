# Automotive Cluster Display

## Overview

A modern automotive cluster display designed for high-end vehicle dashboards. The system receives real-time data via ZeroMQ and presents it through a professional Qt6-based interface featuring:

- **Digital speedometer** with smooth animations
- **Dynamic battery level indicator** with color-coded states
- **Real-time clock and date display**
- **Advanced driver assistance system (ADAS) visualizations**:
  - Lane departure warnings with directional indicators
  - Object detection alerts with emergency braking
  - Traffic sign recognition (speed limits, stop signs, yield, crosswalk)
  - 3D perspective road visualization
- **Modern automotive UI** with Material Design styling
- **Mock mode** for development and demonstration

## Architecture

### UI Layer (QML)
- Built with **QtQuick 6.4** and Material Design
- Modern circular gauges and dynamic visual elements
- Responsive animations and transitions
- Dark theme with automotive-grade styling
- High DPI display support (1280x400 resolution)
- Frameless fullscreen display for embedded systems

### Application Layer (C++)
- **ClusterModel**: Central data model with Qt properties exposed to QML
- **ClusterDataSubscriber**: Manages ZeroMQ data reception and processing
- **ZmqMessageParser**: Parses incoming data messages
- Signal-based updates for efficient rendering
- C++17 standard compliance
- Comprehensive Doxygen documentation

### Communication Layer (ZeroMQ)
- **Dual-channel architecture**:
  - Critical data (port 5555): Speed, lane alerts, object detection, traffic signs
  - Non-critical data (port 5556): Battery, charging status, odometer
- Publisher-Subscriber pattern for real-time data
- Mock data generation for development

## Key Features

### Advanced Driver Assistance System (ADAS)
- **Lane Departure Warning**: Visual indicators when vehicle deviates from lane center
- **Object Detection**: Real-time obstacle detection with emergency brake activation
- **Traffic Sign Recognition**:
  - Speed limit detection with persistent display
  - Stop sign recognition
  - Yield sign detection
  - Crosswalk warning signs
- **Emergency Braking**: Automatic activation based on critical object detection

### Dynamic Visual Feedback
- **Border Animation System**: Battery status visualization with pulsing effects
- **Color-coded Battery Levels**:
  - 80-100%: Light Green
  - 50-80%: Lighter Green
  - 25-50%: Light Yellow
  - 10-25%: Light Orange
  - 0-10%: Light Red
- **Charging Mode**: Pulsing light blue animation during charging
- **Speed-responsive animations**: Road line animations that respond to vehicle speed

### User Interface Components
- **Digital Speedometer**: Large, clearly readable speed display
- **Battery Indicator**: Modern progress bar with percentage and charging status
- **Clock Display**: Real-time updates with automotive-grade fonts
- **Odometer**: Total distance tracking
- **Driving Mode Indicator**: Current driving mode display (MAN/AUTO)
- **Alert Displays**: Visual warnings for various safety systems

## Technical Requirements

- **Qt Version**: Qt 6.4+
- **C++ Standard**: C++17
- **Platform**: Linux (developed for embedded automotive systems)
- **Dependencies**:
  - ZeroMQ library (libzmq)
  - Qt6 modules: Core, Gui, Qml, Quick, QuickControls2
  - Google Test (for unit testing)
  - Clang (for code formatting and static analysis)

## Build Instructions

```bash
# Clone the repository
git clone <repository-url>
cd Team06_DES_Instrument-Cluster

# Create build directory
mkdir build && cd build

# Configure with CMake
cmake ../ClusterDisplay

# Build the project
make -j4

# Run the application
./ClusterDisplay

# Or run in mock mode (no ZeroMQ needed)
./ClusterDisplay --mock
```

## Testing

The project includes a comprehensive test suite with **100% test pass rate** and **excellent code coverage**:

```bash
# Build and run all tests
cd build
ctest

# Run specific test
./tests/unit/test_ClusterModel
./tests/unit/test_ZmqSubscriber
./tests/unit/test_BatteryIconObj
./tests/unit/test_SpeedometerObj
./tests/unit/test_ZmqMessageParser
./tests/unit/test_ClusterDataSubscriber
```

### Test Coverage
- **Line Coverage**: **95.7%** (266 of 278 lines)
- **Function Coverage**: **92.2%** (47 of 51 functions)
- **ClusterModel**: 16 tests covering all properties, signals, and new features
- **ClusterDataSubscriber**: 24 tests covering data processing, message handling, and ADAS features
- **ZmqSubscriber**: 2 tests for message reception
- **BatteryIconObj**: 4 tests for battery percentage handling
- **SpeedometerObj**: 5 tests including mm/s to km/h conversion
- **ZmqMessageParser**: 8 tests for message parsing and validation

### Coverage Strategy
- **Comprehensive business logic testing** with focus on data processing and ADAS features
- **Strategic exclusions** for difficult-to-test code (network initialization, timer operations, mock data generation)
- **Signal emission testing** using Qt's QSignalSpy for proper Qt integration
- **Edge case coverage** including invalid data handling and boundary conditions

See `ClusterDisplay/tests/README.md` for detailed testing information.

## Code Quality Tools

### Clang Format
The project uses clang-format to maintain consistent code style:

```bash
# Format all source files
find ClusterDisplay/src ClusterDisplay/inc ClusterDisplay/tests -name "*.cpp" -o -name "*.hpp" | xargs clang-format -style=file -i
```

### Clang Tidy
Static analysis is performed using clang-tidy with zero issues:

```bash
# Generate compile commands
mkdir -p build_tidy && cd build_tidy
cmake ../ClusterDisplay -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cd ..

# Run clang-tidy on source files
find ClusterDisplay/src ClusterDisplay/inc -name "*.cpp" | xargs clang-tidy -p build_tidy/compile_commands.json
```

### Documentation
- **Comprehensive Doxygen documentation** for all classes and methods
- **Inline comments** explaining complex algorithms and business logic
- **Architecture documentation** with clear separation of concerns

## CI/CD Pipeline

The project uses GitHub Actions for continuous integration and deployment:

1. **Test Stage**:
   - Runs clang-format to verify code style
   - Performs static analysis with clang-tidy
   - Builds the project and runs unit tests
   - Generates code coverage reports

2. **Build Stage**:
   - Builds the application for ARM64 architecture (Raspberry Pi)
   - Only runs after successful tests
   - Uses Docker for cross-compilation

3. **Deploy Stage**:
   - Deploys the built application to the target Raspberry Pi
   - Only runs for pushes to the dev branch
   - Creates version tracking and deployment logs

The pipeline ensures that only code that passes all tests and quality checks will be deployed.

## Data Communication

### ZeroMQ Configuration

The display expects data on two channels:

**Critical Data (Port 5555)**:
```
speed:<value>          # Vehicle speed in mm/s
lane_alert:<0|1>       # Lane departure warning
lane_side:<left|right> # Side of lane deviation
obs:<0|1|2>           # Object detection (0=none, 1=warning, 2=emergency)
sign_type:<type>      # Traffic sign type
sign_value:<value>    # Traffic sign value
mode:<0|1>          # Driving mode (0=manual, 1=auto)
```

**Non-Critical Data (Port 5556)**:
```
battery:<0-100>       # Battery percentage
charging:<0|1>        # Charging status
odo:<value>          # Odometer reading in meters
```

### Mock Mode
Use `--mock` or `-m` flag to run without ZeroMQ connection for development:
```bash
./ClusterDisplay --mock
```

## Project Structure

```
Team06_DES_Instrument-Cluster/
├── ClusterDisplay/
│   ├── main.cpp                         # Application entry point with command-line options
│   ├── main.qml                         # Main UI layout with border animations
│   ├── CMakeLists.txt                   # Build configuration
│   ├── qml.qrc                          # QML resources
│   ├── .clang-format                    # Code style configuration
│   ├── inc/                             # Header files
│   │   ├── ClusterModel.hpp             # Central data model (extensively documented)
│   │   ├── ClusterDataSubscriber.hpp    # ZeroMQ data management
│   │   ├── ZmqSubscriber.hpp            # ZeroMQ communication base class
│   │   ├── ZmqMessageParser.hpp         # Message parsing utilities
│   │   ├── SpeedometerObj.hpp           # Legacy speed data handler (tested)
│   │   └── BatteryIconObj.hpp           # Legacy battery data handler (tested)
│   ├── src/                             # C++ implementation files
│   │   ├── ClusterModel.cpp             # Main model implementation
│   │   ├── ClusterDataSubscriber.cpp    # Data subscription and processing
│   │   ├── ZmqSubscriber.cpp            # ZeroMQ communication implementation
│   │   ├── ZmqMessageParser.cpp         # Message parsing implementation
│   │   ├── SpeedometerObj.cpp           # Speed data implementation (with conversion)
│   │   └── BatteryIconObj.cpp           # Battery data implementation
│   ├── ui/                              # QML UI components
│   │   ├── JetracerAlertDisplay.qml     # Road visualization with 3D perspective
│   │   ├── BatteryPercentDisplay.qml    # Battery indicator with color coding
│   │   ├── NumberSpeedometer.qml        # Digital speedometer display
│   │   ├── AlertsDisplay.qml            # ADAS alert visualization
│   │   ├── ClockDisplay.qml             # Time and date display
│   │   ├── LaneAlertDisplay.qml         # Lane departure warnings
│   │   ├── ObjectAlertDisplay.qml       # Object detection alerts
│   │   ├── StreetSignDisplay.qml        # Traffic sign recognition display
│   │   ├── ModernBatteryBar.qml         # Advanced battery visualization
│   │   ├── OdometerDisplay.qml          # Distance tracking
│   │   └── DrivingModeIndicator.qml     # Driving mode display
│   └── tests/                           # Test suite (100% pass rate, 95.7% coverage)
│       ├── unit/                        # Unit tests for C++ classes
│       │   ├── test_ClusterModel.cpp    # 16 tests for main model
│       │   ├── test_ClusterDataSubscriber.cpp # 24 tests for data processing
│       │   ├── test_ZmqSubscriber.cpp   # ZeroMQ communication tests
│       │   ├── test_BatteryIconObj.cpp  # Battery handling tests
│       │   ├── test_SpeedometerObj.cpp  # Speed conversion tests
│       │   └── test_ZmqMessageParser.cpp # Message parsing tests
│       └── README.md                    # Detailed testing documentation
├── .github/workflows/                   # CI/CD pipeline
│   └── ci-cd.yml                       # GitHub Actions workflow
├── codecov.yml                         # Code coverage configuration
└── README.md                           # This file
```

## Recent Updates

### Version 2.0 Features
- **Enhanced ADAS Integration**: Complete traffic sign recognition system
- **Emergency Braking**: Automatic activation based on object detection levels
- **Dual-channel ZeroMQ**: Separated critical and non-critical data streams
- **Mock Mode**: Development-friendly operation without ZeroMQ dependency
- **Improved Testing**: 100% test pass rate with comprehensive coverage
- **Documentation**: Complete Doxygen style documentation for all classes

### Code Quality Improvements
- **Zero static analysis issues** with clang-tidy
- **Consistent code formatting** with clang-format
- **Comprehensive test suite** with 95.7% line coverage and signal emission testing
- **Memory safety** with RAII and smart pointers
- **Thread safety** with Qt's signal-slot mechanism
- **Strategic test exclusions** for difficult-to-test infrastructure code

## Development Mode

The system includes multiple development-friendly features:

1. **Mock Mode**: `./ClusterDisplay --mock` runs without ZeroMQ
2. **Real-time Updates**: Live data display during development
3. **Visual Debugging**: Color-coded states for easy troubleshooting
4. **Comprehensive Logging**: Debug output for data flow tracking
