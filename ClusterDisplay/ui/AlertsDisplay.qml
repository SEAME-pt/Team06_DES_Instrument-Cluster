import QtQuick 6.4

Item {
    id: alertsDisplay
    width: 400
    height: 350  // Increased height significantly for much more spacing

    // Properties
    property bool laneAlertActive: false // Lane deviation alert
    property bool objectAlertActive: false // Object detection alert
    property string laneDeviationSide: "left" // Which side the lane deviation is on ("left" or "right")
    property int lastSpeedLimit: 50 // Last received speed limit value

    // Lane departure alert - positioned above center for symmetrical alignment
    Item {
        id: laneAlertBox
        visible: laneAlertActive
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: 10  // Moved down below center
        }
        width: 150
        height: 60

        // Icon first
        Item {
            id: laneIcon
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
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

            // Flashing animation for icon
            SequentialAnimation on opacity {
                running: laneAlertActive
                loops: Animation.Infinite
                NumberAnimation { to: 1.0; duration: 300 }
                NumberAnimation { to: 0.4; duration: 300 }
            }
        }

        // Alert text after icon
        Text {
            id: laneAlertText
            anchors {
                left: laneIcon.right
                leftMargin: 15
                verticalCenter: parent.verticalCenter
            }
            color: "grey"  // White text as requested
            font.pixelSize: 24  // Bigger text (was 24)
            font.bold: false  // Remove bold
            text: "LKAS"  // Lane Keeping Assist System
        }
    }

    // Object detection alert - positioned below center for symmetrical alignment
    Item {
        id: objectAlertBox
        visible: objectAlertActive
        anchors {
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: 8
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: 80   // Moved down further below center
        }
        width: 160
        height: 60

        // Icon first
        Item {
            id: objectIcon
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
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

                // Inner detail lines
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * 0.6
                    height: 2
                    color: "#CC0000"
                }
                Rectangle {
                    anchors.centerIn: parent
                    width: 2
                    height: parent.height * 0.6
                    color: "#CC0000"
                }
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

            // Danger symbol overlay
            Text {
                anchors.centerIn: frontFace
                text: "!"
                color: "white"
                font.pixelSize: 18
                font.bold: true
            }

            // Flashing animation for icon
            SequentialAnimation on opacity {
                running: objectAlertActive
                loops: Animation.Infinite
                NumberAnimation { to: 1.0; duration: 300 }
                NumberAnimation { to: 0.4; duration: 300 }
            }
        }

        // Alert text after icon
        Text {
            id: objectAlertText
            anchors {
                left: objectIcon.right
                leftMargin: 15
                verticalCenter: parent.verticalCenter
            }
            color: "grey"  // White text as requested
            font.pixelSize: 24  // Bigger text (was 24)
            font.bold: false  // Remove bold
            text: " OBS"
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
        }
    }
}
