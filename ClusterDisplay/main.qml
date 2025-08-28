import QtQuick 6.4
import QtQuick.Window 6.4
import QtQuick.Controls 6.4
import "ui"

ApplicationWindow {
    id: window
    visible: true
    width: 1280  // Changed to correct target width
    height: 400  // Changed to correct target height
    title: qsTr("Automotive Cluster Display")

    // Remove window frame for embedded automotive look and make it full screen
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    visibility: ApplicationWindow.FullScreen
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

    // Main cluster content - Horizontal layout adapted for 1280x400
    Item {
        id: mainContent
        anchors.fill: parent
        anchors.margins: 20  // Reduced margins for shorter height

        // Top left - Time display
        ClockDisplay {
            id: clockDisplay
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 10
                leftMargin: 15
            }
        }

        // Top right - Driving mode
        DrivingModeIndicator {
            id: modeIndicator
            anchors {
                top: parent.top
                right: parent.right
                topMargin: 10
                rightMargin: 15
            }
        }

        // Bottom left - Battery percentage
        BatteryPercentDisplay {
            id: batteryPercent
            anchors {
                bottom: parent.bottom
                left: parent.left
                bottomMargin: 10
                leftMargin: 15
            }
            // Now uses clusterModel.battery and clusterModel.charging from the model
        }

        // Bottom right - Odometer
        OdometerDisplay {
            id: odometer
            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: 10
                rightMargin: 15
            }
        }

        // Digital speedometer - smaller, centered horizontally, positioned higher
        NumberSpeedometer {
            id: speedometer
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 50  // Positioned higher to make room for jetcar below
            }
            width: 140  // Made smaller
            height: 140
        }

        // Jetracer road graphic - larger for proper lane line size, positioned lower
        JetracerAlertDisplay {
            id: jetracerGraphic
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: speedometer.bottom
                topMargin: 10  // Even lower positioning
            }
            width: 300  // Back to larger size for proper lane lines
            height: 180  // Back to larger size for proper lane lines
            speed: clusterModel.speed
            objectAlertActive: clusterModel.objectAlert
            laneAlertActive: clusterModel.laneAlert
            laneDeviationSide: clusterModel.laneDeviationSide
        }

        // Street sign recognition - positioned between speedometer and right edge
        StreetSignDisplay {
            id: streetSignDisplay
            anchors {
                right: parent.right
                rightMargin: 280  // More to the left, between center and edge
                verticalCenter: parent.verticalCenter
            }
            width: 100
            height: 100
        }

        // Alerts display - more centered on y axis with LKAS lower and OBS higher
        AlertsDisplay {
            id: alertsDisplay
            anchors {
                left: parent.left
                leftMargin: 220  // Closer to center
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: 0  // Reset to proper center
            }
            width: 160
            laneAlertActive: clusterModel.laneAlert
            objectAlertActive: clusterModel.objectAlert
            laneDeviationSide: clusterModel.laneDeviationSide
            lastSpeedLimit: clusterModel.lastSpeedLimit
        }
    }

    // Border with rounded corners - restored to original enhanced settings
    Rectangle {
        id: borderFrame
        anchors.fill: parent
        anchors.margins: 12  // Restored original margins
        color: "transparent"
        radius: 40  // Restored original radius

        // Outer glow effect - restored original settings
        Rectangle {
            id: outerGlowBorder
            anchors.fill: parent
            anchors.margins: -8  // Restored original negative margin
            color: "transparent"
            radius: 48  // Restored original radius
            border.width: 6  // Restored original width
            border.color: Qt.alpha(batteryPercent.isCharging ? batteryPercent.chargingColor : batteryPercent.batteryColor, 0.4)

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

        // Middle glow layer - restored original settings
        Rectangle {
            id: middleGlowBorder
            anchors.fill: parent
            anchors.margins: -4  // Restored original margin
            color: "transparent"
            radius: 44  // Restored original radius
            border.width: 6  // Restored original width
            border.color: Qt.alpha(batteryPercent.isCharging ? batteryPercent.chargingColor : batteryPercent.batteryColor, 0.6)

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

        // Main border - restored original settings
        Rectangle {
            id: mainBorder
            anchors.fill: parent
            color: "transparent"
            radius: 40  // Restored original radius
            border.width: 8  // Restored original width
            border.color: batteryPercent.isCharging ? batteryPercent.chargingColor : batteryPercent.batteryColor

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

        // Inner glow effect - restored original settings
        Rectangle {
            anchors.fill: parent
            anchors.margins: 5  // Restored original margins
            color: "transparent"
            radius: 35  // Restored original radius
            border.width: 2
            border.color: Qt.lighter(mainBorder.border.color, 1.2)
            opacity: 0.7

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
