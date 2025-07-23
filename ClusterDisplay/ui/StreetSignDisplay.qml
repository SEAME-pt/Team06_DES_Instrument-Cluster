import QtQuick 6.4

Item {
    id: streetSignDisplay
    width: 220
    height: 220

    property string signType: "SPEED_LIMIT"  // Type of sign (keeping for possible future expansion)
    property int signValue: clusterModel.speedLimitSignal  // Speed limit value from ClusterModel
    property bool signVisible: clusterModel.speedLimitVisible  // Visibility controlled by ClusterModel

    // Sign is only visible when signVisible is true
    visible: signVisible

    // The circular speed limit sign
    Rectangle {
        id: signCircle
        anchors.centerIn: parent
        width: 180
        height: 180
        radius: width/2
        color: "white"
        border {
            width: 12
            color: "red"
        }

        // Red border ring
        Rectangle {
            anchors.centerIn: parent
            width: parent.width - 8
            height: parent.height - 8
            radius: width/2
            color: "transparent"
            border {
                width: 3
                color: "red"
            }
        }

        // Speed limit text
        Text {
            anchors.centerIn: parent
            text: signValue
            font.pixelSize: 70
            font.bold: true
            color: "black"
        }
    }

    // Fade in/out animation when sign visibility changes
    Behavior on opacity {
        NumberAnimation {
            duration: 500
            easing.type: Easing.InOutQuad
        }
    }

    // Opacity is controlled by visibility
    opacity: signVisible ? 1.0 : 0.0
}
