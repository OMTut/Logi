import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import "../styles/Theme.js" as Theme

Dialog {
    id: settingsDialog
    title: "Logi Settings"
    width: 540
    height: 280
    modal: false
    
    // Make it resizable
    property int minimumWidth: 400
    property int minimumHeight: 300
    
    
    
    property alias starCitizenDirectory: pathField.text
    
    background: Rectangle {
        color: Theme.colors.background
        border.color: Theme.colors.border
        border.width: 1
        radius: 8
    }
    
    header: Rectangle {
        height: 50
        color: Theme.colors.surface
        radius: 8
        
        Text {
            anchors.centerIn: parent
            text: "Settings"
            color: Theme.colors.textPrimary
            font.pixelSize: Theme.fonts.sizeXL
            font.bold: true
        }
    }
    
    ScrollView {
        anchors.fill: parent
        anchors.margins: 20
        
        Column {
            width: parent.width
            spacing: Theme.spacing.s4
            
            // Star Citizen Directory Section
            GroupBox {
                width: parent.width
                
                background: Rectangle {
                    color: Theme.colors.surface
                    border.color: Theme.colors.border
                    border.width: 1
                    radius: 6
                }
                
                Column {
                    width: parent.width
                    spacing: Theme.spacing.s3
                    
                    
                    // Path input section
                    Text {
                        text: "Star Citizen Directory:"
                        color: Theme.colors.textPrimary
                        font.pixelSize: Theme.fonts.sizeMD
                    }
                    
                    Row {
                        width: parent.width
                        spacing: 10
                        
                        TextField {
                            id: pathField
                            width: parent.width - browseButton.width - parent.spacing
                            text: appSettings.starCitizenDirectory
                            placeholderText: "Select Star Citizen installation directory..."
                            
                            background: Rectangle {
                                color: Theme.colors.surface
                                border.color: parent.focus ? Theme.colors.accent : Theme.colors.border
                                border.width: 1
                                radius: 4
                            }
                            
                            color: Theme.colors.textPrimary
                            selectionColor: Theme.colors.accent
                            
                            onTextChanged: {
                                if (text !== appSettings.starCitizenDirectory) {
                                    appSettings.setStarCitizenDirectory(text)
                                }
                            }
                        }
                        
                        Button {
                            id: browseButton
                            text: "Browse..."
                            
                            background: Rectangle {
                                color: parent.pressed ? Qt.darker(Theme.colors.accent, 1.2) : 
                                       parent.hovered ? Qt.lighter(Theme.colors.accent, 1.1) : Theme.colors.accent
                                radius: 4
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                folderDialog.open()
                            }
                        }
                    }
                    
                    // Path validation indicator
                    Row {
                        spacing: 8
                        visible: pathField.text.length > 0
                        
                        Rectangle {
                            width: 12
                            height: 12
                            radius: 6
                            color: appSettings.isValidStarCitizenDirectory(pathField.text) ? "#36d399" : "#ef4444"
                        }
                        
                        Text {
                            text: appSettings.isValidStarCitizenDirectory(pathField.text) ? "Valid directory" : "Invalid directory"
                            color: appSettings.isValidStarCitizenDirectory(pathField.text) ? "#36d399" : "#ef4444"
                            font.pixelSize: Theme.fonts.sizeSM
                        }
                    }
                    
                }
            }
        }
    }
    
    footer: DialogButtonBox {
        background: Rectangle {
            color: Theme.colors.surface
            radius: 8
        }
        
        Button {
            text: "Save"
            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            
            background: Rectangle {
                color: parent.pressed ? Qt.darker(Theme.colors.accent, 1.2) : 
                       parent.hovered ? Qt.lighter(Theme.colors.accent, 1.1) : Theme.colors.accent
                radius: 4
            }
            
            contentItem: Text {
                text: parent.text
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
        
        Button {
            text: "Cancel"
            DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            
            background: Rectangle {
                color: parent.pressed ? Qt.darker(Theme.colors.surface, 1.2) : 
                       parent.hovered ? Qt.lighter(Theme.colors.surface, 1.1) : Theme.colors.surface
                border.color: Theme.colors.border
                border.width: 1
                radius: 4
            }
            
            contentItem: Text {
                text: parent.text
                color: Theme.colors.textPrimary
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
        
        Button {
            text: "Reset"
            DialogButtonBox.buttonRole: DialogButtonBox.ResetRole
            
            background: Rectangle {
                color: parent.pressed ? Qt.darker("#ef4444", 1.2) : 
                       parent.hovered ? Qt.lighter("#ef4444", 1.1) : "#ef4444"
                radius: 4
            }
            
            contentItem: Text {
                text: parent.text
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
        
        onAccepted: {
            appSettings.saveSettings()
            settingsDialog.close()
        }
        
        onRejected: {
            // Revert changes
            appSettings.loadSettings()
            pathField.text = appSettings.starCitizenDirectory
            settingsDialog.close()
        }
        
        onReset: {
            appSettings.resetToDefaults()
            pathField.text = appSettings.starCitizenDirectory
        }
    }
    
    // File/Folder picker dialog
    FolderDialog {
        id: folderDialog
        title: "Select Star Citizen Installation Directory"
        currentFolder: pathField.text.length > 0 ? "file:///" + pathField.text : "file:///C:/"
        
        onAccepted: {
            var path = selectedFolder.toString().replace("file:///", "")
            pathField.text = path
            appSettings.setStarCitizenDirectory(path)
        }
    }
    
    Component.onCompleted: {
        // Initialize fields with current settings
        pathField.text = appSettings.starCitizenDirectory
    }
}
