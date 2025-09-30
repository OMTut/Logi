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
        
        // Update notification banner
        Rectangle {
            id: updateBanner
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: Theme.layout.titleBarHeight
            height: updateChecker.updateAvailable ? 50 : 0
            visible: updateChecker.updateAvailable
            color: updateChecker.updateRequired ? "#dc2626" : Theme.colors.accent
            z: 10
            
            Behavior on height {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
            
            Row {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12
                
                // Update icon
                Text {
                    text: updateChecker.updateRequired ? "⚠" : "↗"
                    color: "white"
                    font.pixelSize: 16
                    anchors.verticalCenter: parent.verticalCenter
                }
                
                // Update message
                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2
                    
                    Text {
                        text: updateChecker.updateRequired ? 
                              "Required Update Available" : "Update Available"
                        color: "white"
                        font.pixelSize: Theme.fonts.sizeMD
                        font.weight: Font.Medium
                    }
                    
                    Text {
                        text: "Version " + updateChecker.latestVersion + " - " + updateChecker.updateMessage
                        color: "white"
                        font.pixelSize: Theme.fonts.sizeSM
                        opacity: 0.9
                    }
                }
                
                // Spacer
                Item {
                    width: parent.width - updateButton.width - releaseNotesButton.width - parent.spacing * 3 - 40
                }
                
                // Release Notes button
                Button {
                    id: releaseNotesButton
                    text: "Release Notes"
                    width: 100
                    height: 26
                    anchors.verticalCenter: parent.verticalCenter
                    
                    background: Rectangle {
                        color: parent.pressed ? Qt.darker("white", 1.3) :
                               parent.hovered ? Qt.lighter("white", 1.1) : "white"
                        opacity: parent.hovered ? 0.9 : 0.8
                        radius: 4
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: updateChecker.updateRequired ? "#dc2626" : Theme.colors.accent
                        font.pixelSize: Theme.fonts.sizeSM
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        updateChecker.openReleaseNotes()
                    }
                }
                
                // Update button
                Button {
                    id: updateButton
                    text: "Download Update"
                    width: 120
                    height: 26
                    anchors.verticalCenter: parent.verticalCenter
                    
                    background: Rectangle {
                        color: parent.pressed ? Qt.darker("white", 1.3) :
                               parent.hovered ? Qt.lighter("white", 1.1) : "white"
                        radius: 4
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: updateChecker.updateRequired ? "#dc2626" : Theme.colors.accent
                        font.pixelSize: Theme.fonts.sizeSM
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        updateChecker.downloadUpdate()
                    }
                }
            }
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
        
        
        // Scrollable content area that avoids title bar and update banner
        ScrollView {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.topMargin: Theme.layout.contentTopMargin + (updateChecker.updateAvailable ? updateBanner.height : 0)
            anchors.bottomMargin: Theme.layout.contentBottomMargin
            anchors.leftMargin: Theme.layout.contentSideMargin
            anchors.rightMargin: Theme.layout.contentSideMargin
            
            Behavior on anchors.topMargin {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
            
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
    
    // Auto-check for updates when app starts
    Component.onCompleted: {
        // Delay the check slightly to let the app finish loading
        Qt.callLater(updateChecker.checkForUpdates)
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
                
                // Updates Section
                Column {
                    width: parent.width
                    spacing: 8
                    
                    Text {
                        text: "Updates"
                        font.pixelSize: Theme.fonts.sizeMD
                        font.weight: Font.Medium
                        color: Theme.colors.textPrimary
                    }
                    
                    Row {
                        width: parent.width
                        spacing: 12
                        
                        Column {
                            spacing: 4
                            width: parent.width - checkUpdatesButton.width - parent.spacing
                            
                            Text {
                                text: "Current Version: " + updateChecker.getCurrentVersion()
                                font.pixelSize: Theme.fonts.sizeSM
                                color: Theme.colors.textSecondary
                            }
                            
                            Text {
                                text: updateChecker.updateAvailable ? 
                                      "Update available: " + updateChecker.latestVersion :
                                      updateChecker.isChecking ? "Checking for updates..." : 
                                      "You're up to date!"
                                font.pixelSize: Theme.fonts.sizeSM
                                color: updateChecker.updateAvailable ? Theme.colors.accent : Theme.colors.textSecondary
                                visible: !updateChecker.isChecking || updateChecker.updateAvailable
                            }
                        }
                        
                        Button {
                            id: checkUpdatesButton
                            text: updateChecker.isChecking ? "Checking..." : "Check for Updates"
                            width: 140
                            height: 32
                            enabled: !updateChecker.isChecking
                            anchors.verticalCenter: parent.verticalCenter
                            
                            background: Rectangle {
                                color: parent.pressed ? Qt.darker(Theme.colors.accent, 1.2) : 
                                       parent.hovered ? Qt.lighter(Theme.colors.accent, 1.1) : Theme.colors.accent
                                opacity: parent.enabled ? 1.0 : 0.6
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
                                updateChecker.checkForUpdates()
                            }
                        }
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
