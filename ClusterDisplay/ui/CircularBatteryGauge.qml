import QtQuick 6.4

Item {
    id: batteryGauge
    width: 350
    height: 350

    property real batteryLevel: 75 // Percentage (0-100)
    property bool lowBattery: batteryLevel < 20

    // ZeroMQ subscriber for battery data
    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: {
            // Simulate ZeroMQ data - replace with actual ZeroMQ implementation
            batteryLevel = Math.abs(Math.sin(Date.now() * 0.0005)) * 100;
        }
    }

    // Background circle
    Rectangle {
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        radius: width / 2
        color: "transparent"
        border.color: "#333333"
        border.width: 3
        opacity: 0.8
    }

    // Battery gauge background
    Canvas {
        id: batteryCanvas
        anchors.fill: parent
        contextType: "2d"

        onPaint: {
            var ctx = getContext("2d");
            var centerX = width / 2;
            var centerY = height / 2;
            var radius = Math.min(width, height) / 2 - 40;

            ctx.clearRect(0, 0, width, height);
            ctx.lineWidth = 8;

            // Background arc
            ctx.beginPath();
            ctx.arc(centerX, centerY, radius, 0.75 * Math.PI, 2.25 * Math.PI);
            ctx.strokeStyle = "#333333";
            ctx.stroke();

            // Battery level arc
            var batteryAngle = 0.75 * Math.PI + (batteryLevel / 100) * 1.5 * Math.PI;
            ctx.beginPath();
            ctx.arc(centerX, centerY, radius, 0.75 * Math.PI, batteryAngle);

            // Color coding for battery level
            if (batteryLevel > 60) {
                ctx.strokeStyle = "#00ff88";  // Green
            } else if (batteryLevel > 20) {
                ctx.strokeStyle = "#ffaa00";  // Orange
            } else {
                ctx.strokeStyle = "#ff4444";  // Red
            }
            ctx.stroke();

            // Draw tick marks
            ctx.lineWidth = 2;
            ctx.strokeStyle = "#888888";
            for (var i = 0; i <= 10; i++) {
                var angle = 0.75 * Math.PI + (i / 10) * 1.5 * Math.PI;
                var x1 = centerX + (radius - 15) * Math.cos(angle);
                var y1 = centerY + (radius - 15) * Math.sin(angle);
                var x2 = centerX + radius * Math.cos(angle);
                var y2 = centerY + radius * Math.sin(angle);

                ctx.beginPath();
                ctx.moveTo(x1, y1);
                ctx.lineTo(x2, y2);
                ctx.stroke();
            }
        }

        Timer {
            interval: 50
            running: true
            repeat: true
            onTriggered: parent.requestPaint()
        }
    }

    // Battery percentage display
    Item {
        anchors.centerIn: parent
        width: 180
        height: 120

        // Battery icon
        Rectangle {
            id: batteryIcon
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            width: 60
            height: 30
            radius: 4
            color: "transparent"
            border.color: lowBattery ? "#ff4444" : "#00d4ff"
            border.width: 2

            // Battery terminal
            Rectangle {
                anchors.left: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 4
                height: 12
                color: lowBattery ? "#ff4444" : "#00d4ff"
            }

            // Battery fill
            Rectangle {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 3
                width: (parent.width - 6) * (batteryLevel / 100)
                height: parent.height - 6
                radius: 2
                color: lowBattery ? "#ff4444" : "#00ff88"

                // Blinking animation for low battery
                SequentialAnimation on opacity {
                    running: lowBattery
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.3; duration: 500 }
                    NumberAnimation { to: 1.0; duration: 500 }
                }
            }
        }

        Text {
            id: batteryText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: batteryIcon.bottom
            anchors.topMargin: 15
            text: Math.round(batteryLevel) + "%"
            font.pixelSize: 36
            font.bold: true
            color: lowBattery ? "#ff4444" : "#00d4ff"
            style: Text.Outline
            styleColor: "#001122"
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: batteryText.bottom
            anchors.topMargin: 5
            text: "BATTERY"
            font.pixelSize: 14
            color: "#888888"
        }
    }
}
