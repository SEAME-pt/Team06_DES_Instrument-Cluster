import QtQuick 2.15

Item {
    id: root
    width: 200
    height: 50

    property var currentTime: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: currentTime = new Date()
    }

    Rectangle {
        anchors.fill: parent
        color: "#1a1a1a"
        border.width: 1
        border.color: "#00d4ff"
        radius: 8

        Column {
            anchors.centerIn: parent
            spacing: -2

            // Time
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Qt.formatDateTime(currentTime, "hh:mm:ss")
                color: "#ffffff"
                font.family: "Arial"
                font.pixelSize: 20
                font.bold: true
            }

            // Date
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Qt.formatDateTime(currentTime, "dd MMM yyyy")
                color: "#888888"
                font.family: "Arial"
                font.pixelSize: 12
            }
        }

        // Subtle glow
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.width: 1
            border.color: "#00d4ff"
            radius: 8
            opacity: 0.3
        }
    }
}
