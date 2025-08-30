import QtQuick 6.4

Item {
    id: streetSignDisplay
    width: 220
    height: 220

    property string signType: clusterModel.signType || "SPEED_LIMIT"  // Default to speed limit for backward compatibility
    property string signValue: clusterModel.signValue || clusterModel.speedLimitSignal.toString()
    property bool signVisible: clusterModel.signVisible || clusterModel.speedLimitVisible  // Show if either system is active

    // Sign is only visible when signVisible is true
    visible: signVisible

    // Debug output
    onSignTypeChanged: {
        requestPaint()
    }
    onSignVisibleChanged: {
        requestPaint()
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
                var stripeWidth = 7;
                var stripeLength = 20;


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
                var pedX = centerX - 3; // Move head to the left side for crossing from right to left
                var pedY = height * 0.45; // Position in upper-middle of triangle

                // Set up styling
                ctx.fillStyle = "black";
                ctx.strokeStyle = "white";
                ctx.lineWidth = 1.5;


                ctx.beginPath();
                ctx.arc(pedX - 3, pedY - 10, 4, 0, 2 * Math.PI);
                ctx.fill();
                ctx.stroke();

                // Torso and arms as one single connected piece with arms starting at top (slightly thicker)
                ctx.beginPath();

                // Start with flat top of torso
                ctx.moveTo(pedX - 4, pedY - 6); // Top left of torso
                ctx.lineTo(pedX + 4, pedY - 6); // Top right of torso (flat top)

                // Right arm starts at top of torso and angles down
                ctx.lineTo(pedX + 13, pedY + 4); // Right arm end (angled down from top)
                ctx.lineTo(pedX + 11, pedY + 9); // Right arm bottom edge (slightly thicker)
                ctx.lineTo(pedX + 4, pedY + 2);

                // Continue torso right side
                ctx.lineTo(pedX + 4, pedY + 10); // Bottom right of torso
                ctx.lineTo(pedX - 4, pedY + 10); // Bottom left of torso

                // Left side of torso up to arm connection
                ctx.lineTo(pedX - 4, pedY + 2); // Left side to arm connection

                // Left arm starts at top of torso and angles down
                ctx.lineTo(pedX - 11, pedY + 9); // Left arm bottom edge (slightly thicker)
                ctx.lineTo(pedX - 13, pedY + 4); // Left arm end (angled down from top)
                ctx.lineTo(pedX - 4, pedY - 6);

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
                var cornerRadius = 8;  // Rounded corners
                var borderWidth = 12;   // Base border width - will be thicker on oblique parts

                // Calculate triangle points for inverted triangle (proper triangle shape)
                var topLeftX = centerX - size;
                var topLeftY = centerY - size * 0.6;
                var topRightX = centerX + size;
                var topRightY = centerY - size * 0.6;
                var bottomX = centerX;
                var bottomY = centerY + size * 0.8;

                // Draw outer red triangle with rounded corners and smooth outline
                ctx.fillStyle = "#e30613";  // Red color
                ctx.strokeStyle = "#e30613";
                ctx.lineWidth = 5; // Consistent line width for smooth appearance

                // Create the complete triangle path
                ctx.beginPath();

                // Top edge (horizontal) with rounded corners
                ctx.moveTo(topLeftX + cornerRadius, topLeftY);
                ctx.lineTo(topRightX - cornerRadius, topRightY);
                ctx.quadraticCurveTo(topRightX, topRightY, topRightX - cornerRadius * 0.7, topRightY + cornerRadius * 0.7);

                // Right oblique edge to bottom point
                ctx.lineTo(bottomX + cornerRadius * 0.7, bottomY - cornerRadius * 0.7);
                ctx.quadraticCurveTo(bottomX, bottomY, bottomX - cornerRadius * 0.7, bottomY - cornerRadius * 0.7);


                ctx.lineTo(topLeftX + cornerRadius * 0.7, topLeftY + cornerRadius * 0.7);
                ctx.quadraticCurveTo(topLeftX, topLeftY, topLeftX + cornerRadius, topLeftY);

                ctx.closePath();

                // Fill and stroke in one operation for smooth appearance
                ctx.fill();
                ctx.stroke();


                var innerBorderWidth = 14;
                var innerSize = size - innerBorderWidth;
                var innerTopLeftX = centerX - innerSize;
                var innerTopLeftY = centerY - innerSize * 0.6;
                var innerTopRightX = centerX + innerSize;
                var innerTopRightY = centerY - innerSize * 0.6;
                var innerBottomX = centerX;
                var innerBottomY = centerY + innerSize * 0.8;
                var innerCornerRadius = cornerRadius - 2;

                ctx.fillStyle = "white";
                ctx.strokeStyle = "white";
                ctx.lineWidth = 0;

                ctx.beginPath();

                // Inner white triangle with rounded corners
                ctx.moveTo(innerTopLeftX + innerCornerRadius, innerTopLeftY);
                ctx.lineTo(innerTopRightX - innerCornerRadius, innerTopRightY);
                ctx.quadraticCurveTo(innerTopRightX, innerTopRightY, innerTopRightX - innerCornerRadius * 0.7, innerTopRightY + innerCornerRadius * 0.7);

                // Right oblique edge to bottom point
                ctx.lineTo(innerBottomX + innerCornerRadius * 0.7, innerBottomY - innerCornerRadius * 0.7);
                ctx.quadraticCurveTo(innerBottomX, innerBottomY, innerBottomX - innerCornerRadius * 0.7, innerBottomY - innerCornerRadius * 0.7);


                ctx.lineTo(innerTopLeftX + innerCornerRadius * 0.7, innerTopLeftY + innerCornerRadius * 0.7);
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
