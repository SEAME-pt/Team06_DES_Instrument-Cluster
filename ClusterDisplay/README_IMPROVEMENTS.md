# Automotive Cluster Display - Professional Improvements

## Overview
This is a modernized, professional automotive cluster display designed to look like high-end car industry dashboards. The display maintains the original ZeroMQ data communication while providing a significantly enhanced visual experience.

## Key Improvements

### 1. Modern Qt6 Compatibility
- Updated for Qt6.4 support
- C++17 standard compliance
- High DPI display support for modern screens
- Material Design style integration

### 2. Professional Automotive Design
- **Circular Gauges**: Modern speedometer and battery gauges with smooth animations
- **Dark Theme**: Automotive-grade dark background with subtle gradients
- **Dynamic Border Lighting**: Color-coded border animations based on battery status
- **Typography**: Clean, bold fonts with proper spacing and hierarchy
- **Color Coding**: Intuitive green/yellow/red color schemes for different states

### 3. Enhanced Components

#### JetracerAlertDisplay
- 3D perspective road visualization
- Animated lane markings that respond to speed
- Lane departure warnings with color-coded indicators
- Object detection with 3D obstacle visualization
- Realistic car representation with warning indicators

#### BatteryPercentDisplay
- Dynamic battery percentage display
- Color-coded battery levels with refined thresholds:
  - 80-100%: Light Green (#90EE90)
  - 50-80%: Lighter Green (#C1FFC1)
  - 25-50%: Light Lemon Chiffon Yellow (#FFFACD)
  - 10-25%: Light Orange (#FFDAB9)
  - 0-10%: Light Red (#FFC0CB)
- Charging indicator with lightning symbol
- Mock mode that cycles through percentages for demonstration

#### NumberSpeedometer
- Digital speed display with modern styling
- Smooth animations for speed changes

#### Border Animation System
- Dynamic border that reflects battery status
- When charging: Pulsing strong light blue animation (#B3E5FC)
- When not charging: Color matches battery percentage thresholds
- Slow, gentle breathing effect with 6-second cycle
- Subtle opacity variation (0.75-0.95) for elegant pulsing

### 4. Advanced Visual Effects
- **Gradient Backgrounds**: Multi-stop gradients for depth
- **Glow Effects**: Subtle shadows and glows
- **Smooth Animations**: Easing curves for professional feel
- **Layer Effects**: Proper layering with transparency

### 5. Data Integration
- Maintains original ZeroMQ communication
- Real-time speed updates
- Real-time battery updates
- Lane departure and object detection alerts

## Technical Specifications

### Requirements
- **Qt Version**: Qt6.4
- **C++ Standard**: C++17
- **Platform**: Linux
- **Dependencies**: ZeroMQ library
- **Resolution**: Optimized for modern displays

### Build Instructions

```bash
# Clone the repository
cd ClusterDisplay

# Create build directory
mkdir build && cd build

# Configure with CMake
cmake ..

# Build the project
make -j4

# Run the application
./ClusterDisplay
```

### ZeroMQ Configuration
The display expects data on the following endpoints:
- **Speed Data**: `tcp://localhost:5555`
- **Battery Data**: `tcp://localhost:5556`

Data format should be numeric strings (e.g., "45" for 45 km/h or "78" for 78% battery).

## Visual Features

### Color Scheme
- **Primary Background**: Dark gradients (#050505 to darker shades)
- **Accent Colors**:
  - Charging: Strong Light Blue (#B3E5FC)
  - Battery Levels: Multiple shades from green to red
- **Success/Good**: Light Green (#90EE90)
- **Warning**: Light Orange (#FFDAB9)
- **Danger/Critical**: Light Red (#FFC0CB)
- **Text**: White (#ffffff) and gray variants

### Animations
- **Border Breathing**: 2000ms smooth transitions
- **Charging Animation**: 1500ms color alternations
- **Road Lines**: Speed-based perspective animations
- **Battery Updates**: 3000ms interval for demo cycling

## File Structure

```
ClusterDisplay/
├── main.cpp                         # Application entry point
├── main.qml                         # Main UI layout with border animations
├── CMakeLists.txt                   # Build configuration
├── qml.qrc                          # QML resources
├── ui/
│   ├── JetracerAlertDisplay.qml     # Road visualization with alerts
│   ├── BatteryPercentDisplay.qml    # Battery indicator with color coding
│   ├── NumberSpeedometer.qml        # Digital speedometer
│   ├── AlertsDisplay.qml            # Alert visualization
│   ├── ClockDisplay.qml             # Time display
│   └── Other components...          # Additional UI elements
└── src/                             # C++ source files
```

## Recent Updates

### Battery Animation System
- Refined color thresholds for better visual feedback
- Added mock mode to demonstrate all battery levels
- Improved border animations with consistent timing
- Enhanced charging animation with stronger blue color (#B3E5FC)
- Simplified animation code for better performance

### Code Cleanup
- Simplified battery color thresholds:
  - 80-100%: Light Green (#90EE90)
  - 50-80%: Lighter Green (#C1FFC1)
  - 25-50%: Light Lemon Chiffon Yellow (#FFFACD)
  - 10-25%: Light Orange (#FFDAB9)
  - 0-10%: Light Red (#FFC0CB)
- Created mock mode that cycles from 0-100% for demonstration
- Optimized border animations with consistent timing
- Consolidated alert displays into JetracerAlertDisplay and AlertsDisplay components

This professional automotive cluster display provides a modern, industrial-grade user interface that meets automotive industry standards while maintaining the existing ZeroMQ data architecture.
