import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import "../styles/Theme.js" as Theme

Window {
    id: settingsWindow
    width: 500
    height: 350  // Increased from 300
    minimumWidth: 450
    minimumHeight: 300
    title: "Logi Settings"
    modality: Qt.ApplicationModal
    flags: Qt.Dialog | Qt.WindowTitleHint | Qt.WindowCloseButtonHint | Qt.WindowSystemMenuHint
    
    color: Theme.colors.background
    
    property alias starCitizenDirectory: pathField.text
    
    // Properties for external objects  
    property var updateChecker
    property var mainWindow
    property var mainHoverHandler
    
    // Note: appSettings is a global context property from C++, not passed as a parameter
    
    signal settingsChanged()
    
    onVisibleChanged: {
        if (visible) {
            // Ensure path field is populated when window opens
            if (appSettings && appSettings.starCitizenDirectory) {
                pathField.text = appSettings.starCitizenDirectory
            }
            
            if (mainWindow) {
                mainWindow.opacity = Theme.window.opacityFocused
            }
        } else if (mainWindow && mainHoverHandler) {
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
        
        ScrollView {
            anchors.fill: parent
            anchors.margins: 12  // Outer margin for the scroll view
            contentWidth: -1  // Use ScrollView width
            
            // Custom scrollbar styling
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            
            Column {
                width: parent.width
                anchors.margins: 12  // Inner margin for content
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
                        width: parent.width - browseButton.width - parent.spacing - statusIndicator.width - 12
                        text: appSettings ? appSettings.starCitizenDirectory : ""
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
                        
                        onTextChanged: {
                            if (text !== appSettings.starCitizenDirectory) {
                                appSettings.setStarCitizenDirectory(text)
                                settingsChanged()
                            }
                        }
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
                        id: statusIndicator
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
                            text: "Current Version: " + getCurrentVersionSafe()
                            font.pixelSize: Theme.fonts.sizeSM
                            color: Theme.colors.textSecondary
                            
                            function getCurrentVersionSafe() {
                                if (updateChecker) {
                                    try {
                                        return updateChecker.getCurrentVersion()
                                    } catch (e) {
                                        return "Error"
                                    }
                                }
                                return "0.1.0"  // Fallback to known app version
                            }
                        }
                        
                        Text {
                            text: updateChecker ? 
                                  (updateChecker.updateAvailable ? 
                                   "Update available: " + updateChecker.latestVersion :
                                   updateChecker.isChecking ? "Checking for updates..." : 
                                   "You're up to date!") : ""
                            font.pixelSize: Theme.fonts.sizeSM
                            color: (updateChecker && updateChecker.updateAvailable) ? Theme.colors.accent : Theme.colors.textSecondary
                            visible: !updateChecker || !updateChecker.isChecking || updateChecker.updateAvailable
                        }
                    }
                    
                    Button {
                        id: checkUpdatesButton
                        text: (updateChecker && updateChecker.isChecking) ? "Checking..." : "Check for Updates"
                        width: 140
                        height: 32
                        enabled: !updateChecker || !updateChecker.isChecking
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
                            if (updateChecker) {
                                updateChecker.checkForUpdates()
                            }
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
                        if (appSettings && appSettings.starCitizenDirectory) {
                            pathField.text = appSettings.starCitizenDirectory
                        } else {
                            pathField.text = ""
                        }
                        close()  // Use close() directly instead of settingsWindow.close()
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
                        if (appSettings) {
                            appSettings.setStarCitizenDirectory(pathField.text)
                            appSettings.saveSettings()
                        }
                        close()  // Use close() directly instead of settingsWindow.close()
                    }
                }
            }
        }  // End Column
        }  // End ScrollView
    }  // End Rectangle
    
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
