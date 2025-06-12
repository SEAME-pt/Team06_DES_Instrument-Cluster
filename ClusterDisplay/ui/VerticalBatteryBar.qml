import QtQuick 6.4

Item {
    id: batteryBar
    width: 100
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

    // Battery shape container
    Item {
        id: batteryShape
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: parent.height * 0.8

        // Battery body
        Rectangle {
            id: batteryBody
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            height: parent.height * 0.96
            color: "#111111"
            border.color: "#333333"
            border.width: 2
            radius: 10

            // Battery terminal/cap at the top
            Rectangle {
                id: batteryTerminal
                anchors {
                    bottom: parent.top
                    horizontalCenter: parent.horizontalCenter
                }
                width: parent.width * 0.4
                height: parent.height * 0.04
                radius: 4
                color: "#333333"
                border.color: "#444444"
                border.width: 1
            }

            // Battery fill background (empty area)
            Rectangle {
                id: batteryBarBackground
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    margins: 8
                }
                height: parent.height - 16
                color: "#222222"
                radius: 6

                // Battery fill level (actual charge level)
                Rectangle {
                    id: batteryFill
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                        margins: 3
                    }
                    height: Math.max(0, Math.min(parent.height - 6, (parent.height - 6) * (batteryLevel / 100)))
                    radius: 4
                    color: batteryColor

                    // Charging animation
                    Item {
                        anchors.fill: parent
                        visible: isCharging
                        clip: true

                        Rectangle {
                            id: chargingEffect
                            width: parent.width * 3
                            height: parent.height * 0.15
                            color: "#ffffff"
                            opacity: 0.3
                            transform: Rotation {
                                origin.x: 0
                                origin.y: 0
                                angle: 45
                            }

                            SequentialAnimation {
                                running: isCharging
                                loops: Animation.Infinite

                                NumberAnimation {
                                    target: chargingEffect
                                    property: "y"
                                    from: batteryFill.height
                                    to: -chargingEffect.height
                                    duration: 1000
                                    easing.type: Easing.InOutQuad
                                }
                                PauseAnimation { duration: 300 }
                            }
                        }
                    }
                }
            }

            // Battery segment lines
            Repeater {
                model: 10
                Rectangle {
                    width: parent.width - 16
                    height: 1
                    x: 8
                    y: parent.height - ((parent.height - 16) / 10 * (index + 1)) - 8
                    color: "#333333"
                    visible: index < 9 // Don't show top line
                }
            }
        }

        // Battery percentage text
        Text {
            id: percentText
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: batteryLevel < 15 ? 5 : Math.min(batteryFill.height + 5, batteryBody.height - 30)
            }
            text: batteryLevel + "%"
            font.pixelSize: 20
            font.bold: true
            color: batteryColor
        }
    }

    // Charging indicator text
    Text {
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }
        text: isCharging ? "CHARGING" : "BATTERY"
        font.pixelSize: 16
        color: isCharging ? "#00d4ff" : "#888888"
        font.bold: isCharging

        SequentialAnimation on opacity {
            running: isCharging
            loops: Animation.Infinite
            NumberAnimation { to: 0.6; duration: 800 }
            NumberAnimation { to: 1.0; duration: 800 }
        }
    }
}
