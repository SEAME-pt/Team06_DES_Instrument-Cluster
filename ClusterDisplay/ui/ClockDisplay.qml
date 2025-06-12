import QtQuick 6.4

Item {
    id: clockDisplay
    width: 200
    height: 60

    property string currentTime: clusterModel.currentTime

    Column {
        anchors.right: parent.right
        spacing: 5

        Text {
            anchors.right: parent.right
            text: "TIME"
            font.pixelSize: 16
            color: "#5a6580"
            font.letterSpacing: 2
        }

        Text {
            anchors.right: parent.right
            text: currentTime
            font.family: "Roboto Mono, Consolas, monospace"
            font.pixelSize: 26
            color: "#ffffff"
            font.bold: true
        }
    }
}
