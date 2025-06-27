import QtQuick 6.4

Item {
    id: batteryBar
    width: 150
    height: 600

    // Battery level property directly from model
    property int batteryLevel: clusterModel.battery
    property bool isCharging: clusterModel.charging
    property bool isLowBattery: batteryLevel < 15 // Low battery threshold

    // Dynamic color based on battery level - softer colors
    property color batteryColor: {
        if (batteryLevel > 80) return "#7FD47F"      // Soft green for 81-100%
        if (batteryLevel > 65) return "#A8E0A8"      // Lighter soft green for 66-80%
        if (batteryLevel > 50) return "#E0E0A0"      // Soft yellow for 51-65%
        if (batteryLevel > 35) return "#E0C090"      // Soft orange for 36-50%
        if (batteryLevel > 20) return "#E0A090"      // Soft light red for 21-35%
        return "#E07070"                             // Soft red for 0-20%
    }

    // Expose battery color to parent components
    property color currentBatteryColor: batteryColor

    // Charging indicator text - above the bar
    Text {
        id: batteryLabel
        anchors {
            horizontalCenter: batteryContainer.horizontalCenter
            bottom: batteryContainer.top
            bottomMargin: 15
        }
        text: isCharging ? "CHARGING" : (isLowBattery ? "LOW BATTERY" : "BATTERY")
        color: isCharging ? "#ffffff" : (isLowBattery ? batteryColor : "#5a6580")
        font.pixelSize: 16
        font.letterSpacing: 2
        opacity: (isCharging || isLowBattery) ? 1.0 : 0.7

        // Animation for charging and low battery
        SequentialAnimation on opacity {
            running: isCharging || isLowBattery
            loops: Animation.Infinite
            NumberAnimation {
                to: isLowBattery ? 0.3 : 0.7
                duration: isLowBattery ? 500 : 800
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                to: 1.0
                duration: isLowBattery ? 500 : 800
                easing.type: Easing.InOutSine
            }
        }
    }

    // Modern EV battery container
    Item {
        id: batteryContainer
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: parent.height * 0.95

        // Battery background
        Rectangle {
            id: batteryBackground
            anchors.fill: parent
            radius: 10
            color: "#1a1a1a"  // Updated to grey without blue tint

            // Subtle inner shadow
            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: "transparent"
                border.width: 1
                border.color: "#101010"  // Updated to darker grey
            }
        }

        // Battery fill - fluid design
        Rectangle {
            id: batteryFill
            anchors {
                left: batteryBackground.left
                right: batteryBackground.right
                bottom: batteryBackground.bottom
                margins: 2
            }
            height: (batteryBackground.height - 4) * (batteryLevel / 100)
            radius: 8

            // Gradient fill that changes with battery level
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Qt.lighter(batteryColor, 1.2) }
                GradientStop { position: 1.0; color: batteryColor }
            }

            // Animated glow effect
            Rectangle {
                id: batteryGlow
                anchors.fill: parent
                radius: parent.radius
                color: "transparent"
                border.width: 1
                border.color: Qt.lighter(batteryColor, 1.5)
                opacity: 0.5

                // Subtle pulsing effect when charging
                SequentialAnimation on opacity {
                    running: isCharging
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.8; duration: 1000; easing.type: Easing.InOutSine }
                    NumberAnimation { to: 0.5; duration: 1000; easing.type: Easing.InOutSine }
                }
            }

            // Highlight effect on left side
            Rectangle {
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                    margins: 4
                }
                width: parent.width * 0.15
                radius: 4
                opacity: 0.3
                color: Qt.lighter(batteryColor, 1.5)
            }
        }

        // Low battery warning indicator
        Rectangle {
            id: lowBatteryWarning
            visible: isLowBattery
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.width: 3
            border.color: "#E07070"  // Soft red
            opacity: 0.8

            // Pulsing animation for low battery warning
            SequentialAnimation on opacity {
                running: isLowBattery
                loops: Animation.Infinite
                NumberAnimation { to: 0.4; duration: 500; easing.type: Easing.InOutSine }
                NumberAnimation { to: 0.8; duration: 500; easing.type: Easing.InOutSine }
            }
        }

        // Charging animation overlay
        Item {
            anchors.fill: batteryFill
            visible: isCharging
            clip: true

            // Moving light effect for charging
            Rectangle {
                id: chargingEffect
                width: parent.width * 2
                height: parent.height * 0.1
                rotation: -10
                color: "#ffffff"
                opacity: 0.2

                NumberAnimation on y {
                    from: parent.height
                    to: -height
                    duration: 1500
                    loops: Animation.Infinite
                    running: isCharging
                }
            }
        }

        // Battery level markers - subtle lines
        Repeater {
            model: 5 // 20%, 40%, 60%, 80% markers

            Rectangle {
                x: 0
                y: batteryBackground.height * (1 - ((index + 1) * 0.2))
                width: batteryBackground.width
                height: 1
                color: "#101010"  // Updated to darker grey
                opacity: 0.5
            }
        }
    }

    // Battery level percentage text
    Text {
        id: batteryPercentage
        anchors {
            horizontalCenter: batteryContainer.horizontalCenter
            top: batteryContainer.bottom
            topMargin: 15
        }
        text: batteryLevel + "%"
        color: "#ffffff"  // White color
        font.pixelSize: 24
        font.bold: true

        // Pulsing animation for low battery percentage
        SequentialAnimation on opacity {
            running: isLowBattery
            loops: Animation.Infinite
            NumberAnimation { to: 0.5; duration: 500; easing.type: Easing.InOutSine }
            NumberAnimation { to: 1.0; duration: 500; easing.type: Easing.InOutSine }
        }
    }
}
