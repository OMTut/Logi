import QtQuick
import QtQuick.Controls
import "../styles/Theme.js" as Theme

Row {
    id: root
    property bool online: processChecker.isGameRunning
    spacing: 8
    
    // Connect to ProcessChecker signals
    Connections {
        target: processChecker
        function onGameRunningChanged() {
            root.online = processChecker.isGameRunning
        }
    }
    
    Component.onCompleted: {
        console.log("StatusIndicator: Starting Star Citizen monitoring...")
        processChecker.startMonitoring(3000) // Check every 3 seconds
    }

    Label {
        text: "Game Status:"
        opacity: 1.0
        color: Theme.colors.textPrimary
    }

    Rectangle {
        id: dot
        width: 10
        height: 10
        radius: 5
        color: root.online ? "#36d399" : "#ef4444" // green/red
        anchors.verticalCenter: parent.verticalCenter
    }

    Label {
        id: statusText
        text: root.online ? "Online" : "Offline"
        font.bold: true
        color: root.online ? "#36d399" : "#ef4444"
    }
    
    Label {
        text: processChecker.lastCheckTime ? "(" + processChecker.lastCheckTime + ")" : ""
        font.pixelSize: 10
        opacity: 0.7
        color: Theme.colors.textSecondary
        anchors.verticalCenter: parent.verticalCenter
    }
}
