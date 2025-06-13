import QtQuick 6.4

Item {
    id: streetSignDisplay
    width: 220
    height: 220

    property string signType: "SPEED_LIMIT"  // Demo property for sign type
    property int signValue: 50               // Demo speed limit value

    // Visibility property to toggle demo
    property bool signVisible: true

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
            font.pixelSize: 80
            font.bold: true
            color: "black"
        }
    }

    // Demo animation to mimic sign recognition
    SequentialAnimation {
        running: true
        loops: Animation.Infinite

        // Wait time between sign appearances
        PauseAnimation { duration: 8000 }

        // Fade in
        PropertyAnimation {
            target: streetSignDisplay
            property: "opacity"
            from: 0.0
            to: 1.0
            duration: 500
        }

        // Display time - extended significantly
        PauseAnimation { duration: 12000 }

        // Fade out
        PropertyAnimation {
            target: streetSignDisplay
            property: "opacity"
            from: 1.0
            to: 0.0
            duration: 500
        }
    }
}
