import QtQuick
import QtQuick.Controls
import "../styles/Theme.js" as Theme

Rectangle {
    id: root
    width: 32
    height: 18
    radius: height / 2
    color: toggled ? Theme.colors.accent : Theme.colors.surfaceVariant
    border.color: toggled ? Theme.colors.accent : Theme.colors.border
    border.width: 1
    
    property bool toggled: false
    
    Behavior on color {
        ColorAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
    
    // Slider knob
    Rectangle {
        id: knob
        width: 14
        height: 14
        radius: width / 2
        anchors.verticalCenter: parent.verticalCenter
        x: toggled ? parent.width - width - 2 : 2
        color: Theme.colors.textPrimary
        
        Behavior on x {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
    }
    
    // Left label (PvE)
    Text {
        anchors.right: parent.left
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        text: "PvE"
        color: Theme.colors.textPrimary
        font.pixelSize: Theme.fonts.sizeXS
        font.bold: !toggled
    }
    
    // Right label (PvP)
    Text {
        anchors.left: parent.right
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        text: "PvP"
        color: Theme.colors.textPrimary
        font.pixelSize: Theme.fonts.sizeXS
        font.bold: toggled
    }
    
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.toggled = !root.toggled
        }
    }
    
    // Tooltip
    ToolTip {
        visible: mouseArea.containsMouse
        text: toggled ? "Showing PvP only" : "Showing all"
        delay: 500
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            root.toggled = !root.toggled
        }
    }
}
