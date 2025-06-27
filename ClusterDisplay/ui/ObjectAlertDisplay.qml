import QtQuick 6.4

Item {
    id: objectAlertDisplay
    width: 180
    height: 180

    // Demo properties
    property bool alertActive: false
    property int distanceToObject: 25  // Distance in meters
    property real alertLevel: 0.0      // 0.0 to 1.0 (severity)

    // Collision visualization
    Item {
        id: collisionVisual
        anchors.fill: parent

        // Road background
        Rectangle {
            anchors.fill: parent
            color: "#1a1a1a"
            radius: 10
        }

        // Our car - at bottom
        Rectangle {
            id: carIcon
            anchors {
                bottom: parent.bottom
                bottomMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
            width: 40
            height: 60
            radius: 5
            color: "#3080ff"
        }

        // Object ahead
        Rectangle {
            id: objectAhead
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            y: alertActive ? 40 : 20
            width: 50
            height: 50
            radius: 5
            color: "#FF8A80"  // Softer red
            opacity: alertActive ? 1.0 : 0.7

            Behavior on y {
                NumberAnimation {
                    duration: 1000
                    easing.type: Easing.InQuad
                }
            }
        }

        // Distance lines
        Repeater {
            model: 3

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                y: carIcon.y - (index + 1) * 30
                height: 2
                width: parent.width * 0.7
                color: "white"
                opacity: 0.5
            }
        }
    }

    // Alert text and distance indicator
    Column {
        anchors {
            top: collisionVisual.bottom
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
        spacing: 5

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: alertActive ? "COLLISION WARNING" : "Object Detection"
            font.pixelSize: 16
            font.bold: alertActive
            color: alertActive ? "#FF8A80" : "#ffffff"  // Softer red
            opacity: alertActive ? 1.0 : 0.7
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: distanceToObject + "m"
            font.pixelSize: alertActive ? 18 : 14
            color: alertActive ? "#FF8A80" : "#ffffff"  // Softer red
            opacity: alertActive ? 1.0 : 0.7
        }
    }

    // Warning indicator flashing when alert is active
    Rectangle {
        id: warningIndicator
        visible: alertActive
        anchors {
            top: parent.top
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
        width: 30
        height: 30
        radius: width/2
        color: "#FF8A80"  // Softer red
        opacity: 0.8

        SequentialAnimation on opacity {
            running: alertActive
            loops: Animation.Infinite
            NumberAnimation { to: 1.0; duration: 200 }
            NumberAnimation { to: 0.4; duration: 200 }
        }
    }

    // Demo animation to show object detection alert
    SequentialAnimation {
        running: true
        loops: Animation.Infinite

        // Normal state
        PropertyAction {
            target: objectAlertDisplay
            property: "alertActive"
            value: false
        }

        PropertyAction {
            target: objectAlertDisplay
            property: "distanceToObject"
            value: 50
        }

        PauseAnimation { duration: 5000 }

        // Object approaching
        PropertyAction {
            target: objectAlertDisplay
            property: "distanceToObject"
            value: 25
        }

        PropertyAction {
            target: objectAlertDisplay
            property: "alertLevel"
            value: 0.5
        }

        PauseAnimation { duration: 2000 }

        // Close proximity alert
        PropertyAction {
            target: objectAlertDisplay
            property: "alertActive"
            value: true
        }

        PropertyAction {
            target: objectAlertDisplay
            property: "distanceToObject"
            value: 10
        }

        PropertyAction {
            target: objectAlertDisplay
            property: "alertLevel"
            value: 1.0
        }

        PauseAnimation { duration: 3000 }
    }
}
