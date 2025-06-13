import QtQuick 6.4

Item {
    id: laneAlertDisplay
    width: 180
    height: 180

    // Demo properties
    property bool alertActive: false
    property string deviationSide: "left"  // "left" or "right"

    // Lane visualization
    Item {
        id: laneVisual
        anchors.fill: parent

        // Road background
        Rectangle {
            anchors.fill: parent
            color: "#1a1a1a"
            radius: 10
        }

        // Center line (dashed and animated)
        Item {
            anchors.centerIn: parent
            width: 10
            height: parent.height
            clip: true

            Column {
                id: movingDashes
                spacing: 15 // Spacing between dashes

                Repeater {
                    model: 10 // More dashes to fill the animation area
                    Rectangle {
                        width: 4
                        height: 15
                        color: "white"
                        opacity: 0.7
                        radius: 2
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                NumberAnimation on y {
                    from: -movingDashes.height / 2
                    to: 0
                    duration: 1000 // Speed of the animation
                    loops: Animation.Infinite
                }
            }
        }

        // Left lane marking
        Rectangle {
            id: leftLane
            anchors {
                left: parent.left
                leftMargin: 20
                top: parent.top
                bottom: parent.bottom
            }
            width: 5
            color: deviationSide === "left" && alertActive ? "#FF8A80" : "white"
            opacity: deviationSide === "left" && alertActive ? 1.0 : 0.7
        }

        // Right lane marking
        Rectangle {
            id: rightLane
            anchors {
                right: parent.right
                rightMargin: 20
                top: parent.top
                bottom: parent.bottom
            }
            width: 5
            color: deviationSide === "right" && alertActive ? "#FF8A80" : "white"
            opacity: deviationSide === "right" && alertActive ? 1.0 : 0.7
        }

        // Car icon
        Rectangle {
            id: carIcon
            anchors.centerIn: parent
            width: 30
            height: 50
            radius: 5
            color: "#3080ff"

            // Show car moving to the side during alert
            transform: Translate {
                x: alertActive ?
                   (deviationSide === "left" ? -15 : 15) : 0
                Behavior on x {
                    NumberAnimation { duration: 300 }
                }
            }
        }
    }

    // Alert text
    Text {
        anchors {
            top: laneVisual.bottom
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
        text: alertActive ? "LANE DEPARTURE" : "Lane Monitoring"
        font.pixelSize: 16
        font.bold: alertActive
        color: alertActive ? "#FF8A80" : "#ffffff"
        opacity: alertActive ? 1.0 : 0.7
    }

    // Demo animation to show lane departure alert
    SequentialAnimation {
        running: true
        loops: Animation.Infinite

        // Normal state
        PropertyAction {
            target: laneAlertDisplay
            property: "alertActive"
            value: false
        }

        PauseAnimation { duration: 5000 }

        // Left deviation alert
        PropertyAction {
            target: laneAlertDisplay
            property: "deviationSide"
            value: "left"
        }

        PropertyAction {
            target: laneAlertDisplay
            property: "alertActive"
            value: true
        }

        PauseAnimation { duration: 3000 }

        // Reset to normal
        PropertyAction {
            target: laneAlertDisplay
            property: "alertActive"
            value: false
        }

        PauseAnimation { duration: 4000 }

        // Right deviation alert
        PropertyAction {
            target: laneAlertDisplay
            property: "deviationSide"
            value: "right"
        }

        PropertyAction {
            target: laneAlertDisplay
            property: "alertActive"
            value: true
        }

        PauseAnimation { duration: 3000 }
    }
}
