import QtQuick
import QtQuick.Controls
import "../styles/Theme.js" as Theme

Column {
    id: root
    property bool online: processChecker.isGameRunning
    spacing: 12
    
    // Connect to ProcessChecker signals
    Connections {
        target: processChecker
        function onGameRunningChanged() {
            root.online = processChecker.isGameRunning
        }
    }
    
    // Connect to Settings changes to find log file
    Connections {
        target: appSettings
        function onStarCitizenDirectoryChanged() {
            if (appSettings.starCitizenDirectory) {
                logReader.findLogFile(appSettings.starCitizenDirectory)
                if (logReader.logFileExists) {
                    logReader.startMonitoring(1000) // Check log every 1 second
                }
            }
        }
    }
    
    
    Component.onCompleted: {
        console.log("StatusIndicator: Starting Star Citizen monitoring...")
        processChecker.startMonitoring(3000) // Check every 3 seconds
        
        // Try to find log file if directory is already set
        if (appSettings.starCitizenDirectory) {
            logReader.findLogFile(appSettings.starCitizenDirectory)
            if (logReader.logFileExists) {
                logReader.startMonitoring(1000)
            }
        }
    }

    // Game Status Row
    Row {
        spacing: 8
        
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
            text: "Log File Status:"
            opacity: 1.0
            color: Theme.colors.textPrimary
        }

        Rectangle {
            width: 10
            height: 10
            radius: 5
            color: logReader.logFileExists ? "#36d399" : "#ef4444"
            anchors.verticalCenter: parent.verticalCenter
        }

        Label {
            text: logReader.logFileExists ? "Found" : "Not Found"
            font.bold: true
            color: logReader.logFileExists ? "#36d399" : "#ef4444"
        }
    }
    // Log File Path (if exists)
    Label {
        text: logReader.logFileExists ? "Path: " + logReader.logFilePath : "Configure Star Citizen directory in Settings"
        font.pixelSize: 10
        opacity: 0.8
        color: Theme.colors.textSecondary
        width: 400
        wrapMode: Text.Wrap
        visible: true
    }
    
    // Log Entry Viewer Component
    LogEntryViewer {
        id: logViewer
        width: parent.width
        height: Math.max(200, mainWindow.height * 0.9) // 60% of window height, minimum 200px
    }
}
