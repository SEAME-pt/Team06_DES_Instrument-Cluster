import QtQuick 6.4

Item {
    id: drivingModeIndicator
    width: 180
    height: 80

    property string mode: clusterModel.drivingMode

    // Display text mapping for different modes
    property var modeTextMap: {
        "ECO": "AUTONOMOUS",
        "NORMAL": "AUTONOMOUS",
        "SPORT": "MANUAL",
        "OFF": "MANUAL"
    }

    // Mode colors for different driving modes
    property var modeColors: {
        "ECO": "#00c293",
        "NORMAL": "#00d4ff",
        "SPORT": "#ff527a",
        "OFF": "#5a6580"
    }

    // Get current color based on mode
    property color currentColor: modeColors[mode] || modeColors["OFF"]
    property string displayMode: modeTextMap[mode] || "MANUAL"

    Column {
        anchors {
            centerIn: parent
        }
        spacing: 10

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "MODE"
            font.pixelSize: 16
            color: "#5a6580"
            font.letterSpacing: 2
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: displayMode
            font.pixelSize: 28
            font.bold: true
            font.letterSpacing: 2
            color: "#ffffff"
            opacity: 1.0
        }
    }
}
