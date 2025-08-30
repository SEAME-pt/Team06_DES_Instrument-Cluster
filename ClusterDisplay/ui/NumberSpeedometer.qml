import QtQuick 6.4

Item {
    id: speedometer
    width: 400
    height: 400

    property int speed: clusterModel.speed

    Item {
        id: speedDisplayContainer
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: parent.height * 0.8

        property color speedColor: {
            if (speed < 300) return "#00c293"
            if (speed < 700) return "#00d4ff"
            return "#ff527a"
        }

        // Digital speed display
        Column {
            anchors.centerIn: parent
            spacing: 5

            // Main speed value
            Text {
                id: speedValue
                anchors.horizontalCenter: parent.horizontalCenter
                text: speed.toString()
                color: "#ffffff"
                font.pixelSize: 105
                font.family: window.primaryFont
                font.weight: window.fontNormal
                font.letterSpacing: window.letterSpacingTight
            }

            // Units label
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "km/h (×10)"
                color: "#5a6580"
                font.pixelSize: 15
                font.letterSpacing: window.letterSpacingWide
                font.family: window.secondaryFont
            }
        }
    }
}
