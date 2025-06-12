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
            font.pixelSize: 16
            color: "#5a6580"
            font.letterSpacing: 2
        }

        Text {
            id: valueText
            anchors.right: parent.right
            text: value.toString() + " km"
            font.family: "Roboto Mono, Consolas, monospace"
            font.pixelSize: 26
            color: "#ffffff"
            font.bold: true
        }
    }
}
