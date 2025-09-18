import QtQuick
import QtQuick.Controls
import "../styles/Theme.js" as Theme

Window {
    id: settingsWindow
    width: 500
    height: 300
    title: "Logi Settings"
    modality: Qt.ApplicationModal
    flags: Qt.Dialog | Qt.WindowTitleHint | Qt.WindowCloseButtonHint | Qt.WindowSystemMenuHint
    
    color: Theme.colors.background
    
    property alias starCitizenDirectory: pathField.text
    
    signal settingsChanged()
    
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
                        width: parent.width - browseButton.width - parent.spacing - statusIndicator.width - 12
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
                            // TODO: Implement folder dialog
                            console.log("Browse button clicked - folder dialog not yet implemented")
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
    
    // FolderDialog temporarily removed due to import issues
    // TODO: Re-implement folder selection
}
