import QtQuick 6.4

Item {
    id: batteryPercentDisplay
    width: 150
    height: 60

    // Properties
    property real batteryPercent: 75.0  // Battery percentage (0-100)
    property bool isCharging: false      // Charging status
    property bool isLowBattery: false    // Low battery status (automatically set when < 20%)

    // Computed properties
    property bool _isLowActual: batteryPercent < 20.0 // Internal calculation of low status
    property bool _displayLowWarning: _isLowActual || isLowBattery // Either actual or forced low

    // Calculate battery color based on level with updated color scheme
    property color batteryColor: {
        if (batteryPercent > 50) return "#4CAF50"; // Green for 50-100%
        if (batteryPercent > 25) return "#FFEB3B"; // Yellow for 25-50%
        if (batteryPercent > 10) return "#FF9800"; // Orange for 10-25%
        return "#F44336"; // Red for 0-10%
    }

    // Light blue color for charging animation
    property color chargingColor: "#87CEEB" // Light Blue

    // Timer to cycle battery percentage
    Timer {
        id: batteryUpdateTimer
        interval: 3000 // Update every 3 seconds
        running: true
        repeat: true
        onTriggered: {
            // Cycle through different battery percentages - low to high
            batteryPercent = (batteryPercent + 10) % 110
            if (batteryPercent > 100) batteryPercent = 10 // Reset to low

            // Randomly toggle charging state for demo
            if (Math.random() > 0.7) {
                isCharging = !isCharging
            }
        }
    }

    Column {
        anchors.fill: parent
        spacing: 5

        // Title
        Text {
            anchors.left: parent.left  // Align to left like time
            text: "BATTERY"
            font.pixelSize: 18
            color: "#5a6580"
            font.letterSpacing: window.letterSpacingWide
            font.family: window.secondaryFont
        }

        // Battery percentage text
        Text {
            id: batteryText
            anchors.left: parent.left  // Align to left like time
            text: batteryPercent.toFixed(0) + "%"
            font.pixelSize: 32
            font.weight: window.fontBold
            color: "#ffffff"
            font.family: window.monoFont
            font.letterSpacing: window.letterSpacingTight

            // Charging indicator
            Text {
                id: chargingIndicator
                visible: isCharging
                text: "⚡"
                color: chargingColor
                font.pixelSize: 22
                anchors {
                    left: parent.right
                    leftMargin: 5
                    verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
