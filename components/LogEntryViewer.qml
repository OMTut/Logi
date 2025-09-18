import QtQuick
import QtQuick.Controls
import "../styles/Theme.js" as Theme

Rectangle {
    id: root
    // Remove fixed dimensions - let parent control sizing
    color: Theme.colors.background
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
            // Filter and clean Actor Death entries
            var filteredLines = []
            for (var j = 0; j < lines.length; j++) {
                if (lines[j].includes("<Actor Death>")) {
                    var cleanedEntry = cleanActorDeathEntry(lines[j])
                    filteredLines.push(cleanedEntry)
                }
            }
            
            // Add filtered entries at the beginning (newest first)
            for (var i = filteredLines.length - 1; i >= 0; i--) {
                root.logEntries.unshift(filteredLines[i])
            }
            // Trigger model update
            logListView.model = root.logEntries
            // Keep position at top (showing newest entries)
            Qt.callLater(function() {
                if (logListView.count > 0) {
                    logListView.positionViewAtBeginning()
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
    
    function cleanActorDeathEntry(entry) {
        // Extract and format timestamp to hours:minutes (UTC)
        var timestampEnd = entry.indexOf("> ")
        if (timestampEnd === -1) return { text: entry, isNPC: false }
        
        var fullTimestamp = entry.substring(0, timestampEnd + 1)
        // Extract time portion from <2025-09-04T16:06:49.576Z>
        var timeStart = fullTimestamp.indexOf("T") + 1
        var timeEnd = fullTimestamp.indexOf(":")
        var minuteEnd = fullTimestamp.indexOf(":", timeEnd + 1)
        var secondEnd = fullTimestamp.indexOf(".", minuteEnd + 1)
        
        if (timeStart > 0 && timeEnd > timeStart && minuteEnd > timeEnd && secondEnd > minuteEnd) {
            var hours = fullTimestamp.substring(timeStart, timeEnd)
            var minutes = fullTimestamp.substring(timeEnd + 1, minuteEnd)
            var seconds = fullTimestamp.substring(minuteEnd + 1, secondEnd)
            var timestamp = hours + ":" + minutes + ":" + seconds + " (UTC)"
        } else {
            // Fallback to original timestamp if parsing fails
            var timestamp = fullTimestamp
        }
        
        // Find the victim name after "CActor::Kill: '"
        var killIndex = entry.indexOf("CActor::Kill: '")
        if (killIndex === -1) return { text: entry, isNPC: false }
        
        var victimStart = killIndex + "CActor::Kill: '".length
        var victimEnd = entry.indexOf("'", victimStart)
        if (victimEnd === -1) return { text: entry, isNPC: false }
        
        var victimName = entry.substring(victimStart, victimEnd)
        var isNPCKill = false
        
        // Replace PU_ entries with "NPC" and mark as NPC kill
        if (victimName.startsWith("PU_")) {
            victimName = "NPC"
            isNPCKill = true
        }
        
        // Find and clean the killer name
        var killedByIndex = entry.indexOf("killed by '")
        if (killedByIndex !== -1) {
            var nameStart = killedByIndex + "killed by '".length
            var nameEnd = entry.indexOf("'", nameStart)
            
            if (nameEnd !== -1) {
                var killerName = entry.substring(nameStart, nameEnd)
                
                // Combine: timestamp + victim + "killed by" + killer (skip everything in between)
                var cleanedText = timestamp + " " + victimName + " killed by " + killerName
                return { text: cleanedText, isNPC: isNPCKill }
            }
        }
        
        // If parsing fails, return original entry
        return { text: entry, isNPC: false }
    }
    
    function loadInitialEntries() {
        // Don't load existing entries - start fresh!
        // Only show new entries that arrive after monitoring starts
    }
    
    Component.onCompleted: {
        // Load existing log lines when component starts
        loadInitialEntries()
    }
    
    // Status message when monitoring but no entries yet
    Label {
        id: statusMessage
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 8
        text: "Monitoring Actor Deaths..."
        color: Theme.colors.textSecondary
        font.pixelSize: Theme.fonts.sizeMD
        opacity: 0.7
        visible: logReader.monitoring && logListView.count === 0
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
                text: modelData.text
                color: modelData.isNPC ? Theme.colors.textMuted : Theme.colors.textPrimary
                wrapMode: Text.Wrap
                elide: Text.ElideRight
            }
        }
        
        ScrollBar.vertical: ScrollBar {
            active: true
            policy: ScrollBar.AlwaysOn
            
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
