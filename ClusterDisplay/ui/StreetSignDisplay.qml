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
            font.bold: truegit
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
                var stripeWidth = 5; // Made bolder
                var stripeLength = 20; // Made slightly longer

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

                // Draw pedestrian figure - improved proportions and walking pose
                var pedX = centerX - 2; // Shifted slightly left for walking direction
                var pedY = height * 0.45; // Position in upper-middle of triangle

                // Set up white contour styling for all body parts
                ctx.lineWidth = 1.5;
                ctx.strokeStyle = "white";

                // Head - circular, positioned more to the left for walking direction
                ctx.beginPath();
                ctx.arc(pedX - 3, pedY - 12, 6, 0, 2 * Math.PI);
                ctx.fill();
                ctx.stroke(); // White contour

                // Body - much bolder torso like reference image
                ctx.fillRect(pedX - 4, pedY - 6, 8, 14); // Much bolder torso (8 instead of 5)
                ctx.strokeRect(pedX - 4, pedY - 6, 8, 14); // White contour

                                // Arms positioned for walking from right to left - much bolder
                // Right arm upper part - bolder
                ctx.save();
                ctx.translate(pedX, pedY - 1);
                ctx.rotate(0.6); // Flexed downward angle
                ctx.fillRect(0, -2.5, 10, 5); // Much bolder arm (5 instead of 3)
                ctx.strokeRect(0, -2.5, 10, 5); // White contour
                ctx.restore();

                // Right arm lower part (bent down) - bolder
                ctx.save();
                ctx.translate(pedX + 7, pedY + 4); // Position at end of upper arm
                ctx.rotate(1.2); // Bent downward more
                ctx.fillRect(0, -2.5, 8, 5); // Much bolder arm (5 instead of 3)
                ctx.strokeRect(0, -2.5, 8, 5); // White contour
                ctx.restore();

                // Left arm swinging back - much bolder
                ctx.save();
                ctx.translate(pedX, pedY);
                ctx.rotate(-0.3); // Back swing
                ctx.fillRect(-9, -2.5, 9, 5); // Much bolder arm (5 instead of 3)
                ctx.strokeRect(-9, -2.5, 9, 5); // White contour
                ctx.restore();

                // Legs - wider and starting lower to intercept the crosswalk stripes
                // Right leg stepping forward to the left - wider and starting lower
                ctx.save();
                ctx.translate(pedX, pedY + 12); // Start lower (12 instead of 8)
                ctx.rotate(0.5); // Strong forward stride to the left
                // Draw black leg with white outline - wider
                ctx.fillRect(-3, 0, 6, 28); // Wider legs (6 instead of 4)
                ctx.strokeRect(-3, 0, 6, 28); // White outline
                ctx.restore();

                // Left leg pushing back/supporting - wider and starting lower
                ctx.save();
                ctx.translate(pedX, pedY + 12); // Start lower (12 instead of 8)
                ctx.rotate(-0.2); // Slight back angle
                // Draw black leg with white outline - wider
                ctx.fillRect(-3, 0, 6, 28); // Wider legs (6 instead of 4)
                ctx.strokeRect(-3, 0, 6, 28); // White outline
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
