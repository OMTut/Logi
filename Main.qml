import QtQuick
import QtQuick.Controls
import "styles/Theme.js" as Theme
import "components"

Window {
    id: mainWindow
    width: Theme.window.minWidth
    height: Theme.window.minHeight
    visible: true
    title: qsTr("Logi")
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
        id: mainContentArea
        anchors.fill: parent
        color: Theme.colors.background
        
        // Window-wide hover detection
        HoverHandler {
            id: mainHoverHandler
            enabled: !settingsDialog.opened
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
            
            title: "Logi -"
            targetWindow: mainWindow
            windowOpacity: mainWindow.opacity
            showOpacity: true
        }
        
        // Settings button overlay on top of title bar
        Button {
            id: settingsButton
            width: 30
            height: 30
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: (Theme.layout.titleBarHeight - height) / 2
            anchors.rightMargin: 35 // Leave space for window controls
            
            background: Rectangle {
                color: parent.pressed ? Qt.darker(Theme.colors.accent, 1.3) :
                       parent.hovered ? Theme.colors.accent : "transparent"
                radius: 4
                opacity: parent.hovered || parent.pressed ? 0.8 : 0.5
            }
            
            contentItem: Text {
                text: "⚙"
                color: Theme.colors.textPrimary
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            ToolTip.visible: hovered
            ToolTip.text: "Settings"
            ToolTip.delay: 500
            
            onClicked: {
                settingsDialog.open()
            }
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

            StatusIndicator {}
            
            // Content column with styling examples
            Column {
                id: contentColumn
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.min(parent.width - Theme.layout.minContentPadding, Theme.layout.maxContentWidth)
                spacing: Theme.spacing.s6
                
            }
        }
    }
    
    // Settings Dialog
    SettingsDialog {
        id: settingsDialog
        anchors.centerIn: Overlay.overlay
        
        onOpened: {
            mainWindow.opacity = Theme.window.opacityFocused
        }
        
        onClosed: {
            // Restore hover-based opacity behavior
            if (mainHoverHandler.hovered) {
                mainWindow.opacity = Theme.window.opacityFocused
            } else {
                mainWindow.opacity = Theme.window.opacityHidden
            }
        }
    }
}
