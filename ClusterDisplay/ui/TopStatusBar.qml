import QtQuick 6.4

Rectangle {
    id: statusBar
    color: "#1a1a1a"
    border.color: "#333333"
    border.width: 1

    // Time display
    ModernTimeDisplay {
        id: timeDisplay
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 30
    }

    // Connection status indicators
    Row {
        anchors.centerIn: parent
        spacing: 40

        // GPS Status
        Item {
            width: 60
            height: 40
            Rectangle {
                width: 20
                height: 20
                radius: 10
                color: "#00ff88"
                border.color: "#ffffff"
                border.width: 1
                anchors.centerIn: parent
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                text: "GPS"
                color: "#888888"
                font.pixelSize: 10
            }
        }

        // Bluetooth Status
        Item {
            width: 60
            height: 40
            Rectangle {
                width: 20
                height: 20
                radius: 10
                color: "#00d4ff"
                border.color: "#ffffff"
                border.width: 1
                anchors.centerIn: parent
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                text: "BT"
                color: "#888888"
                font.pixelSize: 10
            }
        }

        // WiFi Status
        Item {
            width: 60
            height: 40
            Rectangle {
                width: 20
                height: 20
                radius: 10
                color: "#ffaa00"
                border.color: "#ffffff"
                border.width: 1
                anchors.centerIn: parent
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                text: "WiFi"
                color: "#888888"
                font.pixelSize: 10
            }
        }
    }

    // Brand/Model area
    Text {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 30
        text: "AUTOMOTIVE CLUSTER"
        color: "#00d4ff"
        font.pixelSize: 16
        font.bold: true
    }
}
