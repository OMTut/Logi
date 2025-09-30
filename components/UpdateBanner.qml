import QtQuick
import QtQuick.Controls
import "../styles/Theme.js" as Theme

Rectangle {
    id: root
    
    // Properties that can be set from parent
    property alias updateChecker: internal.updateChecker
    
    // Internal object to hold the updateChecker reference
    QtObject {
        id: internal
        property var updateChecker
    }
    
    // Auto-sizing based on update availability
    height: (internal.updateChecker && internal.updateChecker.updateAvailable) ? 50 : 0
    visible: (internal.updateChecker && internal.updateChecker.updateAvailable)
    color: (internal.updateChecker && internal.updateChecker.updateRequired) ? "#dc2626" : Theme.colors.accent
    
    Behavior on height {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
    
    Row {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        spacing: 12
        
        // Update icon
        Text {
            text: (internal.updateChecker && internal.updateChecker.updateRequired) ? "⚠" : "↗"
            color: "white"
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
        }
        
        // Update message
        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2
            
            Text {
                text: (internal.updateChecker && internal.updateChecker.updateRequired) ? 
                      "Required Update Available" : "Update Available"
                color: "white"
                font.pixelSize: Theme.fonts.sizeMD
                font.weight: Font.Medium
            }
            
            Text {
                text: internal.updateChecker ? 
                      "Version " + internal.updateChecker.latestVersion + " - " + internal.updateChecker.updateMessage : ""
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
                color: (internal.updateChecker && internal.updateChecker.updateRequired) ? "#dc2626" : Theme.colors.accent
                font.pixelSize: Theme.fonts.sizeSM
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: {
                if (internal.updateChecker) {
                    internal.updateChecker.openReleaseNotes()
                }
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
                color: (internal.updateChecker && internal.updateChecker.updateRequired) ? "#dc2626" : Theme.colors.accent
                font.pixelSize: Theme.fonts.sizeSM
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: {
                if (internal.updateChecker) {
                    internal.updateChecker.downloadUpdate()
                }
            }
        }
    }
}