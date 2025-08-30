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
                var stripeWidth = 7; // Made wider
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

                                                // Draw pedestrian figure - simple geometric style matching reference image
                var pedX = centerX; // Centered horizontally
                var pedY = height * 0.45; // Position in upper-middle of triangle

                // Set up styling
                ctx.fillStyle = "black";
                ctx.strokeStyle = "white";
                ctx.lineWidth = 1.5;

                // Head - simple circle with white contour, positioned to the left
                ctx.beginPath();
                ctx.arc(pedX - 3, pedY - 10, 5, 0, 2 * Math.PI);
                ctx.fill();
                ctx.stroke();

                // Torso and arms as one single connected piece with angled down arms (wider/bolder)
                ctx.beginPath();

                // Start with torso outline
                ctx.moveTo(pedX - 4, pedY - 6); // Top left of torso
                ctx.lineTo(pedX + 4, pedY - 6); // Top right of torso
                ctx.lineTo(pedX + 4, pedY - 2); // Right side to arm connection

                // Right arm angled downward (wider/bolder)
                ctx.lineTo(pedX + 14, pedY + 4); // Right arm end (angled down, wider)
                ctx.lineTo(pedX + 11, pedY + 10); // Right arm bottom edge (bolder)
                ctx.lineTo(pedX + 4, pedY + 3); // Back to torso right side

                // Continue torso right side
                ctx.lineTo(pedX + 4, pedY + 10); // Bottom right of torso
                ctx.lineTo(pedX - 4, pedY + 10); // Bottom left of torso

                // Left side of torso up to arm connection
                ctx.lineTo(pedX - 4, pedY + 3); // Left side to arm connection

                // Left arm angled downward (wider/bolder)
                ctx.lineTo(pedX - 11, pedY + 10); // Left arm bottom edge (bolder)
                ctx.lineTo(pedX - 14, pedY + 4); // Left arm end (angled down, wider)
                ctx.lineTo(pedX - 4, pedY - 2); // Back to torso left side

                // Complete torso outline
                ctx.lineTo(pedX - 4, pedY - 6); // Back to start

                ctx.closePath();
                ctx.fill();
                ctx.stroke();

                // Legs and waist as one single connected piece - inverted V shape for walking
                var waistY = pedY + 10;

                ctx.beginPath();
                // Start from waist width
                ctx.moveTo(pedX - 4, waistY);
                ctx.lineTo(pedX + 4, waistY);

                // Right leg (supporting leg) - straight down
                ctx.lineTo(pedX + 4, waistY + 22);
                ctx.lineTo(pedX - 1, waistY + 22);
                ctx.lineTo(pedX - 1, waistY + 8);

                // Left leg (stepping leg) - angled for walking motion (longer)
                ctx.lineTo(pedX - 10, waistY + 24); // Extended further down
                ctx.lineTo(pedX - 14, waistY + 22); // Extended further out
                ctx.lineTo(pedX - 7, waistY + 6);
                ctx.lineTo(pedX - 4, waistY);

                ctx.closePath();
                ctx.fill();
                ctx.stroke();
            }
        }
    }

        // Yield Sign
    Item {
        id: yieldSign
        anchors.centerIn: parent
        width: 140
        height: 140
        visible: signType === "YIELD"

        // Triangular yield sign with rounded corners
        Canvas {
            id: yieldCanvas
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                var centerX = width / 2;
                var centerY = height / 2;
                var size = 60;
                var cornerRadius = 15;  // Increased corner radius for more rounded corners
                var borderWidth = 12;   // Consistent red border width

                // Calculate triangle points for inverted triangle
                var topLeftX = centerX - size;
                var topLeftY = centerY - size * 0.75;
                var topRightX = centerX + size;
                var topRightY = centerY - size * 0.75;
                var bottomX = centerX;
                var bottomY = centerY + size * 0.75;

                // Draw outer red triangle with rounded corners
                ctx.fillStyle = "#e30613";  // Red color
                ctx.strokeStyle = "white";
                ctx.lineWidth = 4;

                ctx.beginPath();

                // Start from top-left, going clockwise
                // Top edge with rounded corners
                ctx.moveTo(topLeftX + cornerRadius, topLeftY);
                ctx.lineTo(topRightX - cornerRadius, topRightY);
                ctx.quadraticCurveTo(topRightX, topRightY, topRightX - cornerRadius/2, topRightY + cornerRadius/2);

                // Right edge to bottom point
                ctx.lineTo(bottomX + cornerRadius/2, bottomY - cornerRadius);
                ctx.quadraticCurveTo(bottomX, bottomY, bottomX - cornerRadius/2, bottomY - cornerRadius);

                // Left edge back to top
                ctx.lineTo(topLeftX + cornerRadius/2, topLeftY + cornerRadius/2);
                ctx.quadraticCurveTo(topLeftX, topLeftY, topLeftX + cornerRadius, topLeftY);

                ctx.closePath();
                ctx.fill();
                ctx.stroke();

                // Draw inner white triangle (smaller, maintaining proportions)
                var innerSize = size - borderWidth;  // Use consistent border width
                var innerTopLeftX = centerX - innerSize;
                var innerTopLeftY = centerY - innerSize * 0.75;
                var innerTopRightX = centerX + innerSize;
                var innerTopRightY = centerY - innerSize * 0.75;
                var innerBottomX = centerX;
                var innerBottomY = centerY + innerSize * 0.75;
                var innerCornerRadius = cornerRadius - 4;  // Proportional inner corner radius

                ctx.fillStyle = "white";
                ctx.strokeStyle = "white";
                ctx.lineWidth = 0;

                ctx.beginPath();

                // Inner triangle with rounded corners
                ctx.moveTo(innerTopLeftX + innerCornerRadius, innerTopLeftY);
                ctx.lineTo(innerTopRightX - innerCornerRadius, innerTopRightY);
                ctx.quadraticCurveTo(innerTopRightX, innerTopRightY, innerTopRightX - innerCornerRadius/2, innerTopRightY + innerCornerRadius/2);

                ctx.lineTo(innerBottomX + innerCornerRadius/2, innerBottomY - innerCornerRadius);
                ctx.quadraticCurveTo(innerBottomX, innerBottomY, innerBottomX - innerCornerRadius/2, innerBottomY - innerCornerRadius);

                ctx.lineTo(innerTopLeftX + innerCornerRadius/2, innerTopLeftY + innerCornerRadius/2);
                ctx.quadraticCurveTo(innerTopLeftX, innerTopLeftY, innerTopLeftX + innerCornerRadius, innerTopLeftY);

                ctx.closePath();
                ctx.fill();
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
