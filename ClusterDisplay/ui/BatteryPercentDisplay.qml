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
    property bool _isLowActual: batteryPercent < 10.0
    property bool _displayLowWarning: _isLowActual || isLowBattery
    property color batteryColor: {
        if (batteryPercent > 80) return "#90EE90";
        if (batteryPercent > 50) return "#C1FFC1";
        if (batteryPercent > 25) return "#FFFACD";
        if (batteryPercent > 10) return "#FFDAB9";
        return "#FFC0CB";
    }

    property color chargingColor: "#B3E5FC"

    Column {
        anchors.fill: parent
        spacing: 5

        Text {
            anchors.left: parent.left
            text: "BATTERY"
            font.pixelSize: 18
            color: "#5a6580"
            font.letterSpacing: window.letterSpacingWide
            font.family: window.secondaryFont
        }

        Text {
            id: batteryText
            anchors.left: parent.left
            text: batteryPercent.toFixed(0) + "%"
            font.pixelSize: 32
            font.weight: window.fontBold
            color: "#ffffff"
            font.family: window.monoFont
            font.letterSpacing: window.letterSpacingTight


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
