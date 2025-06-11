import QtQuick 6.4

Rectangle {
    id: bottomBar
    color: "#1a1a1a"
    border.color: "#333333"
    border.width: 1

    Row {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 40

        // Trip information
        Column {
            width: parent.width * 0.25
            height: parent.height
            spacing: 10

            Text {
                text: "TRIP A"
                color: "#888888"
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: "245.8 km"
                color: "#ffffff"
                font.pixelSize: 18
                font.bold: true
            }

            Text {
                text: "TRIP B"
                color: "#888888"
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: "1,234.5 km"
                color: "#ffffff"
                font.pixelSize: 18
                font.bold: true
            }
        }

        // Energy efficiency
        Column {
            width: parent.width * 0.25
            height: parent.height
            spacing: 10

            Text {
                text: "EFFICIENCY"
                color: "#888888"
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: "6.8 L/100km"
                color: "#00ff88"
                font.pixelSize: 18
                font.bold: true
            }

            Text {
                text: "AVG SPEED"
                color: "#888888"
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: "67 km/h"
                color: "#ffffff"
                font.pixelSize: 18
                font.bold: true
            }
        }

        // Range and temperature
        Column {
            width: parent.width * 0.25
            height: parent.height
            spacing: 10

            Text {
                text: "RANGE"
                color: "#888888"
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: "420 km"
                color: "#00d4ff"
                font.pixelSize: 18
                font.bold: true
            }

            Text {
                text: "OUTSIDE TEMP"
                color: "#888888"
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: "22°C"
                color: "#ffffff"
                font.pixelSize: 18
                font.bold: true
            }
        }

        // Driving mode
        Column {
            width: parent.width * 0.25
            height: parent.height
            spacing: 10

            Text {
                text: "DRIVE MODE"
                color: "#888888"
                font.pixelSize: 12
                font.bold: true
            }

            Rectangle {
                width: 100
                height: 30
                radius: 15
                color: "#00ff88"
                border.color: "#ffffff"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "ECO"
                    color: "#000000"
                    font.pixelSize: 14
                    font.bold: true
                }
            }
        }
    }
}
