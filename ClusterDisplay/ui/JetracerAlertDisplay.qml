import QtQuick 6.4

Item {
    id: jetracerAlertDisplay
    width: 300
    height: 200

    // Properties
    property int speed: 0                // Speed value (km/h) controlling animation speed
    property bool objectAlertActive: false // Object detection alert
    property bool laneAlertActive: false   // Lane departure alert
    property string laneDeviationSide: "left" // Which side the lane deviation is on ("left" or "right")

    // Use actual speed directly without stopping for objects
    property int _effectiveSpeed: speed

    // Road lines (central perspective) - no background, larger and lower on screen
    Canvas {
        id: roadLines
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: parent.top
            margins: 20  // Add margins to prevent reaching borders
            // Move the entire road view higher up
            bottomMargin: 40  // Increased bottom margin to move everything up
        }

        // Road animation progress (0.0 to 1.0)
        property real progress: 0.0

        onProgressChanged: {
            requestPaint()
        }

        // Force repaint when alerts change
        Connections {
            target: jetracerAlertDisplay
            function onObjectAlertActiveChanged() {
                roadLines.requestPaint();
            }
            function onLaneAlertActiveChanged() {
                roadLines.requestPaint();
            }
            function onLaneDeviationSideChanged() {
                roadLines.requestPaint();
            }
        }

        onPaint: {
            var ctx = getContext("2d")
            var centerX = width / 2
            var startY = 0 // Lines start from top
            var endY = height * 0.9 // Lines end near bottom (leave space for car)

            // Clear canvas
            ctx.clearRect(0, 0, width, height)

            // Draw obstacle when object alert is active - draw this first so it's behind the lines
            if (objectAlertActive) {
                // Create a position for the obstacle in front of the car - higher up and thinner
                var obstacleWidth = width * 0.20;  // Thinner width
                var obstacleHeight = height * 0.12; // Slightly shorter
                var obstacleX = centerX - obstacleWidth / 2;
                var obstacleY = height * 0.02; // Position it even higher up
                var cornerRadius = 5; // Radius for rounded corners

                // Create gradient for 3D effect
                var gradient = ctx.createLinearGradient(obstacleX, obstacleY,
                                                      obstacleX + obstacleWidth, obstacleY + obstacleHeight);
                gradient.addColorStop(0, "#F44336"); // Red
                gradient.addColorStop(0.5, "#D32F2F"); // Darker red
                gradient.addColorStop(1, "#B71C1C"); // Even darker red
                ctx.fillStyle = gradient;

                // Add shadow
                ctx.shadowColor = "rgba(0, 0, 0, 0.5)";
                ctx.shadowBlur = 10;
                ctx.shadowOffsetX = 5;
                ctx.shadowOffsetY = 5;

                // Draw the main obstacle shape with rounded corners using standard path methods
                ctx.beginPath();
                // Start from top-left corner and draw clockwise
                ctx.moveTo(obstacleX + cornerRadius, obstacleY); // Top-left with corner radius
                ctx.lineTo(obstacleX + obstacleWidth - cornerRadius, obstacleY); // Top edge
                ctx.arcTo(obstacleX + obstacleWidth, obstacleY,
                          obstacleX + obstacleWidth, obstacleY + cornerRadius,
                          cornerRadius); // Top-right corner
                ctx.lineTo(obstacleX + obstacleWidth, obstacleY + obstacleHeight - cornerRadius); // Right edge
                ctx.arcTo(obstacleX + obstacleWidth, obstacleY + obstacleHeight,
                          obstacleX + obstacleWidth - cornerRadius, obstacleY + obstacleHeight,
                          cornerRadius); // Bottom-right corner
                ctx.lineTo(obstacleX + cornerRadius, obstacleY + obstacleHeight); // Bottom edge
                ctx.arcTo(obstacleX, obstacleY + obstacleHeight,
                          obstacleX, obstacleY + obstacleHeight - cornerRadius,
                          cornerRadius); // Bottom-left corner
                ctx.lineTo(obstacleX, obstacleY + cornerRadius); // Left edge
                ctx.arcTo(obstacleX, obstacleY,
                          obstacleX + cornerRadius, obstacleY,
                          cornerRadius); // Top-left corner
                ctx.closePath();
                ctx.fill();

                // Add highlight for 3D effect
                ctx.shadowColor = "transparent";
                ctx.shadowBlur = 0;
                ctx.shadowOffsetX = 0;
                ctx.shadowOffsetY = 0;

                ctx.strokeStyle = "rgba(255, 255, 255, 0.5)";
                ctx.lineWidth = 2;
                ctx.beginPath();
                ctx.moveTo(obstacleX + 5, obstacleY + 5);
                ctx.lineTo(obstacleX + obstacleWidth - 5, obstacleY + 5);
                ctx.stroke();
            }

            // Draw road lines
            ctx.lineWidth = 4  // Thicker lines
            ctx.shadowColor = "transparent";

            // Left lane marking - narrower spacing
            var leftStart = centerX - width * 0.10  // Narrower at top
            var leftEnd = centerX - width * 0.25    // Narrower at bottom

            // Set color based on lane deviation (red if deviating to the left)
            ctx.strokeStyle = (laneAlertActive && laneDeviationSide === "left") ? "#FF4444" : "white";
            drawRoadLine(ctx, leftStart, leftEnd, startY, endY, progress)

            // Right lane marking - narrower spacing
            var rightStart = centerX + width * 0.10  // Narrower at top
            var rightEnd = centerX + width * 0.25    // Narrower at bottom

            // Set color based on lane deviation (red if deviating to the right)
            ctx.strokeStyle = (laneAlertActive && laneDeviationSide === "right") ? "#FF4444" : "white";
            drawRoadLine(ctx, rightStart, rightEnd, startY, endY, progress)
        }

        // Function to draw a perspective road line with moving animation
        function drawRoadLine(ctx, startX, endX, startY, endY, progress) {
            // Number of dashes in the line
            var numDashes = 10;  // Slightly fewer for cleaner look
            var dashGap = 1.0 / numDashes;

            for (var i = 0; i < numDashes; i++) {
                // Calculate position based on dash index and animation progress
                // Lines move away from the viewer (car moving forward)
                var t = (i / numDashes + progress) % 1.0;

                // Skip if dash is not in visible range
                if (t < 0 || t > 1.0) continue;

                // Calculate x position with perspective (narrow at top, wide at bottom)
                var x = startX + (endX - startX) * t;

                // Calculate y position (top to bottom)
                var y = startY + (endY - startY) * t;

                // Calculate next point for the dash
                var nextT = t + (dashGap * 0.7); // 70% of gap is dash, 30% is space
                if (nextT > 1.0) continue;

                var nextX = startX + (endX - startX) * nextT;
                var nextY = startY + (endY - startY) * nextT;

                // Adjust line width for perspective (thinner at top, thicker at bottom)
                var lineWidth = 2 + (6 * t);
                ctx.lineWidth = lineWidth;

                // Draw the dash
                ctx.beginPath();
                ctx.moveTo(x, y);
                ctx.lineTo(nextX, nextY);
                ctx.stroke();
            }
        }

        // Timer to manually control the animation progress - faster update rate
        Timer {
            id: animationTimer
            interval: 30 // Update rate in ms (reduced from 50 for smoother animation)
            running: jetracerAlertDisplay._effectiveSpeed > 0
            repeat: true
            onTriggered: {
                // Calculate how much progress to add based on speed and time
                var timeDelta = interval / 1000.0; // Time in seconds
                // Adjusted speed factor for 9km/h top speed - reduced from 200.0 to 25.0 for much faster movement
                var progressDelta = (jetracerAlertDisplay._effectiveSpeed / 25.0) * timeDelta;
                roadLines.progress = (roadLines.progress + progressDelta) % 1.0;
            }
        }

        // When speed becomes 0, reset the progress
        Connections {
            target: jetracerAlertDisplay
            function onSpeedChanged() {
                if (jetracerAlertDisplay._effectiveSpeed === 0) {
                    // Stop the timer and reset progress
                    animationTimer.running = false;
                    roadLines.progress = 0.0;
                    roadLines.requestPaint(); // Ensure it redraws in the stopped state
                } else {
                    animationTimer.running = true;
                }
            }
        }
    }

    // Jetracer car - more detailed and futuristic design
    Canvas {
        id: jetracerCanvas
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 60 // Reduced from 70 to position car lower
        }
        width: 60  // 20% bigger: 50 * 1.2 = 60
        height: 108  // 20% bigger: 90 * 1.2 = 108

        // Add lateral movement for lane deviation warning - increased movement amount to touch lines
        transform: Translate {
            x: laneAlertActive ?
               (laneDeviationSide === "left" ? -25 : 25) : 0  // Increased from 25 to 40 to touch lane lines

            Behavior on x {
                NumberAnimation { duration: 300; easing.type: Easing.OutQuad }
            }
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            // Car Body - shorter front with squared front and rounded transitions
            var bodyGradient = ctx.createLinearGradient(0, 0, width, 0);
            bodyGradient.addColorStop(0, "#2E8B57"); // Sea Green
            bodyGradient.addColorStop(0.5, "#3CB371"); // Medium Sea Green
            bodyGradient.addColorStop(1, "#2E8B57");
            ctx.fillStyle = bodyGradient;

            ctx.beginPath();
            // Start at bottom left
            ctx.moveTo(width * 0.2, height);
            // Curved left side up to shoulder
            ctx.quadraticCurveTo(width * 0.15, height * 0.6, width * 0.25, height * 0.45);
            // Rounded transition to squared front - left corner (wider and shorter front)
            ctx.quadraticCurveTo(width * 0.3, height * 0.35, width * 0.35, height * 0.3);
            // Squared front top edge (wider and shorter)
            ctx.lineTo(width * 0.65, height * 0.3);
            // Rounded transition to squared front - right corner (wider and shorter front)
            ctx.quadraticCurveTo(width * 0.7, height * 0.35, width * 0.75, height * 0.45);
            // Curved right side down
            ctx.quadraticCurveTo(width * 0.85, height * 0.6, width * 0.8, height);
            // Close path back to start
            ctx.closePath();
            ctx.fill();

            // Add shadow to car for 3D effect
            ctx.shadowColor = "rgba(0, 0, 0, 0.5)";
            ctx.shadowBlur = 15;
            ctx.shadowOffsetX = 0;
            ctx.shadowOffsetY = 5;

            // Cockpit/Glass - positioned lower between the wheels
            var cockpitGradient = ctx.createLinearGradient(0, height * 0.45, 0, height * 0.75);
            cockpitGradient.addColorStop(0, "rgba(173, 216, 230, 0.7)"); // Light Blue, semi-transparent
            cockpitGradient.addColorStop(1, "rgba(0, 0, 139, 0.6)"); // Dark Blue, semi-transparent
            ctx.fillStyle = cockpitGradient;

            ctx.beginPath();
            // Cockpit positioned between front wheels (height-50) and rear wheels (height-18)
            ctx.moveTo(width * 0.35, height * 0.75);
            ctx.quadraticCurveTo(width * 0.5, height * 0.55, width * 0.65, height * 0.75);
            ctx.quadraticCurveTo(width * 0.5, height * 0.85, width * 0.35, height * 0.75);
            ctx.closePath();
            ctx.fill();

            // Reset shadow
            ctx.shadowColor = "transparent";
            ctx.shadowBlur = 0;
            ctx.shadowOffsetX = 0;
            ctx.shadowOffsetY = 0;

            // Wheels - scaled up 20% for larger 60x108 car size
            ctx.fillStyle = "black";
            // Rear wheels - 20% bigger and proportionally positioned
            ctx.fillRect(4, height - 22, 8, 17);        // Left rear wheel (20% bigger)
            ctx.fillRect(width - 12, height - 22, 8, 17); // Right rear wheel (20% bigger)
            // Front wheels - 20% bigger and proportionally positioned
            ctx.fillRect(10, height - 60, 6, 14);       // Left front wheel (20% bigger)
            ctx.fillRect(width - 16, height - 60, 6, 14); // Right front wheel (20% bigger)

            // Draw lane warning indicators when lane alert is active
            if (laneAlertActive) {
                ctx.fillStyle = "#FFEB3B"; // Yellow warning color

                // Draw arrow indicating direction of drift
                ctx.beginPath();
                if (laneDeviationSide === "left") {
                    // Left arrow on right side
                    ctx.moveTo(width - 10, height * 0.4);
                    ctx.lineTo(width - 30, height * 0.35);
                    ctx.lineTo(width - 10, height * 0.3);
                } else {
                    // Right arrow on left side
                    ctx.moveTo(10, height * 0.4);
                    ctx.lineTo(30, height * 0.35);
                    ctx.lineTo(10, height * 0.3);
                }
                ctx.closePath();
                ctx.fill();

                // Add pulsing glow around the car to indicate danger
                var glowColor = laneDeviationSide === "left" ? "rgba(255, 0, 0, 0.3)" : "rgba(255, 0, 0, 0.3)";
                ctx.fillStyle = glowColor;
                ctx.beginPath();
                if (laneDeviationSide === "left") {
                    // Left side glow
                    ctx.ellipse(-20, height/2, 30, height/2, 0, 0, 2 * Math.PI);
                } else {
                    // Right side glow
                    ctx.ellipse(width + 20, height/2, 30, height/2, 0, 0, 2 * Math.PI);
                }
                ctx.fill();
            }
        }
    }
}
