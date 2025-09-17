import QtQuick
import QtQuick.Controls.Basic
import "../styles/Theme.js" as Theme

ScrollBar {
    id: scrollBar
    
    // Custom styling properties
    property int customWidth: Theme.layout.scrollBarWidth || 8
    
    // Size and positioning
    implicitWidth: customWidth
    
    // Custom background
    background: Rectangle {
        color: Theme.colors.surfaceVariant
        radius: customWidth / 2
        
        // Subtle border for definition
        border.color: Theme.colors.border
        border.width: 1
        opacity: scrollBar.pressed ? 0.4 : scrollBar.hovered ? 0.3 : 0.2
        
        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }
    }
    
    // Custom handle (the draggable part)
    contentItem: Rectangle {
        color: scrollBar.pressed ? Qt.lighter(Theme.colors.accent, 1.2) :
               scrollBar.hovered ? Theme.colors.accent :
               Qt.darker(Theme.colors.accent, 1.2)
        
        radius: customWidth / 2
        
        // Responsive dimensions - let ScrollBar control the size
        implicitWidth: customWidth
        // Remove fixed implicitHeight to allow automatic sizing
        
        // Smooth color transitions
        Behavior on color {
            ColorAnimation { duration: 150 }
        }
        
        // Optional: subtle glow effect when active
        Rectangle {
            anchors.centerIn: parent
            width: parent.width - 2
            height: parent.height - 2
            radius: parent.radius
            color: "transparent"
            border.color: Theme.colors.accent
            border.width: scrollBar.pressed ? 1 : 0
            opacity: 0.5
            
            Behavior on border.width {
                NumberAnimation { duration: 100 }
            }
        }
    }
    
    // Auto-hide when not needed
    policy: ScrollBar.AsNeeded
    
    // Smooth scrolling behavior
    minimumSize: 0.1
}
