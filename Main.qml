import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
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
            enabled: !settingsWindow.visible
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
                settingsWindow.show()
                settingsWindow.raise()
                settingsWindow.requestActivate()
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
            contentHeight: statusIndicator.height
            
            // Hide scroll bars but keep scrolling functionality
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            StatusIndicator {
                id: statusIndicator
                width: parent.width
                height: parent.height
            }
        }
    }
    
    // Settings Window (Inline)
    Window {
        id: settingsWindow
        width: 500
        height: 300
        title: "Logi Settings"
        modality: Qt.ApplicationModal
        flags: Qt.Dialog | Qt.WindowTitleHint | Qt.WindowCloseButtonHint | Qt.WindowSystemMenuHint
        visible: false
        
        color: Theme.colors.background
        
        onVisibleChanged: {
            if (visible) {
                mainWindow.opacity = Theme.window.opacityFocused
            } else {
                // Restore hover-based opacity behavior
                if (mainHoverHandler.hovered) {
                    mainWindow.opacity = Theme.window.opacityFocused
                } else {
                    mainWindow.opacity = Theme.window.opacityHidden
                }
            }
        }
        
        Rectangle {
            anchors.fill: parent
            color: Theme.colors.background
            
            Column {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 20
                
                // Header
                Text {
                    text: "Settings"
                    font.pixelSize: Theme.fonts.sizeLG
                    font.weight: Font.Medium
                    color: Theme.colors.textPrimary
                }
                
                // Divider
                Rectangle {
                    width: parent.width
                    height: 1
                    color: Theme.colors.border
                }
                
                // Star Citizen Directory Section
                Column {
                    width: parent.width
                    spacing: 8
                    
                    Text {
                        text: "Star Citizen Installation Directory"
                        font.pixelSize: Theme.fonts.sizeMD
                        font.weight: Font.Medium
                        color: Theme.colors.textPrimary
                    }
                    
                    Text {
                        text: "Select the directory where Star Citizen is installed (e.g., C:/Program Files/Roberts Space Industries/StarCitizen)"
                        font.pixelSize: Theme.fonts.sizeSM
                        color: Theme.colors.textSecondary
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }
                    
                    Row {
                        width: parent.width
                        spacing: 12
                        
                        TextField {
                            id: pathField
                            width: parent.width - browseButton.width - parent.spacing - settingsStatusIndicator.width - 12
                            text: appSettings.starCitizenDirectory
                            placeholderText: "Enter or browse for directory..."
                            
                            background: Rectangle {
                                color: Theme.colors.surface
                                border.color: parent.focus ? Theme.colors.accent : Theme.colors.border
                                border.width: 1
                                radius: 6
                            }
                            
                            color: Theme.colors.textPrimary
                            selectionColor: Theme.colors.accent
                            font.pixelSize: Theme.fonts.sizeMD
                        }
                        
                        Button {
                            id: browseButton
                            text: "Browse..."
                            width: 100
                            
                            background: Rectangle {
                                color: parent.pressed ? Qt.darker(Theme.colors.accent, 1.2) : 
                                       parent.hovered ? Qt.lighter(Theme.colors.accent, 1.1) : Theme.colors.accent
                                radius: 6
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                font.pixelSize: Theme.fonts.sizeMD
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                folderDialog.open()
                            }
                        }
                        
                        // Status indicator
                        Rectangle {
                            id: settingsStatusIndicator
                            width: 20
                            height: 20
                            radius: 10
                            color: appSettings.isValidStarCitizenDirectory(pathField.text) ? "#10b981" : "#ef4444"
                            anchors.verticalCenter: parent.verticalCenter
                            visible: pathField.text.length > 0
                            
                            Text {
                                anchors.centerIn: parent
                                text: appSettings.isValidStarCitizenDirectory(pathField.text) ? "✓" : "✗"
                                color: "white"
                                font.pixelSize: 12
                                font.weight: Font.Bold
                            }
                        }
                    }
                    
                    // Validation message
                    Text {
                        text: {
                            if (pathField.text.length === 0) return ""
                            return appSettings.isValidStarCitizenDirectory(pathField.text) ? 
                                   "✓ Valid Star Citizen directory found" : 
                                   "✗ Invalid directory - please select the Star Citizen installation folder"
                        }
                        font.pixelSize: Theme.fonts.sizeSM
                        color: appSettings.isValidStarCitizenDirectory(pathField.text) ? "#10b981" : "#ef4444"
                        visible: pathField.text.length > 0
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }
                }
                
                Item { height: 20 } // Spacer
                
                // Action buttons
                Row {
                    anchors.right: parent.right
                    spacing: 12
                    
                    Button {
                        text: "Cancel"
                        width: 80
                        
                        background: Rectangle {
                            color: parent.pressed ? Qt.darker(Theme.colors.surface, 1.1) : 
                                   parent.hovered ? Qt.lighter(Theme.colors.surface, 1.1) : Theme.colors.surface
                            border.color: Theme.colors.border
                            border.width: 1
                            radius: 6
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            color: Theme.colors.textPrimary
                            font.pixelSize: Theme.fonts.sizeMD
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        onClicked: {
                            // Revert changes
                            pathField.text = appSettings.starCitizenDirectory
                            settingsWindow.close()
                        }
                    }
                    
                    Button {
                        text: "Save"
                        width: 80
                        
                        background: Rectangle {
                            color: parent.pressed ? Qt.darker(Theme.colors.accent, 1.2) : 
                                   parent.hovered ? Qt.lighter(Theme.colors.accent, 1.1) : Theme.colors.accent
                            radius: 6
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            font.pixelSize: Theme.fonts.sizeMD
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        onClicked: {
                            appSettings.setStarCitizenDirectory(pathField.text)
                            appSettings.saveSettings()
                            settingsWindow.close()
                        }
                    }
                }
            }
        }
        
        FolderDialog {
            id: folderDialog
            title: "Select Star Citizen Installation Directory"
            currentFolder: pathField.text.length > 0 ? "file:///" + pathField.text : "file:///C:/"
            
            onAccepted: {
                var path = selectedFolder.toString().replace("file:///", "")
                pathField.text = path
            }
        }
    }
}
