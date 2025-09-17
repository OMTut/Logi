import QtQuick
import QtQuick.Controls
import "styles/Theme.js" as Theme
import "components"

Window {
    id: mainWindow
    width: Theme.window.minWidth
    height: Theme.window.minHeight
    visible: true
    title: qsTr("Logi - Star Citizen Companion")
    color: Theme.window.backgroundColor
    
    // Borderless window for overlay
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    
    // Window opacity management - Start in overlay mode
    opacity: Theme.window.opacityHidden
    
    // Optional: Set minimum size
    minimumWidth: 540
    minimumHeight: 280
    
    // Smooth opacity transitions
    Behavior on opacity {
        NumberAnimation {
            duration: Theme.window.transitionDuration
            easing.type: Easing.OutCubic
        }
    }
    
    // Main content area
    Rectangle {
        anchors.fill: parent
        color: Theme.colors.background
        
        // Window-wide hover detection
        HoverHandler {
            onHoveredChanged: {
                if (hovered) {
                    mainWindow.opacity = Theme.window.opacityFocused
                } else {
                    mainWindow.opacity = Theme.window.opacityHidden
                }
            }
        }
        
        // Custom title bar
        CustomTitleBar {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            
            title: "Overlay App"
            targetWindow: mainWindow
            windowOpacity: mainWindow.opacity
            showOpacity: true
        }
        
        // resize corner (bottom-right)
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: Theme.layout.resizeHandleSize
            height: Theme.layout.resizeHandleSize
            color: "transparent"
            
            // Visual indicator
            Canvas {
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.strokeStyle = Theme.colors.border
                    ctx.lineWidth = 1
                    
                    // Draw resize lines
                    ctx.beginPath()
                    ctx.moveTo(width - 4, height)
                    ctx.lineTo(width, height - 4)
                    ctx.moveTo(width - 8, height)
                    ctx.lineTo(width, height - 8)
                    ctx.moveTo(width - 12, height)
                    ctx.lineTo(width, height - 12)
                    ctx.stroke()
                }
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeFDiagCursor
                
                property point startPos
                property size startSize
                
                onPressed: function(mouse) {
                    startPos = Qt.point(mouse.x, mouse.y)
                    startSize = Qt.size(mainWindow.width, mainWindow.height)
                }
                
                onPositionChanged: function(mouse) {
                    if (pressed) {
                        var deltaX = mouse.x - startPos.x
                        var deltaY = mouse.y - startPos.y
                        
                        var newWidth = startSize.width + deltaX
                        var newHeight = startSize.height + deltaY
                        
                        if (newWidth >= mainWindow.minimumWidth) {
                            mainWindow.width = newWidth
                        }
                        if (newHeight >= mainWindow.minimumHeight) {
                            mainWindow.height = newHeight
                        }
                    }
                }
            }
        }
        
        
        // Scrollable content area that avoids title bar
        ScrollView {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.topMargin: Theme.layout.contentTopMargin
            anchors.bottomMargin: Theme.layout.contentBottomMargin
            anchors.leftMargin: Theme.layout.contentSideMargin
            anchors.rightMargin: Theme.layout.contentSideMargin
            
            contentWidth: -1  // Use ScrollView width
            contentHeight: contentColumn.height
            
            // Hide scroll bars but keep scrolling functionality
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            
            // Content column with styling examples
            Column {
                id: contentColumn
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.min(parent.width - Theme.layout.minContentPadding, Theme.layout.maxContentWidth)
                spacing: Theme.spacing.s6
                
                // Welcome text
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Overlay App"
                    color: Theme.colors.textPrimary
                    font.pixelSize: Theme.fonts.size3XL
                }
                
                // Subtitle
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Always On Top • Hover to Focus"
                    color: Theme.colors.textSecondary
                    font.pixelSize: Theme.fonts.sizeLG
                }
                
                // Example styled button
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 200
                    height: 40
                    color: Theme.button.backgroundColor
                    radius: Theme.button.borderRadius
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Example Button"
                        color: Theme.button.text
                        font.pixelSize: Theme.fonts.sizeMD
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        
                        property color originalColor: Theme.button.backgroundColor
                        property color hoverColor: Qt.lighter(Theme.button.backgroundColor, 1.1)
                        property color pressColor: Qt.darker(Theme.button.backgroundColor, 1.1)
                        
                        onEntered: parent.color = hoverColor
                        onExited: parent.color = originalColor
                        onPressed: parent.color = pressColor
                        onReleased: parent.color = containsMouse ? hoverColor : originalColor
                    }
                }
                
                // Example card
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 300
                    height: 120
                    color: Theme.card.backgroundColor
                    radius: Theme.card.borderRadius
                    border.width: Theme.card.borderWidth
                    border.color: Theme.card.borderColor
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: Theme.spacing.s2
                        
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Example Card"
                            color: Theme.colors.textPrimary
                            font.pixelSize: Theme.fonts.sizeXL
                        }
                        
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "An Example Card Text"
                            color: Theme.colors.textSecondary
                            font.pixelSize: Theme.fonts.sizeSM
                        }
                    }
                }
            }
        }
    }
}
