import QtQuick 6.4

Item {
    id: alertsDisplay
    width: 400
    height: 350  // Increased height significantly for much more spacing

    // Properties
    property bool laneAlertActive: false // Lane deviation alert
    property bool objectAlertActive: false // Object detection alert

    // Lane departure alert - fixed position at top
    Item {
        id: laneAlertBox
        visible: laneAlertActive
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 50  // Much larger margin
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
                color: "#FF4444"  // Bright red
                radius: 2

                // Top segment (further away, thinner)
                Rectangle {
                    anchors {
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                    }
                    width: 2
                    height: 8
                    color: "#FF4444"
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
                color: "#FF4444"  // Bright red
                radius: 2

                // Top segment (further away, thinner)
                Rectangle {
                    anchors {
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                    }
                    width: 2
                    height: 8
                    color: "#FF4444"
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
            color: "white"  // White text as requested
            font.pixelSize: 32  // Bigger text (was 24)
            font.bold: false  // Remove bold
            text: "LANE"
        }
    }

    // Object detection alert - fixed position at bottom
    Item {
        id: objectAlertBox
        visible: objectAlertActive
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 50  // Much larger margin
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
            color: "white"  // White text as requested
            font.pixelSize: 32  // Bigger text (was 24)
            font.bold: false  // Remove bold
            text: "OBJECT"
        }
    }

    // Demo animation to simulate alerts
    SequentialAnimation {
        running: true
        loops: Animation.Infinite

        // Start with normal state
        PropertyAction {
            target: alertsDisplay
            property: "laneAlertActive"
            value: false
        }

        PropertyAction {
            target: alertsDisplay
            property: "objectAlertActive"
            value: false
        }

        PauseAnimation { duration: 5000 }

        // Lane alert
        PropertyAction {
            target: alertsDisplay
            property: "laneAlertActive"
            value: true
        }

        PauseAnimation { duration: 4000 }

        // Reset lane alert
        PropertyAction {
            target: alertsDisplay
            property: "laneAlertActive"
            value: false
        }

        PauseAnimation { duration: 3000 }

        // Object alert
        PropertyAction {
            target: alertsDisplay
            property: "objectAlertActive"
            value: true
        }

        PauseAnimation { duration: 4000 }

        // Both alerts simultaneously
        PropertyAction {
            target: alertsDisplay
            property: "laneAlertActive"
            value: true
        }

        PauseAnimation { duration: 3000 }
    }
}
