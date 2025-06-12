import QtQuick 6.4

Item {
    id: batteryBar
    width: 400
    height: 400

    // Battery level property directly from model
    property int batteryLevel: clusterModel.battery
    property bool isCharging: clusterModel.charging

    // Dynamic color based on battery level
    property color batteryColor: {
        if (batteryLevel > 70) return "#00ff88" // Green for high battery
        if (batteryLevel > 30) return "#ffaa00" // Orange/yellow for medium
        return "#ff4444" // Red for low battery
    }

    // Background container
    Rectangle {
        id: batteryContainer
        anchors.centerIn: parent
        width: parent.width * 0.6
        height: parent.height * 0.4
        color: "#111111"
        border.color: "#333333"
        border.width: 2
        radius: 15

        // Battery percentage bar background
        Rectangle {
            id: batteryBarBackground
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            height: parent.height * 0.3
            color: "#333333"
            radius: height / 2
            anchors.margins: 20

            // Battery fill level
            Rectangle {
                id: batteryFill
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                    margins: 3
                }
                width: Math.max(0, Math.min(parent.width - 6, (parent.width - 6) * (batteryLevel / 100)))
                radius: height / 2
                color: batteryColor

                // Charging animation
                Item {
                    anchors.fill: parent
                    visible: isCharging
                    clip: true

                    Rectangle {
                        id: chargingEffect
                        width: parent.width * 0.15
                        height: parent.height * 3
                        color: "#ffffff"
                        opacity: 0.3
                        transform: Rotation {
                            origin.x: 0
                            origin.y: 0
                            angle: -45
                        }

                        SequentialAnimation {
                            running: isCharging
                            loops: Animation.Infinite

                            NumberAnimation {
                                target: chargingEffect
                                property: "x"
                                from: -chargingEffect.width
                                to: batteryFill.width + chargingEffect.width
                                duration: 1000
                                easing.type: Easing.InOutQuad
                            }
                            PauseAnimation { duration: 300 }
                        }
                    }
                }
            }
        }

        // Battery percentage text
        Text {
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: batteryBarBackground.top
                bottomMargin: 10
            }
            text: batteryLevel + "%"
            font.pixelSize: 24
            font.bold: true
            color: batteryColor
        }

        // Charging indicator
        Text {
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: batteryBarBackground.bottom
                topMargin: 10
            }
            text: isCharging ? "CHARGING" : "BATTERY"
            font.pixelSize: 18
            color: isCharging ? "#00d4ff" : "#888888"
            font.bold: isCharging

            SequentialAnimation on opacity {
                running: isCharging
                loops: Animation.Infinite
                NumberAnimation { to: 0.6; duration: 800 }
                NumberAnimation { to: 1.0; duration: 800 }
            }
        }

        // Subtle glow border
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            radius: 15
            border.width: 1
            border.color: batteryColor
            opacity: 0.3
        }
    }
}
