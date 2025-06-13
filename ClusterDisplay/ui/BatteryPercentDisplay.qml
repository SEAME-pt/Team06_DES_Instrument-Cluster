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
    property bool _isLowActual: batteryPercent < 10.0 // Internal calculation of low status (changed from 20 to 10)
    property bool _displayLowWarning: _isLowActual || isLowBattery // Either actual or forced low

    // Calculate battery color based on level with updated lighter color scheme
    property color batteryColor: {
        if (batteryPercent > 80) return "#90EE90"; // Light Green for 80-100%
        if (batteryPercent > 50) return "#C1FFC1"; // Lighter Green for 50-80%
        if (batteryPercent > 25) return "#FFFFE0"; // Light Yellow for 25-50%
        if (batteryPercent > 10) return "#FFDAB9"; // Light Orange for 10-25%
        return "#FFC0CB"; // Light Red for 0-10%
    }

    // Light blue color for charging animation
    property color chargingColor: "#ADD8E6" // Light Blue

    // Timer to cycle battery percentage
    Timer {
        id: batteryUpdateTimer
        interval: 3000 // Update every 3 seconds
        running: true
        repeat: true
        onTriggered: {
            // Cycle through different battery percentages - 0 to 100
            batteryPercent = (batteryPercent + 5) % 105
            if (batteryPercent > 100) batteryPercent = 0 // Reset to 0

            // Randomly toggle charging state for demo
            if (Math.random() > 0.9) {
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
