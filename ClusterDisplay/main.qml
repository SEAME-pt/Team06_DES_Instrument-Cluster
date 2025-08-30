import QtQuick 6.4
import QtQuick.Window 6.4
import QtQuick.Controls 6.4
import "ui"

ApplicationWindow {
    id: window
    visible: true
    width: 1280
    height: 400
    title: qsTr("Automotive Cluster Display")

    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    visibility: ApplicationWindow.FullScreen
    color: "transparent"

    readonly property string primaryFont: "'Ubuntu Mono', 'DejaVu Sans Mono', monospace"
    readonly property string secondaryFont: "'Ubuntu Condensed', 'DejaVu Sans', sans-serif"
    readonly property string monoFont: "'Ubuntu Mono', 'DejaVu Sans Mono', monospace"

    readonly property int fontLight: Font.Light
    readonly property int fontNormal: Font.Normal
    readonly property int fontMedium: Font.Medium
    readonly property int fontDemiBold: Font.DemiBold
    readonly property int fontBold: Font.Bold

    readonly property real letterSpacingTight: 0.5
    readonly property real letterSpacingNormal: 1.0
    readonly property real letterSpacingWide: 2.0
    readonly property real letterSpacingExtraWide: 3.0

    Rectangle {
        anchors.fill: parent
        color: "#050505"

        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                var gradient = ctx.createRadialGradient(width / 2, height / 2, 0, width / 2, height / 2, width / 2);
                gradient.addColorStop(0, "rgba(45, 45, 60, 0.8)");
                gradient.addColorStop(0.4, "rgba(30, 30, 45, 0.6)");
                gradient.addColorStop(1, "rgba(10, 10, 15, 0.2)");
                ctx.fillStyle = gradient;
                ctx.fillRect(0, 0, width, height);
            }
        }

        Canvas {
            anchors.fill: parent
            opacity: 0.15
            onPaint: {
                var ctx = getContext("2d");
                var w = width;
                var h = height;

                ctx.strokeStyle = "rgba(100, 120, 180, 0.3)";
                ctx.lineWidth = 0.5;

                for (var y = 0; y < h; y += 40) {
                    ctx.beginPath();
                    ctx.moveTo(0, y);
                    ctx.lineTo(w, y);
                    ctx.stroke();
                }

                for (var x = 0; x < w; x += 40) {
                    ctx.beginPath();
                    ctx.moveTo(x, 0);
                    ctx.lineTo(x, h);
                    ctx.stroke();
                }
            }
        }
    }

    Item {
        id: mainContent
        anchors.fill: parent
        anchors.margins: 20

        ClockDisplay {
            id: clockDisplay
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 10
                leftMargin: 15
            }
        }

        DrivingModeIndicator {
            id: modeIndicator
            anchors {
                top: parent.top
                right: parent.right
                topMargin: 10
                rightMargin: 15
            }
        }

        BatteryPercentDisplay {
            id: batteryPercent
            anchors {
                bottom: parent.bottom
                left: parent.left
                bottomMargin: 10
                leftMargin: 15
            }
        }

        OdometerDisplay {
            id: odometer
            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: 10
                rightMargin: 15
            }
        }

        NumberSpeedometer {
            id: speedometer
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 50
            }
            width: 140
            height: 140
        }

        JetracerAlertDisplay {
            id: jetracerGraphic
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: speedometer.bottom
                topMargin: 10
            }
            width: 300
            height: 180
            speed: clusterModel.speed
            objectAlertActive: clusterModel.objectAlert
            laneAlertActive: clusterModel.laneAlert
            laneDeviationSide: clusterModel.laneDeviationSide
        }

        StreetSignDisplay {
            id: streetSignDisplay
            anchors {
                right: parent.right
                rightMargin: 280
                verticalCenter: parent.verticalCenter
            }
            width: 100
            height: 100
        }

        AlertsDisplay {
            id: alertsDisplay
            anchors {
                left: parent.left
                leftMargin: 220
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: 0
            }
            width: 160
            laneAlertActive: clusterModel.laneAlert
            objectAlertActive: clusterModel.objectAlert
            laneDeviationSide: clusterModel.laneDeviationSide
            lastSpeedLimit: clusterModel.lastSpeedLimit
        }
    }

    Rectangle {
        id: borderFrame
        anchors.fill: parent
        anchors.margins: 12
        color: "transparent"
        radius: 40

        Rectangle {
            id: outerGlowBorder
            anchors.fill: parent
            anchors.margins: -8
            color: "transparent"
            radius: 48
            border.width: 6
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

        Rectangle {
            id: middleGlowBorder
            anchors.fill: parent
            anchors.margins: -4
            color: "transparent"
            radius: 44
            border.width: 6
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

        Rectangle {
            id: mainBorder
            anchors.fill: parent
            color: "transparent"
            radius: 40
            border.width: 8
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

        Rectangle {
            anchors.fill: parent
            anchors.margins: 5
            color: "transparent"
            radius: 35
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
