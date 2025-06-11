import QtQuick 6.4

Item {
    id: centerPanel

    Column {
        anchors.centerIn: parent
        spacing: 20

        // Gear position display
        Rectangle {
            width: 120
            height: 80
            radius: 10
            color: "#1a1a1a"
            border.color: "#00d4ff"
            border.width: 2
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                anchors.centerIn: parent
                text: "D"
                color: "#00d4ff"
                font.pixelSize: 48
                font.bold: true
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                text: "DRIVE"
                color: "#888888"
                font.pixelSize: 12
            }
        }

        // Turn signals
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 40

            // Left turn signal
            Rectangle {
                width: 30
                height: 20
                radius: 5
                color: "#ffaa00"
                opacity: 0.3

                Text {
                    anchors.centerIn: parent
                    text: "◀"
                    color: "#ffffff"
                    font.pixelSize: 16
                }
            }

            // Right turn signal
            Rectangle {
                width: 30
                height: 20
                radius: 5
                color: "#ffaa00"
                opacity: 0.3

                Text {
                    anchors.centerIn: parent
                    text: "▶"
                    color: "#ffffff"
                    font.pixelSize: 16
                }
            }
        }

        // Warning lights
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 15

            // Engine warning
            Rectangle {
                width: 25
                height: 25
                radius: 12
                color: "#ff4444"
                opacity: 0.3

                Text {
                    anchors.centerIn: parent
                    text: "⚠"
                    color: "#ffffff"
                    font.pixelSize: 14
                }
            }

            // Oil pressure
            Rectangle {
                width: 25
                height: 25
                radius: 12
                color: "#ffaa00"
                opacity: 0.3

                Text {
                    anchors.centerIn: parent
                    text: "🛢"
                    color: "#ffffff"
                    font.pixelSize: 12
                }
            }

            // Temperature
            Rectangle {
                width: 25
                height: 25
                radius: 12
                color: "#ff4444"
                opacity: 0.3

                Text {
                    anchors.centerIn: parent
                    text: "🌡"
                    color: "#ffffff"
                    font.pixelSize: 12
                }
            }
        }

        // Odometer
        Rectangle {
            width: 140
            height: 40
            radius: 8
            color: "#2a2a2a"
            border.color: "#555555"
            border.width: 1
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                anchors.centerIn: parent
                text: "123,456 km"
                color: "#ffffff"
                font.pixelSize: 16
                font.bold: true
            }
        }
    }
}
