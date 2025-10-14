import QtQuick
import QtQuick.Controls
import "../styles/Theme.js" as Theme

Rectangle {
    id: root
    
    // Safe computed properties to avoid undefined assignment
    property bool isUpdateAvailable: updateChecker ? (updateChecker.updateAvailable || false) : false
    property bool isUpdateRequired: updateChecker ? (updateChecker.updateRequired || false) : false
    property bool isDismissed: false
    
    // Auto-sizing based on update availability and dismiss state
    height: (isUpdateAvailable && !isDismissed) ? 50 : 0
    visible: (isUpdateAvailable && !isDismissed)
    color: isUpdateRequired ? "#dc2626" : Theme.colors.accent
    
    Behavior on height {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
    
    // Reset dismissed state when update status changes
    onIsUpdateAvailableChanged: {
        if (isUpdateAvailable) {
            isDismissed = false
        }
    }
    
    Row {
        id: contentRow
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.topMargin: 8
        spacing: 12
        
        // Update icon
        Text {
            id: updateIcon
            text: isUpdateRequired ? "⚠" : "↗"
            color: "white"
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
        }
        
        // Update message
        Column {
            width: parent.width - updateIcon.width - updateButton.width - releaseNotesButton.width - (isUpdateRequired ? 0 : (closeButton.width + 16)) - parent.spacing * 4 - 20
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2
            
            Text {
                text: isUpdateRequired ? "Required Update Available" : "Update Available"
                color: "white"
                font.pixelSize: Theme.fonts.sizeMD
                font.weight: Font.Medium
            }
            
            Text {
                text: updateChecker ? 
                      "Version " + updateChecker.latestVersion : ""
                color: "white"
                font.pixelSize: Theme.fonts.sizeSM
                opacity: 0.9
            }
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
                color: isUpdateRequired ? "#dc2626" : Theme.colors.accent
                font.pixelSize: Theme.fonts.sizeSM
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: {
                if (updateChecker) {
                    updateChecker.openReleaseNotes()
                }
            }
        }
        
// Update button
        Button {
            id: updateButton
            text: "Update Now"
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
                color: isUpdateRequired ? "#dc2626" : Theme.colors.accent
                font.pixelSize: Theme.fonts.sizeSM
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: {
                if (updateChecker) {
                    // Show progress dialog and start silent update
                    var dialog = getUpdateProgressDialog()
                    if (dialog) {
                        dialog.progress = 0
                        dialog.statusText = "Downloading update..."
                        dialog.canCancel = false
                        dialog.isComplete = false
                        dialog.open()
                    }
                    updateChecker.performUpdateSilent()
                }
            }
        }
    }
    
    // Progress dialog instance
    Loader {
        id: progressLoader
        active: true
        source: "UpdateProgressDialog.qml"
        onLoaded: {
            // Wire up signals after the component is ready
            if (updateChecker) {
                updateChecker.downloadProgress.connect(function(received, total) {
                    var dialog = getUpdateProgressDialog()
                    if (dialog) {
                        if (total > 0) {
                            dialog.progress = received / total
                        } else {
                            dialog.progress = 0
                        }
                    }
                })
                updateChecker.downloadComplete.connect(function(filePath) {
                    var dialog = getUpdateProgressDialog()
                    if (dialog) {
                        dialog.statusText = "Installing..."
                        dialog.progress = 1.0
                    }
                })
                updateChecker.installStarted.connect(function() {
                    var dialog = getUpdateProgressDialog()
                    if (dialog) {
                        dialog.statusText = "Installing..."
                    }
                })
                updateChecker.downloadFailed.connect(function(msg) {
                    var dialog = getUpdateProgressDialog()
                    if (dialog) {
                        dialog.statusText = "Update failed: " + msg
                        dialog.isComplete = true
                    }
                })
            }
        }
    }

    function getUpdateProgressDialog() {
        return progressLoader.item
    }
    
    // Close button (only for optional updates) - positioned to align with title bar
    Button {
        id: closeButton
        text: "×"
        width: 24  // Match title bar close button size
        height: 24
        visible: !isUpdateRequired
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 8  // Match title bar's Theme.spacing.s2
        
        background: Rectangle {
            color: parent.pressed ? Qt.darker("white", 1.3) :
                   parent.hovered ? Qt.lighter("white", 1.1) : "transparent"
            opacity: parent.hovered ? 0.9 : 0.6
            radius: 4  // Match title bar radius
        }
        
        contentItem: Text {
            text: parent.text
            color: "white"
            font.pixelSize: 16  // Match title bar font size
            font.weight: Font.Bold
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        
        onClicked: {
            root.isDismissed = true
        }
        
        ToolTip.visible: hovered
        ToolTip.text: "Dismiss update notification"
        ToolTip.delay: 500
    }
}
