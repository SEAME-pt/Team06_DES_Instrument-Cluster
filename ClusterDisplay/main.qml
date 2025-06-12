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

    // Main background with subtle gradient
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: "#060c14" }
            GradientStop { position: 1.0; color: "#0a121f" }
        }
    }

    // Main cluster content
    Item {
        id: mainContent
        anchors.fill: parent
        anchors.margins: 60

        // Top right - Time display
        ClockDisplay {
            id: clockDisplay
            anchors {
                top: parent.top
                right: parent.right
            }
        }

        // Bottom right - Odometer
        OdometerDisplay {
            id: odometer
            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: 10
            }
        }

        // Left side - Battery bar (vertical)
        ModernBatteryBar {
            id: batteryGauge
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            width: 150
            height: parent.height * 0.85
        }

        // Digital speedometer - moved even higher
        NumberSpeedometer {
            id: speedometer
            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.height * 0.18
            }
            width: Math.min(parent.width * 0.5, parent.height)
            height: width
        }

        // Driving mode - moved a bit lower
        DrivingModeIndicator {
            id: modeIndicator
            anchors {
                bottom: parent.bottom
                bottomMargin: parent.height * 0.15
                horizontalCenter: parent.horizontalCenter
            }
            width: 180
            height: 80
        }
    }

    // Simple border with rounded corners
    Rectangle {
        id: borderFrame
        anchors.fill: parent
        anchors.margins: 15
        color: "transparent"
        radius: 40
        border.width: 2
        border.color: "#00d4ff"
        opacity: 0.25
    }
}
