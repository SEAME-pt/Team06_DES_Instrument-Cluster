import QtQuick 6.4

Item {
    id: speedometer
    width: 400
    height: 400

    property real speed: 0
    property real maxSpeed: 200

    // ZeroMQ subscriber for speed data
    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            // Simulate ZeroMQ data - replace with actual ZeroMQ implementation
            speed = Math.sin(Date.now() * 0.001) * 100 + 100;
        }
    }

    // Background circle with glow effect simulation
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

    // Gauge background
    Canvas {
        id: gaugeCanvas
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

            // Speed arc
            var speedAngle = 0.75 * Math.PI + (speed / maxSpeed) * 1.5 * Math.PI;
            ctx.beginPath();
            ctx.arc(centerX, centerY, radius, 0.75 * Math.PI, speedAngle);

            // Color coding for speed
            if (speed < 60) {
                ctx.strokeStyle = "#00ff88";  // Green
            } else if (speed < 120) {
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
                var x1 = centerX + (radius - 20) * Math.cos(angle);
                var y1 = centerY + (radius - 20) * Math.sin(angle);
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

    // Speed value display
    Item {
        anchors.centerIn: parent
        width: 200
        height: 100

        Text {
            id: speedText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            text: Math.round(speed)
            font.pixelSize: 48
            font.bold: true
            color: "#00d4ff"
            style: Text.Outline
            styleColor: "#001122"
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: speedText.bottom
            anchors.topMargin: 5
            text: "km/h"
            font.pixelSize: 16
            color: "#888888"
        }
    }
}
