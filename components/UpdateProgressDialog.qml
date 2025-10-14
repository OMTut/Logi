import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import "../styles/Theme.js" as Theme

Dialog {
    id: root
    
    property alias progress: progressBar.value
    property alias statusText: statusLabel.text
    property bool canCancel: true
    property bool isComplete: false
    
    title: "Updating Logi"
    modal: true
    closePolicy: canCancel ? Popup.CloseOnEscape : Popup.NoAutoClose
    
    width: 400
    height: 200
    
    // Center the dialog
    anchors.centerIn: parent
    
    // Custom background
    background: Rectangle {
        color: Theme.colors.background
        border.color: Theme.colors.accent
        border.width: 1
        radius: Theme.borderRadius.md
    }
    
    header: Rectangle {
        height: 40
        color: Theme.colors.accent
        radius: Theme.borderRadius.md
        
        // Only round top corners
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: parent.radius
            color: parent.color
        }
        
        Text {
            text: root.title
            color: "white"
            font.pixelSize: Theme.fonts.sizeMD
            font.weight: Font.Medium
            anchors.centerIn: parent
        }
        
        // Close button (only shown when canCancel is true)
        Button {
            visible: root.canCancel
            text: "×"
            width: 24
            height: 24
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 8
            
            background: Rectangle {
                color: parent.pressed ? Qt.darker("white", 1.3) :
                       parent.hovered ? Qt.lighter("white", 1.1) : "transparent"
                opacity: parent.hovered ? 0.9 : 0.6
                radius: 4
            }
            
            contentItem: Text {
                text: parent.text
                color: "white"
                font.pixelSize: 16
                font.weight: Font.Bold
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: root.reject()
        }
    }
    
    contentItem: Column {
        spacing: Theme.spacing.s4
        anchors.fill: parent
        anchors.margins: Theme.spacing.s4
        
        // Status text
        Text {
            id: statusLabel
            text: "Preparing update..."
            color: Theme.colors.textPrimary
            font.pixelSize: Theme.fonts.sizeMD
            width: parent.width
            wrapMode: Text.WordWrap
        }
        
        // Progress bar
        ProgressBar {
            id: progressBar
            width: parent.width
            height: 20
            from: 0.0
            to: 1.0
            value: 0.0
            
            background: Rectangle {
                color: Theme.colors.inputBackground
                radius: Theme.borderRadius.sm
                border.color: Theme.colors.border
                border.width: 1
            }
            
            contentItem: Rectangle {
                width: progressBar.visualPosition * parent.width
                height: parent.height
                radius: Theme.borderRadius.sm
                color: Theme.colors.accent
                
                // Animated gradient effect
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.lighter(Theme.colors.accent, 1.2) }
                    GradientStop { position: 1.0; color: Theme.colors.accent }
                }
            }
        }
        
        // Progress percentage text
        Text {
            text: Math.round(progressBar.value * 100) + "%"
            color: Theme.colors.textSecondary
            font.pixelSize: Theme.fonts.sizeSM
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        // Action buttons
        Row {
            spacing: Theme.spacing.s3
            anchors.horizontalCenter: parent.horizontalCenter
            
            // Cancel button (only shown when canCancel is true and not complete)
            Button {
                visible: root.canCancel && !root.isComplete
                text: "Cancel"
                width: 80
                height: 32
                
                background: Rectangle {
                    color: parent.pressed ? Qt.darker(Theme.colors.inputBackground, 1.2) :
                           parent.hovered ? Qt.lighter(Theme.colors.inputBackground, 1.1) : 
                           Theme.colors.inputBackground
                    border.color: Theme.colors.border
                    border.width: 1
                    radius: Theme.borderRadius.sm
                }
                
                contentItem: Text {
                    text: parent.text
                    color: Theme.colors.textPrimary
                    font.pixelSize: Theme.fonts.sizeSM
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: root.reject()
            }
            
            // Close button (shown when complete)
            Button {
                visible: root.isComplete
                text: "Close"
                width: 80
                height: 32
                
                background: Rectangle {
                    color: parent.pressed ? Qt.darker(Theme.colors.accent, 1.2) :
                           parent.hovered ? Qt.lighter(Theme.colors.accent, 1.1) : 
                           Theme.colors.accent
                    radius: Theme.borderRadius.sm
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: Theme.fonts.sizeSM
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: root.accept()
            }
        }
    }
    
    // Handle escape key when cancellation is not allowed
    Keys.onEscapePressed: {
        if (canCancel) {
            event.accepted = false // Let default handling work
        } else {
            event.accepted = true // Block escape
        }
    }
}