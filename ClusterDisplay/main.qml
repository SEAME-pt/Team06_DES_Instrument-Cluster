import QtQuick 6.4
import QtQuick.Window 6.4
import QtQuick.Controls 6.4

ApplicationWindow {
    id: window
    visible: true
    width: 1920
    height: 720
    title: qsTr("Automotive Cluster Display")

    // Remove window frame for embedded automotive look
    flags: Qt.FramelessWindowHint
    color: "transparent"

    // Main background with automotive gradient
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: "#0c0c0c" }
            GradientStop { position: 0.3; color: "#1a1a1a" }
            GradientStop { position: 0.7; color: "#1a1a1a" }
            GradientStop { position: 1.0; color: "#0c0c0c" }
        }

        // Subtle texture overlay
        Rectangle {
            anchors.fill: parent
            opacity: 0.05
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "#ffffff" }
                GradientStop { position: 0.5; color: "#000000" }
                GradientStop { position: 1.0; color: "#ffffff" }
            }
        }
    }

    // Main cluster content
    Item {
        anchors.fill: parent
        anchors.margins: 30

        // Top status bar
        TopStatusBar {
            id: topStatusBar
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: 80
        }

        // Central dashboard area
        Row {
            anchors {
                top: topStatusBar.bottom
                bottom: bottomInfoBar.top
                left: parent.left
                right: parent.right
                margins: 30
            }
            spacing: 60

            // Left side - Speedometer
            Item {
                width: parent.width * 0.42
                height: parent.height

                CircularSpeedometer {
                    id: speedometer
                    anchors.centerIn: parent
                    width: Math.min(parent.width, parent.height) * 0.95
                    height: width
                }
            }

            // Center - Vehicle status and indicators
            CenterPanel {
                id: centerPanel
                width: parent.width * 0.16
                height: parent.height
            }

            // Right side - Battery/Energy gauge
            Item {
                width: parent.width * 0.42
                height: parent.height

                CircularBatteryGauge {
                    id: batteryGauge
                    anchors.centerIn: parent
                    width: Math.min(parent.width, parent.height) * 0.95
                    height: width
                }
            }
        }

        // Bottom info bar
        BottomInfoBar {
            id: bottomInfoBar
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            height: 100
        }
    }

    // Ambient lighting border effect (using multiple rectangles for glow simulation)
    Item {
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: "#00d4ff"
            border.width: 1
            radius: 15
            opacity: 0.8
        }
        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            color: "transparent"
            border.color: "#00d4ff"
            border.width: 1
            radius: 17
            opacity: 0.4
        }
        Rectangle {
            anchors.fill: parent
            anchors.margins: -4
            color: "transparent"
            border.color: "#00d4ff"
            border.width: 1
            radius: 19
            opacity: 0.2
        }
    }
}
