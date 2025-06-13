# CLUSTER DISPLAY

## General Context
This is a program written in Qt which receives information from a socket using ZeroMQ and displays it on screen. The information displayed includes:
- **Speed (in Km/h)**
- **Battery level**
- **Current time**
- **Lane departure alerts**
- **Object detection alerts**

---

## System Structure
### 1. QML
- The actual display is done using QtQuick 6.4, an application written in QML. All logic which needs no external values is done there, such as the time label (which is updated using a QML function) and the animations.
- The display features modern visual elements including animated speedometer, battery indicators, and alert systems.
- To receive values from the outside, QML accesses values exposed by C++ classes.

### 2. C++
- Currently, each external value displayed has its own C++ class. This allows a different update rate for each value, reducing the amount of unnecessary data displayed and sent.
- The class exposes the property to be shown to QML, which updates it on screen automatically, due to the signal that is emitted when the property changes.
- The value is received through ZeroMQ, a library which handles sockets at low level.

### 3. ZeroMQ
- Each C++ class inherits from a ZmqSubscriber class, which handles the communication with the "outside world".
- Currently, the communication only works one way. The pattern used is the "Publisher-Subscriber" pattern, where a publisher (in this case, the middleware) publishes a value and a subscriber receives it.

---

## Visual Features

### Border Animation System
The cluster display features a dynamic border animation system that provides visual feedback about the battery status:

- **When Charging**: The border animates with a pulsing strong light blue color (#B3E5FC)
- **When Not Charging**: The border color reflects the battery percentage:
  - **80-100%**: Light Green (#90EE90)
  - **50-80%**: Lighter Green (#C1FFC1)
  - **25-50%**: Light Lemon Chiffon Yellow (#FFFACD)
  - **10-25%**: Light Orange (#FFDAB9)
  - **0-10%**: Light Red (#FFC0CB)

### Alert Systems
- **Lane Departure Warning**: Visual indicators when the vehicle deviates from its lane
- **Object Detection**: Displays obstacles detected in front of the vehicle

### Mock Mode
The system includes a mock mode that cycles through battery percentages from 0-100% to demonstrate the different border colors and animations.

### Border Animation
- Slow, subtle breathing effect with 6-second cycle
- Opacity varies between 0.75 and 0.95 for a gentle pulsing
- When charging, color alternates between blue shades with 5-second cycle

---

### Dependencies
- Linux
- Qt 6.4 required, with Qt.Quick library for QML support
- ZeroMQ library
