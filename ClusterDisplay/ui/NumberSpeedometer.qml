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

        // Dynamic color based on speed
        property color speedColor: {
            if (speed < 30) return "#00c293"  // Green for low speed
            if (speed < 70) return "#00d4ff"  // Cyan for medium
            return "#ff527a"                  // Pink-red for high speed
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
                font.pixelSize: 105  // Reduced from 140 to 75% size
                font.family: window.primaryFont
                font.weight: window.fontNormal
                font.letterSpacing: window.letterSpacingTight
            }

            // Units label
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "km/h"
                color: "#5a6580"
                font.pixelSize: 15  // Reduced from 20 to 75% size
                font.letterSpacing: window.letterSpacingWide
                font.family: window.secondaryFont
            }
        }
    }
}
