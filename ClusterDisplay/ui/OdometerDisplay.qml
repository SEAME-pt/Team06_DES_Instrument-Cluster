import QtQuick 6.4

Item {
    id: odometerDisplay
    width: 200
    height: 60

    property int value: clusterModel.odometer

    Column {
        anchors.right: parent.right
        spacing: 5

        Text {
            anchors.right: parent.right
            text: "ODOMETER"
            font.pixelSize: 18
            color: "#5a6580"
            font.letterSpacing: window.letterSpacingWide
            font.family: window.secondaryFont
        }

        Text {
            id: valueText
            anchors.right: parent.right
            text: value.toString() + " m"
            font.family: window.monoFont
            font.pixelSize: 30
            color: "#ffffff"
            font.bold: true
            font.letterSpacing: window.letterSpacingTight
        }
    }
}
