import QtQuick
import "../styles/Theme.js" as Theme

Rectangle {
    id: titleBar
    height: Theme.layout.titleBarHeight
    color: Qt.rgba(Theme.colors.surface.r, 
                   Theme.colors.surface.g, 
                   Theme.colors.surface.b, 
                   0.8)
    
    // Properties to customize the title bar
    property alias title: titleText.text
    property alias showOpacity: opacityText.visible
    property real windowOpacity: 1.0
    property Window targetWindow: null
    
    // Window drag functionality
    DragHandler {
        target: null
        onActiveChanged: {
            if (active && targetWindow) {
                targetWindow.startSystemMove()
            }
        }
    }
    
    // Title text on the left
    Text {
        id: titleText
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: Theme.spacing.s3
        text: "Application"
        color: Theme.colors.textPrimary
        font.pixelSize: Theme.fonts.sizeSM
        font.bold: true
    }
    
    // Window controls on the right
    Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: Theme.spacing.s2
        spacing: Theme.spacing.s1
        
        // Opacity indicator
        Text {
            id: opacityText
            anchors.verticalCenter: parent.verticalCenter
            text: Math.round(titleBar.windowOpacity * 100) + "%"
            color: Theme.colors.textSecondary
            font.pixelSize: Theme.fonts.sizeXS
            visible: true
        }
        
        // Minimize button
        Rectangle {
            width: 24
            height: 24
            radius: Theme.radius.sm
            color: minimizeArea.containsMouse ? Theme.colors.surfaceVariant : "transparent"
            
            Text {
                anchors.centerIn: parent
                text: "−"
                color: minimizeArea.containsMouse ? Theme.colors.textPrimary : Theme.colors.textSecondary
                font.pixelSize: 14
                font.bold: true
            }
            
            MouseArea {
                id: minimizeArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: targetWindow?.showMinimized()
            }
        }
        
        // Close button
        Rectangle {
            width: 24
            height: 24
            radius: Theme.radius.sm
            color: closeArea.containsMouse ? Theme.colors.error : "transparent"
            
            Text {
                anchors.centerIn: parent
                text: "×"
                color: closeArea.containsMouse ? "white" : Theme.colors.textSecondary
                font.pixelSize: 16
                font.bold: true
            }
            
            MouseArea {
                id: closeArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: targetWindow?.close()
            }
        }
    }
    
    // Bottom border
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: Theme.colors.border
        opacity: 0.3
    }
}
