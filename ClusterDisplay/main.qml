import QtQuick 6.4
import QtQuick.Window 6.4
import QtQuick.Controls 6.4
import "ui"

ApplicationWindow {
    id: window
    visible: true
    width: 1920
    height: 720
    title: qsTr("Automotive Cluster Display")

    // Remove window frame for embedded automotive look
    flags: Qt.FramelessWindowHint
    color: "transparent"

    // Define modern EV-style fonts using system fonts that are more futuristic/modern
    readonly property string primaryFont: "'Ubuntu Mono', 'DejaVu Sans Mono', monospace"
    readonly property string secondaryFont: "'Ubuntu Condensed', 'DejaVu Sans', sans-serif"
    readonly property string monoFont: "'Ubuntu Mono', 'DejaVu Sans Mono', monospace"

    // Font weights
    readonly property int fontLight: Font.Light
    readonly property int fontNormal: Font.Normal
    readonly property int fontMedium: Font.Medium
    readonly property int fontDemiBold: Font.DemiBold
    readonly property int fontBold: Font.Bold

    // Letter spacing
    readonly property real letterSpacingTight: 0.5
    readonly property real letterSpacingNormal: 1.0
    readonly property real letterSpacingWide: 2.0
    readonly property real letterSpacingExtraWide: 3.0

    // Main background with more dimension
    Rectangle {
        anchors.fill: parent
        color: "#050505" // Base dark color

        // A radial gradient overlay to give a "glow" from the center, drawn with Canvas
        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                var gradient = ctx.createRadialGradient(width / 2, height / 2, 0, width / 2, height / 2, width / 2);
                gradient.addColorStop(0, "rgba(35, 35, 40, 0.4)");
                gradient.addColorStop(1, "transparent");
                ctx.fillStyle = gradient;
                ctx.fillRect(0, 0, width, height);
            }
        }
    }

    // Main cluster content
    Item {
        id: mainContent
        anchors.fill: parent
        anchors.margins: 40  // Reduced margins to position closer to corners

        // Top left - Time display
        ClockDisplay {
            id: clockDisplay
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 20
                leftMargin: 20
            }
        }

        // Top right - Driving mode
        DrivingModeIndicator {
            id: modeIndicator
            anchors {
                top: parent.top
                right: parent.right
                topMargin: 20
                rightMargin: 20
            }
        }

        // Bottom left - Battery percentage
        BatteryPercentDisplay {
            id: batteryPercent
            anchors {
                bottom: parent.bottom
                left: parent.left
                bottomMargin: 20
                leftMargin: 20
            }
            batteryPercent: 0 // Start at 0%
            isCharging: false // Not charging
        }

        // Bottom right - Odometer
        OdometerDisplay {
            id: odometer
            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: 20
                rightMargin: 20
            }
        }

        // Digital speedometer - centered upper area
        NumberSpeedometer {
            id: speedometer
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 40
            }
            width: Math.min(parent.width * 0.5, parent.height * 0.5)
            height: width
        }

        // Jetracer road graphic - below speedometer (where mode used to be)
        JetracerAlertDisplay {
            id: jetracerGraphic
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: speedometer.bottom
                topMargin: 20
                leftMargin: 30
                rightMargin: 30
            }
            width: 500  // Much wider for better presentation
            height: 300 // Taller for better presentation
            speed: clusterModel.speed // Connect to actual speed from cluster model
            objectAlertActive: clusterModel.objectAlert // Connect to object alert from model
            laneAlertActive: clusterModel.laneAlert // Connect to lane alert from model
            laneDeviationSide: clusterModel.laneDeviationSide // Connect to lane deviation side from model
        }

        // Right side - Street sign recognition
        StreetSignDisplay {
            id: streetSignDisplay
            anchors {
                right: parent.right
                rightMargin: 300
                verticalCenter: parent.verticalCenter
            }
            width: 220
            height: 220
        }

        // Alerts display - centered on the left side
        AlertsDisplay {
            id: alertsDisplay
            anchors {
                left: parent.left
                leftMargin: 150
                verticalCenter: parent.verticalCenter
            }
            // Connect to model's alert properties
            laneAlertActive: clusterModel.laneAlert
            objectAlertActive: clusterModel.objectAlert
            laneDeviationSide: clusterModel.laneDeviationSide // Added to sync lane deviation side
        }
    }

    // Border with rounded corners - breathing effect with battery color
    Rectangle {
        id: borderFrame
        anchors.fill: parent
        anchors.margins: 15
        color: "transparent"
        radius: 40
        border.width: 5  // Base border width

        // Set border color based on battery level using the updated color scheme
        border.color: batteryPercent.isCharging ? batteryPercent.chargingColor : batteryPercent.batteryColor

        opacity: 0.9

        // Slower breathing animation with more subtle effect
        SequentialAnimation on opacity {
            loops: Animation.Infinite
            NumberAnimation {
                to: 0.7
                duration: 1000  // Increased from 2000 to 3000 for slower effect
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                to: 0.7  // Changed from 0.7 to 0.75 for more subtle effect
                duration: 1000  // Increased from 2000 to 3000 for slower effect
                easing.type: Easing.InOutSine
            }
        }

        // Simplified color animation based on charging state
        SequentialAnimation on border.color {
            running: batteryPercent.isCharging
            loops: Animation.Infinite
            ColorAnimation {
                to: batteryPercent.chargingColor  // Light Blue charging color
                duration: 1500  // Increased from 1500 to 2500 for slower effect
            }
            ColorAnimation {
                to: Qt.lighter(batteryPercent.chargingColor, 1.3)  // Slightly lighter blue
                duration: 1500  // Increased from 1500 to 2500 for slower effect
            }
        }
    }
}
