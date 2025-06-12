import QtQuick 6.4

Item {
    id: batteryBar
    width: 150
    height: 600

    // Battery level property directly from model
    property int batteryLevel: clusterModel.battery
    property bool isCharging: clusterModel.charging

    // Dynamic color based on battery level
    property color batteryColor: {
        if (batteryLevel > 70) return "#00d4ff" // Cyan for high battery
        if (batteryLevel > 30) return "#9f7ae0" // Purple for medium
        return "#ff527a" // Pink-red for low battery
    }

    // Charging indicator text - above the bar
    Text {
        id: batteryLabel
        anchors {
            horizontalCenter: batteryContainer.horizontalCenter
            bottom: batteryContainer.top
            bottomMargin: 15
        }
        text: isCharging ? "CHARGING" : "BATTERY"
        color: isCharging ? batteryColor : "#5a6580"
        font.pixelSize: 16
        font.letterSpacing: 2
        opacity: isCharging ? 1.0 : 0.7

        SequentialAnimation on opacity {
            running: isCharging
            loops: Animation.Infinite
            NumberAnimation { to: 0.7; duration: 800; easing.type: Easing.InOutSine }
            NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutSine }
        }
    }

    // Modern EV battery container
    Item {
        id: batteryContainer
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: parent.height * 0.95

        // Battery background
        Rectangle {
            id: batteryBackground
            anchors.fill: parent
            radius: 10
            color: "#1a2030"

            // Subtle inner shadow
            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: "transparent"
                border.width: 1
                border.color: "#101520"
            }
        }

        // Battery fill - fluid design
        Rectangle {
            id: batteryFill
            anchors {
                left: batteryBackground.left
                right: batteryBackground.right
                bottom: batteryBackground.bottom
                margins: 2
            }
            height: (batteryBackground.height - 4) * (batteryLevel / 100)
            radius: 8

            // Gradient fill that changes with battery level
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Qt.lighter(batteryColor, 1.2) }
                GradientStop { position: 1.0; color: batteryColor }
            }

            // Animated glow effect
            Rectangle {
                id: batteryGlow
                anchors.fill: parent
                radius: parent.radius
                color: "transparent"
                border.width: 1
                border.color: Qt.lighter(batteryColor, 1.5)
                opacity: 0.5

                // Subtle pulsing effect when charging
                SequentialAnimation on opacity {
                    running: isCharging
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.8; duration: 1000; easing.type: Easing.InOutSine }
                    NumberAnimation { to: 0.5; duration: 1000; easing.type: Easing.InOutSine }
                }
            }

            // Highlight effect on left side
            Rectangle {
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                    margins: 4
                }
                width: parent.width * 0.15
                radius: 4
                opacity: 0.3
                color: Qt.lighter(batteryColor, 1.5)
            }
        }

        // Charging animation overlay
        Item {
            anchors.fill: batteryFill
            visible: isCharging
            clip: true

            // Moving light effect for charging
            Rectangle {
                id: chargingEffect
                width: parent.width * 2
                height: parent.height * 0.1
                rotation: -10
                color: "#ffffff"
                opacity: 0.2

                NumberAnimation on y {
                    from: parent.height
                    to: -height
                    duration: 1500
                    loops: Animation.Infinite
                    running: isCharging
                }
            }
        }

        // Battery level markers - subtle lines
        Repeater {
            model: 5 // 20%, 40%, 60%, 80% markers

            Rectangle {
                x: 0
                y: batteryBackground.height * (1 - ((index + 1) * 0.2))
                width: batteryBackground.width
                height: 1
                color: "#101520"
                opacity: 0.5
            }
        }
    }

    // Battery level percentage text
    Text {
        anchors {
            horizontalCenter: batteryContainer.horizontalCenter
            top: batteryContainer.bottom
            topMargin: 15
        }
        text: batteryLevel + "%"
        color: batteryColor
        font.pixelSize: 24
        font.bold: true
    }
}
