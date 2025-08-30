import QtQuick 6.4

Item {
    id: alertsDisplay
    width: 400
    height: 350  // Increased height significantly for much more spacing

    // Properties for alerts
    property bool laneAlertActive: false
    property bool objectAlertActive: false
    property bool emergencyBrakeActive: clusterModel.emergencyBrakeActive
    property string laneDeviationSide: "left"
    property int lastSpeedLimit: 0

    // Add property to check if current speed exceeds speed limit (speed is scaled 10x, speed limit is not)
    property bool speedLimitExceeded: lastSpeedLimit > 0 && clusterModel.speed > lastSpeedLimit

    // Centralized blinking control for synchronized alerts
    property real alertOpacity: 1.0

    // Synchronized blinking timer - only runs when alerts are active
    SequentialAnimation {
        id: blinkAnimation
        running: laneAlertActive || objectAlertActive || speedLimitExceeded || emergencyBrakeActive
        loops: Animation.Infinite
        NumberAnimation {
            target: alertsDisplay
            property: "alertOpacity"
            to: 1.0
            duration: 500  // Increased from 300ms for slower blinking
        }
        NumberAnimation {
            target: alertsDisplay
            property: "alertOpacity"
            to: 0.3
            duration: 500  // Increased from 300ms for slower blinking
        }
    }

    // Reset opacity to 1.0 when no alerts are active
    onLaneAlertActiveChanged: {
        if (!laneAlertActive && !objectAlertActive && !speedLimitExceeded && !emergencyBrakeActive) {
            alertOpacity = 1.0;
        } else if (laneAlertActive) {
            // Immediately start blinking when lane alert becomes active
            blinkAnimation.restart();
            alertOpacity = 1.0;  // Start with full opacity
        }
    }
    onObjectAlertActiveChanged: {
        if (!laneAlertActive && !objectAlertActive && !speedLimitExceeded && !emergencyBrakeActive) {
            alertOpacity = 1.0;
        } else if (objectAlertActive) {
            // Immediately start blinking when object alert becomes active
            blinkAnimation.restart();
            alertOpacity = 1.0;  // Start with full opacity
        }
    }
    onSpeedLimitExceededChanged: {
        if (!laneAlertActive && !objectAlertActive && !speedLimitExceeded && !emergencyBrakeActive) {
            alertOpacity = 1.0;
        } else if (speedLimitExceeded) {
            // Immediately start blinking when speed limit is exceeded
            blinkAnimation.restart();
            alertOpacity = 1.0;  // Start with full opacity
        }
    }
    onEmergencyBrakeActiveChanged: {
        if (!laneAlertActive && !objectAlertActive && !speedLimitExceeded && !emergencyBrakeActive) {
            alertOpacity = 1.0;
        } else if (emergencyBrakeActive) {
            // Immediately start blinking when emergency brake becomes active
            blinkAnimation.restart();
            alertOpacity = 1.0;  // Start with full opacity
        }
    }

    // Also watch for speed changes to immediately trigger blinking
    Connections {
        target: clusterModel
        function onSpeedChanged() {
            var wasExceeded = speedLimitExceeded;
            // Force re-evaluation of speedLimitExceeded
            if (lastSpeedLimit > 0 && clusterModel.speed > lastSpeedLimit) {
                if (!wasExceeded) {
                    // Speed just exceeded the limit - start blinking immediately
                    blinkAnimation.restart();
                    alertOpacity = 1.0;
                }
            } else if (wasExceeded) {
                // Speed dropped below limit - stop blinking
                if (!laneAlertActive && !objectAlertActive && !emergencyBrakeActive) {
                    alertOpacity = 1.0;
                }
            }
        }
    }

    // Lane departure alert - positioned at vertical center and to the right
    Item {
        id: laneAlertBox
        visible: laneAlertActive
        anchors {
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: 80  // Moved to the right
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: 0  // At vertical center
        }
        width: 60  // Reduced width since no text
        height: 60

        // Icon first
        Item {
            id: laneIcon
            anchors {
                centerIn: parent  // Center the icon in the container
            }
            width: 60
            height: 40

            // Left lane line - vertical with perspective
            Rectangle {
                anchors {
                    left: parent.left
                    leftMargin: 12
                    verticalCenter: parent.verticalCenter
                }
                width: 4
                height: 30
                color: laneDeviationSide === "left" ? "#FF0000" : "#FF4444"  // Brighter red for active side
                radius: 2

                // Top segment (further away, thinner)
                Rectangle {
                    anchors {
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                    }
                    width: 2
                    height: 8
                    color: laneDeviationSide === "left" ? "#FF0000" : "#FF4444"
                    radius: 1
                }
            }

            // Center dashed line - moving effect
            Column {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                spacing: 3
                Repeater {
                    model: 4
                    Rectangle {
                        width: 3
                        height: 6
                        color: "#FF4444"  // Bright red
                        radius: 1
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            // Right lane line - vertical with perspective
            Rectangle {
                anchors {
                    right: parent.right
                    rightMargin: 12
                    verticalCenter: parent.verticalCenter
                }
                width: 4
                height: 30
                color: laneDeviationSide === "right" ? "#FF0000" : "#FF4444"  // Brighter red for active side
                radius: 2

                // Top segment (further away, thinner)
                Rectangle {
                    anchors {
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                    }
                    width: 2
                    height: 8
                    color: laneDeviationSide === "right" ? "#FF0000" : "#FF4444"
                    radius: 1
                }
            }

            // Car indicator - small rectangle at bottom
            Rectangle {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: 2
                }
                width: 12
                height: 8
                color: "#FF4444"  // Bright red
                radius: 2

                // Add lateral movement to indicate which side is deviating
                transform: Translate {
                    x: laneAlertActive ? (laneDeviationSide === "left" ? -5 : 5) : 0

                    Behavior on x {
                        NumberAnimation { duration: 300 }
                    }
                }
            }

            // Use centralized blinking opacity
            opacity: laneAlertActive ? alertOpacity : 1.0
        }
    }

    // Object detection alert - positioned at vertical center and to the left
    Item {
        id: objectAlertBox
        visible: objectAlertActive
        anchors {
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: -80  // Moved to the left
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: 0   // At vertical center
        }
        width: 60  // Reduced width since no text
        height: 60

        // Icon first
        Item {
            id: objectIcon
            anchors {
                centerIn: parent  // Center the icon in the container
            }
            width: 45
            height: 45

            // Main cube face (front)
            Rectangle {
                id: frontFace
                anchors.centerIn: parent
                width: 28
                height: 28
                color: "#FF4444"  // Bright red
                border.width: 2
                border.color: "#CC0000"  // Darker red for definition
                radius: 3


            }

            // Top face (3D effect)
            Rectangle {
                anchors {
                    bottom: frontFace.top
                    bottomMargin: -3
                    left: frontFace.left
                    leftMargin: 8
                }
                width: 28
                height: 12
                color: "#FF7777"  // Lighter red for 3D effect
                border.width: 1
                border.color: "#CC0000"
                transform: [
                    Rotation { angle: -20; origin.x: 0; origin.y: 12 }
                ]
            }

            // Right face (3D effect)
            Rectangle {
                anchors {
                    left: frontFace.right
                    leftMargin: -3
                    top: frontFace.top
                    topMargin: 8
                }
                width: 12
                height: 28
                color: "#DD4444"  // Medium red for 3D effect
                border.width: 1
                border.color: "#CC0000"
                transform: [
                    Rotation { angle: 20; origin.x: 0; origin.y: 0 }
                ]
            }



            // Use centralized blinking opacity
            opacity: objectAlertActive ? alertOpacity : 1.0
        }
    }

    // Emergency brake alert - positioned below other alerts and centered
    Item {
        id: emergencyBrakeBox
        visible: emergencyBrakeActive
        anchors {
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: 0  // Centered like speed alert
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: 70  // Below other alerts
        }
        width: 60
        height: 60

        // Emergency brake icon
        Item {
            id: emergencyBrakeIcon
            anchors {
                centerIn: parent
            }
            width: 50
            height: 50

            // Brake disc background (circular)
            Rectangle {
                id: brakeDisc
                anchors.centerIn: parent
                width: 45
                height: 45
                radius: 22.5
                color: "#FF4444"  // Bright red
                border.width: 3
                border.color: "#CC0000"  // Darker red border

                // Inner brake disc details (concentric circles)
                Rectangle {
                    anchors.centerIn: parent
                    width: 30
                    height: 30
                    radius: 15
                    color: "transparent"
                    border.width: 2
                    border.color: "#CC0000"
                }
                Rectangle {
                    anchors.centerIn: parent
                    width: 15
                    height: 15
                    radius: 7.5
                    color: "transparent"
                    border.width: 1
                    border.color: "#CC0000"
                }
            }



            // Emergency exclamation mark overlay
            Text {
                anchors.centerIn: brakeDisc
                text: "!"
                color: "white"
                font.pixelSize: 20
                font.bold: true
            }

            // Use centralized blinking opacity
            opacity: emergencyBrakeActive ? alertOpacity : 1.0
        }
    }

    // Permanent speed limit sign - positioned to align with speedometer
    Item {
        id: speedLimitBox
        visible: lastSpeedLimit > 0
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: -70  // Moved down to align with speedometer level
        }
        width: 60
        height: 60

        // Speed limit sign background (circular like real traffic signs)
        Rectangle {
            id: speedLimitBackground
            anchors.centerIn: parent
            width: 50
            height: 50
            radius: 25  // Circular
            color: "white"
            border.width: 3
            border.color: "#FF0000"  // Red border like real speed limit signs

            // Speed limit text
            Text {
                anchors.centerIn: parent
                text: lastSpeedLimit.toString()
                color: "black"
                font.pixelSize: 22
                font.bold: true
            }

            // Use centralized blinking opacity
            opacity: speedLimitExceeded ? alertOpacity : 1.0
        }
    }
}
