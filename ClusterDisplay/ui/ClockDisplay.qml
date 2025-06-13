import QtQuick 6.4

Item {
    id: clockDisplay
    width: 200
    height: 60

    property string currentTime: clusterModel.currentTime

    Column {
        anchors.left: parent.left
        spacing: 5

        Text {
            anchors.left: parent.left
            text: "TIME"
            font.pixelSize: 18
            color: "#5a6580"
            font.letterSpacing: window.letterSpacingWide
            font.family: window.secondaryFont
        }

        Text {
            anchors.left: parent.left
            text: currentTime
            font.family: window.monoFont
            font.pixelSize: 30
            color: "#ffffff"
            font.bold: true
            font.letterSpacing: window.letterSpacingTight
        }
    }
}
