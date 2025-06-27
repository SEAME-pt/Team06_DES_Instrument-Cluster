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
                gradient.addColorStop(0, "rgba(45, 45, 60, 0.8)");  // Increased opacity and slightly bluer
                gradient.addColorStop(0.4, "rgba(30, 30, 45, 0.6)"); // Added middle stop for smoother gradient
                gradient.addColorStop(1, "rgba(10, 10, 15, 0.2)");  // Added slight color instead of transparent
                ctx.fillStyle = gradient;
                ctx.fillRect(0, 0, width, height);
            }
        }

        // Additional ambient effect with subtle pattern
        Canvas {
            anchors.fill: parent
            opacity: 0.15
            onPaint: {
                var ctx = getContext("2d");
                var w = width;
                var h = height;

                // Create subtle grid pattern
                ctx.strokeStyle = "rgba(100, 120, 180, 0.3)";
                ctx.lineWidth = 0.5;

                // Draw horizontal lines
                for (var y = 0; y < h; y += 40) {
                    ctx.beginPath();
                    ctx.moveTo(0, y);
                    ctx.lineTo(w, y);
                    ctx.stroke();
                }

                // Draw vertical lines
                for (var x = 0; x < w; x += 40) {
                    ctx.beginPath();
                    ctx.moveTo(x, 0);
                    ctx.lineTo(x, h);
                    ctx.stroke();
                }
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

        // Border with rounded corners - enhanced breathing effect with fading border
    Rectangle {
        id: borderFrame
        anchors.fill: parent
        anchors.margins: 12  // Reduced margins to make room for wider border effect
        color: "transparent"
        radius: 40

        // No border on this element anymore - we'll use the multi-layer approach below

        // Outer glow effect - widest, most transparent layer
        Rectangle {
            id: outerGlowBorder
            anchors.fill: parent
            anchors.margins: -8  // Negative margin makes it extend outward
            color: "transparent"
            radius: 48  // Increased radius to match the expanded size
            border.width: 6
            border.color: Qt.alpha(batteryPercent.isCharging ? batteryPercent.chargingColor : batteryPercent.batteryColor, 0.4)

            // Breathing animation
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation {
                    to: 0.3
                    duration: 1700
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    to: 0.7
                    duration: 1700
                    easing.type: Easing.InOutSine
                }
            }
        }

        // Middle glow layer
        Rectangle {
            id: middleGlowBorder
            anchors.fill: parent
            anchors.margins: -4  // Slightly smaller negative margin than outer
            color: "transparent"
            radius: 44  // Adjusted radius
            border.width: 6
            border.color: Qt.alpha(batteryPercent.isCharging ? batteryPercent.chargingColor : batteryPercent.batteryColor, 0.6)

            // Breathing animation slightly offset from outer layer
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation {
                    to: 0.4
                    duration: 1600
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    to: 0.8
                    duration: 1600
                    easing.type: Easing.InOutSine
                }
            }
        }

        // Main border - brightest, most visible
        Rectangle {
            id: mainBorder
            anchors.fill: parent
            color: "transparent"
            radius: 40
            border.width: 8
            border.color: batteryPercent.isCharging ? batteryPercent.chargingColor : batteryPercent.batteryColor

            // Main border animation
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation {
                    to: 0.6
                    duration: 1500
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    to: 1.0
                    duration: 1500
                    easing.type: Easing.InOutSine
                }
            }

            // Enhanced color animation based on charging state
            SequentialAnimation on border.color {
                running: batteryPercent.isCharging
                loops: Animation.Infinite
                ColorAnimation {
                    to: batteryPercent.chargingColor
                    duration: 1500
                }
                ColorAnimation {
                    to: Qt.lighter(batteryPercent.chargingColor, 1.5)
                    duration: 1500
                }
            }
        }

        // Inner glow effect
        Rectangle {
            anchors.fill: parent
            anchors.margins: 5
            color: "transparent"
            radius: 35
            border.width: 2
            border.color: Qt.lighter(mainBorder.border.color, 1.2)
            opacity: 0.7

            // Synchronized animation with main border
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation {
                    to: 0.4
                    duration: 1500
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    to: 0.7
                    duration: 1500
                    easing.type: Easing.InOutSine
                }
            }
        }
    }
}
