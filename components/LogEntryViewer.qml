import QtQuick
import QtQuick.Controls
import "../styles/Theme.js" as Theme

Rectangle {
    id: root
    // Remove fixed dimensions - let parent control sizing
    color: Theme.colors.scDarkBlue
    border.color: Theme.colors.border
    border.width: 0
    radius: 0
    visible: logReader.monitoring
    
    // Store log entries
    property var logEntries: []
    
    // Connect to LogReader signals to capture new log lines
    Connections {
        target: logReader
        function onNewLogLinesAvailable(lines) {
            for (var i = 0; i < lines.length; i++) {
                root.logEntries.push(lines[i])
            }
            // Trigger model update
            logListView.model = root.logEntries
            // Auto-scroll to bottom
            Qt.callLater(function() {
                if (logListView.count > 0) {
                    logListView.positionViewAtEnd()
                }
            })
        }
        
        function onLogFileExistsChanged() {
            // Just clear the view when log file state changes
            root.logEntries = []
            logListView.model = root.logEntries
        }
        
        function onMonitoringChanged() {
            // Clear view when monitoring starts/stops
            if (logReader.monitoring) {
                root.logEntries = []
                logListView.model = root.logEntries
            }
        }
    }
    
    function loadInitialEntries() {
        // Don't load existing entries - start fresh!
        // Only show new entries that arrive after monitoring starts
    }
    
    Component.onCompleted: {
        // Load existing log lines when component starts
        loadInitialEntries()
    }
    
    // Log entries list
    ListView {
        id: logListView
        anchors.fill: parent
        model: root.logEntries
        clip: true
        
        delegate: Item {
            width: logListView.width
            height: logText.contentHeight + 8
            
            Label {
                id: logText
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 4
                text: modelData
                color: Theme.colors.textPrimary
                wrapMode: Text.Wrap
                elide: Text.ElideRight
            }
        }
        
        ScrollBar.vertical: ScrollBar {
            active: true
            policy: ScrollBar.AsNeeded
            
            background: Rectangle {
                color: Theme.colors.background
                radius: 4
            }
            
            contentItem: Rectangle {
                color: Theme.colors.border
                radius: 4
            }
        }
    }
}
