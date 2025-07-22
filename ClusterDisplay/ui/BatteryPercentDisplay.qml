import QtQuick 6.4

Item {
    id: batteryPercentDisplay
    width: 150
    height: 60

    // Properties connected to ClusterModel
    property real batteryPercent: clusterModel.battery  // Battery percentage from ClusterModel
    property bool isCharging: clusterModel.charging     // Charging status from ClusterModel
    property bool isLowBattery: false    // Low battery status (automatically set when < 20%)

    // Computed properties
    property bool _isLowActual: batteryPercent < 10.0 // Internal calculation of low status (changed from 20 to 10)
    property bool _displayLowWarning: _isLowActual || isLowBattery // Either actual or forced low

    // Calculate battery color based on level with updated lighter color scheme
    property color batteryColor: {
        if (batteryPercent > 80) return "#90EE90"; // Light Green for 80-100%
        if (batteryPercent > 50) return "#C1FFC1"; // Lighter Green for 50-80%
        if (batteryPercent > 25) return "#FFFACD"; // Light Lemon Chiffon Yellow for 25-50%
        if (batteryPercent > 10) return "#FFDAB9"; // Light Orange for 10-25%
        return "#FFC0CB"; // Light Red for 0-10%
    }

    // Light blue color for charging animation
    property color chargingColor: "#B3E5FC" // Stronger Light Blue

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
