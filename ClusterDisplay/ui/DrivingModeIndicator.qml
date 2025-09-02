import QtQuick 6.4

Item {
    id: drivingModeIndicator
    width: 180
    height: 60

    property string mode: clusterModel.drivingMode

    // Mode colors for different driving modes
    property var modeColors: {
        "AUTO": "#00d4ff",
        "MAN": "#5a6580"
    }

    // Get current color based on mode
    property color currentColor: modeColors[mode] || modeColors["MAN"]
    property string displayMode: mode || "MAN"

    Column {
        anchors.right: parent.right
        spacing: 5

        Text {
            anchors.right: parent.right
            text: "MODE"
            font.pixelSize: 18
            color: "#5a6580"
            font.letterSpacing: window.letterSpacingWide
            font.family: window.secondaryFont
        }

        Text {
            anchors.right: parent.right
            text: displayMode
            font.pixelSize: 26
            font.weight: window.fontBold
            font.letterSpacing: window.letterSpacingWide
            color: "#ffffff"
            opacity: 1.0
            font.family: window.primaryFont
        }
    }
}
