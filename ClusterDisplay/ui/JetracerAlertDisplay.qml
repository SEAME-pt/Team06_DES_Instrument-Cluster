import QtQuick 6.4

Item {
    id: jetracerAlertDisplay
    width: 300
    height: 200

    // Properties
    property int speed: 0                // Speed value (km/h) controlling animation speed

    // Calculate animation speed based on vehicle speed - more realistic curve but faster overall
    property real animationSpeed: speed > 0 ? 5000 / (1 + speed) : 0

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

        onPaint: {
            var ctx = getContext("2d")
            var centerX = width / 2
            var startY = 0 // Lines start from top
            var endY = height * 0.9 // Lines end near bottom (leave space for car)

            // Clear canvas
            ctx.clearRect(0, 0, width, height)

            // Draw road lines
            ctx.lineWidth = 4  // Thicker lines
            ctx.strokeStyle = "white"

            // Left lane marking - wider spacing
            var leftStart = centerX - width * 0.15  // Narrow at top
            var leftEnd = centerX - width * 0.4    // Wide at bottom
            drawRoadLine(ctx, leftStart, leftEnd, startY, endY, progress)

            // Right lane marking - wider spacing
            var rightStart = centerX + width * 0.15  // Narrow at top
            var rightEnd = centerX + width * 0.4     // Wide at bottom
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
            running: jetracerAlertDisplay.speed > 0
            repeat: true
            onTriggered: {
                // Calculate how much progress to add based on speed and time
                var timeDelta = interval / 1000.0; // Time in seconds
                // Increased speed factor from 500.0 to 200.0 for faster movement
                var progressDelta = (jetracerAlertDisplay.speed / 200.0) * timeDelta;
                roadLines.progress = (roadLines.progress + progressDelta) % 1.0;
            }
        }

        // When speed becomes 0, reset the progress
        Connections {
            target: jetracerAlertDisplay
            function onSpeedChanged() {
                if (jetracerAlertDisplay.speed === 0) {
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
            bottomMargin: 70 // Increased from 50 to raise the car higher
        }
        width: 100
        height: 180

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            // Car Body
            var bodyGradient = ctx.createLinearGradient(0, 0, width, 0);
            bodyGradient.addColorStop(0, "#2E8B57"); // Sea Green
            bodyGradient.addColorStop(0.5, "#3CB371"); // Medium Sea Green
            bodyGradient.addColorStop(1, "#2E8B57");
            ctx.fillStyle = bodyGradient;

            ctx.beginPath();
            ctx.moveTo(width * 0.2, height);
            ctx.quadraticCurveTo(width * 0.1, height * 0.6, width * 0.3, height * 0.2);
            ctx.quadraticCurveTo(width * 0.5, 0, width * 0.7, height * 0.2);
            ctx.quadraticCurveTo(width * 0.9, height * 0.6, width * 0.8, height);
            ctx.closePath();
            ctx.fill();

            // Cockpit/Glass
            var cockpitGradient = ctx.createLinearGradient(0, height * 0.2, 0, height * 0.5);
            cockpitGradient.addColorStop(0, "rgba(173, 216, 230, 0.7)"); // Light Blue, semi-transparent
            cockpitGradient.addColorStop(1, "rgba(0, 0, 139, 0.6)"); // Dark Blue, semi-transparent
            ctx.fillStyle = cockpitGradient;

            ctx.beginPath();
            ctx.moveTo(width * 0.35, height * 0.5);
            ctx.quadraticCurveTo(width * 0.5, height * 0.3, width * 0.65, height * 0.5);
            ctx.quadraticCurveTo(width * 0.5, height * 0.6, width * 0.35, height * 0.5);
            ctx.closePath();
            ctx.fill();

            // Wheels
            ctx.fillStyle = "black";
            // Rear wheels
            ctx.fillRect(5, height - 40, 15, 30);
            ctx.fillRect(width - 20, height - 40, 15, 30);
            // Front wheels
            ctx.fillRect(15, height - 120, 10, 25);
            ctx.fillRect(width - 25, height - 120, 10, 25);
        }
    }
}
