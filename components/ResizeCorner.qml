import QtQuick
import "../styles/Theme.js" as Theme

Rectangle {
    id: root
    
    // Properties that can be set from parent
    property var targetWindow
    
    width: Theme.layout.resizeHandleSize
    height: Theme.layout.resizeHandleSize
    color: "transparent"
    
    // Visual indicator
    Canvas {
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.strokeStyle = Theme.colors.border
            ctx.lineWidth = 1
            
            // Draw resize lines
            ctx.beginPath()
            ctx.moveTo(width - 4, height)
            ctx.lineTo(width, height - 4)
            ctx.moveTo(width - 8, height)
            ctx.lineTo(width, height - 8)
            ctx.moveTo(width - 12, height)
            ctx.lineTo(width, height - 12)
            ctx.stroke()
        }
    }
    
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.SizeFDiagCursor
        
        property point startPos
        property size startSize
        
        onPressed: function(mouse) {
            if (!targetWindow) return
            
            startPos = Qt.point(mouse.x, mouse.y)
            startSize = Qt.size(targetWindow.width, targetWindow.height)
        }
        
        onPositionChanged: function(mouse) {
            if (!pressed || !targetWindow) return
            
            var deltaX = mouse.x - startPos.x
            var deltaY = mouse.y - startPos.y
            
            var newWidth = startSize.width + deltaX
            var newHeight = startSize.height + deltaY
            
            if (newWidth >= targetWindow.minimumWidth) {
                targetWindow.width = newWidth
            }
            if (newHeight >= targetWindow.minimumHeight) {
                targetWindow.height = newHeight
            }
        }
    }
}