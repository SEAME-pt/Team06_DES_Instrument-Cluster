import QtQuick 6.4

Item {
    id: streetSignDisplay
    width: 220
    height: 220

    property string signType: clusterModel.signType || "SPEED_LIMIT"  // Default to speed limit for backward compatibility
    property string signValue: clusterModel.signValue || clusterModel.speedLimitSignal.toString()  // Fallback to old system
    property bool signVisible: clusterModel.signVisible || clusterModel.speedLimitVisible  // Show if either system is active

    // Sign is only visible when signVisible is true
    visible: signVisible

    // Debug output
    onSignTypeChanged: {
        console.log("Sign type changed to:", signType)
    }
    onSignVisibleChanged: {
        console.log("Sign visibility changed to:", signVisible)
    }

    // Speed Limit Sign
    Rectangle {
        id: speedLimitSign
        anchors.centerIn: parent
        width: 140
        height: 140
        radius: width/2
        color: "white"
        border {
            width: 12
            color: "red"
        }
        visible: signType === "SPEED_LIMIT"

        // Red border ring
        Rectangle {
            anchors.centerIn: parent
            width: parent.width - 8
            height: parent.height - 8
            radius: width/2
            color: "transparent"
            border {
                width: 3
                color: "red"
            }
        }

        // Speed limit text
        Text {
            anchors.centerIn: parent
            text: signValue
            font.pixelSize: 60
            font.bold: true
            color: "black"
        }
    }

    // Stop Sign
    Item {
        id: stopSign
        anchors.centerIn: parent
        width: 140
        height: 140
        visible: signType === "STOP"

        // Octagonal shape for stop sign
        Canvas {
            id: stopCanvas
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                // Draw octagon
                ctx.fillStyle = "#e30613";  // Red color
                ctx.strokeStyle = "white";
                ctx.lineWidth = 4;

                var centerX = width / 2;
                var centerY = height / 2;
                var radius = 60;

                ctx.beginPath();
                for (var i = 0; i < 8; i++) {
                    var angle = (i * Math.PI * 2) / 8 - Math.PI / 8;
                    var x = centerX + radius * Math.cos(angle);
                    var y = centerY + radius * Math.sin(angle);
                    if (i === 0) {
                        ctx.moveTo(x, y);
                    } else {
                        ctx.lineTo(x, y);
                    }
                }
                ctx.closePath();
                ctx.fill();
                ctx.stroke();
            }
        }

        // Stop text
        Text {
            anchors.centerIn: parent
            text: "STOP"
            font.pixelSize: 38
            font.bold: false
            color: "white"
        }
    }

        // Crosswalk Sign
    Rectangle {
        id: crosswalkSign
        anchors.centerIn: parent
        width: 140
        height: 140
        color: "#1565C0"  // Blue background
        radius: 10
        border {
            width: 4
            color: "white"
        }
        visible: signType === "CROSSWALK"

        // White triangle background
        Canvas {
            id: crosswalkTriangleCanvas
            anchors.centerIn: parent
            width: parent.width * 0.75
            height: parent.height * 0.65
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                // Draw white triangle
                ctx.fillStyle = "white";
                ctx.beginPath();
                ctx.moveTo(width / 2, 5);  // Top point
                ctx.lineTo(5, height - 5);  // Bottom left
                ctx.lineTo(width - 5, height - 5);  // Bottom right
                ctx.closePath();
                ctx.fill();
            }
        }

                                // Crosswalk stripes and pedestrian inside the triangle - exact match to reference image
        Canvas {
            id: crosswalkCanvas
            anchors.centerIn: parent
            width: parent.width * 0.75
            height: parent.height * 0.65
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                ctx.fillStyle = "black";
                ctx.strokeStyle = "black";

                // Triangle coordinates exactly matching the white triangle
                var centerX = width / 2;
                var topY = 5;
                var bottomY = height - 5;
                var leftX = 5;
                var rightX = width - 5;

                                // Draw exactly 5 crosswalk stripes - angled to match triangle perspective
                var numStripes = 5;
                var stripeWidth = 3;
                var stripeLength = 18;

                // Position stripes in lower triangle area
                var stripeAreaCenterY = bottomY - 12;
                var stripeAreaWidth = (rightX - leftX) * 0.7; // Use 70% of triangle width
                var stripeAreaStartX = leftX + (rightX - leftX) * 0.15; // Center the stripe area

                // Calculate the angle for perspective - stripes should be perpendicular to triangle sides
                var triangleAngle = Math.atan2(height - 15, (rightX - leftX) / 2);

                for (var i = 0; i < numStripes; i++) {
                    var progress = i / (numStripes - 1);
                    var stripeX = stripeAreaStartX + progress * stripeAreaWidth;

                    // Draw angled stripe as a rotated rectangle
                    ctx.save();
                    ctx.translate(stripeX, stripeAreaCenterY);

                    // Angle the stripes - left side leans right, right side leans left (opposite of triangle sides)
                    var angle = -(progress - 0.5) * triangleAngle * 0.8;
                    ctx.rotate(angle);

                    ctx.fillRect(-stripeWidth/2, -stripeLength/2, stripeWidth, stripeLength);
                    ctx.restore();
                }

                // Draw pedestrian figure - exact proportions matching reference image
                var pedX = centerX;
                var pedY = height * 0.45; // Position in upper-middle of triangle

                                                // Head - circular like standard pedestrian sign
                ctx.beginPath();
                ctx.arc(pedX, pedY - 12, 6, 0, 2 * Math.PI);
                ctx.fill();

                // Body - vertical line like classic stick figure
                ctx.fillRect(pedX - 1.5, pedY - 6, 3, 14);

                                // Arms positioned for walking from right to left
                // Right arm swinging forward (leading the motion)
                ctx.save();
                ctx.translate(pedX, pedY - 2);
                ctx.rotate(0.2); // Forward swing to the left
                ctx.fillRect(0, -1.5, 10, 3);
                ctx.restore();

                // Left arm swinging back
                ctx.save();
                ctx.translate(pedX, pedY);
                ctx.rotate(-0.3); // Back swing
                ctx.fillRect(-9, -1.5, 9, 3);
                ctx.restore();

                // Legs in walking stride from right to left - made longer
                // Right leg stepping forward to the left
                ctx.save();
                ctx.translate(pedX, pedY + 8);
                ctx.rotate(0.5); // Strong forward stride to the left
                ctx.fillRect(-1.5, 0, 3, 16); // Made longer (16 instead of 12)
                ctx.restore();

                // Left leg pushing back/supporting
                ctx.save();
                ctx.translate(pedX, pedY + 8);
                ctx.rotate(-0.2); // Slight back angle
                ctx.fillRect(-1.5, 0, 3, 16); // Made longer (16 instead of 12)
                ctx.restore();
            }
        }
    }

    // Fade in/out animation when sign visibility changes
    Behavior on opacity {
        NumberAnimation {
            duration: 500
            easing.type: Easing.InOutQuad
        }
    }

    // Opacity is controlled by visibility
    opacity: signVisible ? 1.0 : 0.0
}
