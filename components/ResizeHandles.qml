import QtQuick
import "../styles/Theme.js" as Theme

Item {
    id: resizeHandles
    
    property Window targetWindow: null
    property int handleSize: 8
    property int cornerSize: 16
    
    // Top edge
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: handleSize
        color: "transparent"
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeVerCursor
            
            property point startPos
            property int startHeight
            property int startY
            
            onPressed: {
                startPos = Qt.point(mouse.x, mouse.y)
                startHeight = targetWindow.height
                startY = targetWindow.y
            }
            
            onMouseYChanged: {
                if (pressed && targetWindow) {
                    var deltaY = mouse.y - startPos.y
                    var newHeight = startHeight - deltaY
                    var newY = startY + deltaY
                    
                    if (newHeight >= targetWindow.minimumHeight) {
                        targetWindow.height = newHeight
                        targetWindow.y = newY
                    }
                }
            }
        }
    }
    
    // Bottom edge
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: handleSize
        color: "transparent"
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeVerCursor
            
            property point startPos
            property int startHeight
            
            onPressed: {
                startPos = Qt.point(mouse.x, mouse.y)
                startHeight = targetWindow.height
            }
            
            onMouseYChanged: {
                if (pressed && targetWindow) {
                    var deltaY = mouse.y - startPos.y
                    var newHeight = startHeight + deltaY
                    
                    if (newHeight >= targetWindow.minimumHeight) {
                        targetWindow.height = newHeight
                    }
                }
            }
        }
    }
    
    // Left edge
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: handleSize
        color: "transparent"
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeHorCursor
            
            property point startPos
            property int startWidth
            property int startX
            
            onPressed: {
                startPos = Qt.point(mouse.x, mouse.y)
                startWidth = targetWindow.width
                startX = targetWindow.x
            }
            
            onMouseXChanged: {
                if (pressed && targetWindow) {
                    var deltaX = mouse.x - startPos.x
                    var newWidth = startWidth - deltaX
                    var newX = startX + deltaX
                    
                    if (newWidth >= targetWindow.minimumWidth) {
                        targetWindow.width = newWidth
                        targetWindow.x = newX
                    }
                }
            }
        }
    }
    
    // Right edge
    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: handleSize
        color: "transparent"
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeHorCursor
            
            property point startPos
            property int startWidth
            
            onPressed: {
                startPos = Qt.point(mouse.x, mouse.y)
                startWidth = targetWindow.width
            }
            
            onMouseXChanged: {
                if (pressed && targetWindow) {
                    var deltaX = mouse.x - startPos.x
                    var newWidth = startWidth + deltaX
                    
                    if (newWidth >= targetWindow.minimumWidth) {
                        targetWindow.width = newWidth
                    }
                }
            }
        }
    }
    
    // Corner handles for diagonal resizing
    
    // Top-left corner
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        width: cornerSize
        height: cornerSize
        color: "transparent"
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeFDiagCursor
            
            property point startPos
            property int startWidth
            property int startHeight
            property int startX
            property int startY
            
            onPressed: {
                startPos = Qt.point(mouse.x, mouse.y)
                startWidth = targetWindow.width
                startHeight = targetWindow.height
                startX = targetWindow.x
                startY = targetWindow.y
            }
            
            onPositionChanged: {
                if (pressed && targetWindow) {
                    var deltaX = mouse.x - startPos.x
                    var deltaY = mouse.y - startPos.y
                    
                    var newWidth = startWidth - deltaX
                    var newHeight = startHeight - deltaY
                    var newX = startX + deltaX
                    var newY = startY + deltaY
                    
                    if (newWidth >= targetWindow.minimumWidth && newHeight >= targetWindow.minimumHeight) {
                        targetWindow.width = newWidth
                        targetWindow.height = newHeight
                        targetWindow.x = newX
                        targetWindow.y = newY
                    }
                }
            }
        }
    }
    
    // Top-right corner
    Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        width: cornerSize
        height: cornerSize
        color: "transparent"
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeBDiagCursor
            
            property point startPos
            property int startWidth
            property int startHeight
            property int startY
            
            onPressed: {
                startPos = Qt.point(mouse.x, mouse.y)
                startWidth = targetWindow.width
                startHeight = targetWindow.height
                startY = targetWindow.y
            }
            
            onPositionChanged: {
                if (pressed && targetWindow) {
                    var deltaX = mouse.x - startPos.x
                    var deltaY = mouse.y - startPos.y
                    
                    var newWidth = startWidth + deltaX
                    var newHeight = startHeight - deltaY
                    var newY = startY + deltaY
                    
                    if (newWidth >= targetWindow.minimumWidth && newHeight >= targetWindow.minimumHeight) {
                        targetWindow.width = newWidth
                        targetWindow.height = newHeight
                        targetWindow.y = newY
                    }
                }
            }
        }
    }
    
    // Bottom-left corner
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: cornerSize
        height: cornerSize
        color: "transparent"
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeBDiagCursor
            
            property point startPos
            property int startWidth
            property int startHeight
            property int startX
            
            onPressed: {
                startPos = Qt.point(mouse.x, mouse.y)
                startWidth = targetWindow.width
                startHeight = targetWindow.height
                startX = targetWindow.x
            }
            
            onPositionChanged: {
                if (pressed && targetWindow) {
                    var deltaX = mouse.x - startPos.x
                    var deltaY = mouse.y - startPos.y
                    
                    var newWidth = startWidth - deltaX
                    var newHeight = startHeight + deltaY
                    var newX = startX + deltaX
                    
                    if (newWidth >= targetWindow.minimumWidth && newHeight >= targetWindow.minimumHeight) {
                        targetWindow.width = newWidth
                        targetWindow.height = newHeight
                        targetWindow.x = newX
                    }
                }
            }
        }
    }
    
    // Bottom-right corner
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: cornerSize
        height: cornerSize
        color: "transparent"
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeFDiagCursor
            
            property point startPos
            property int startWidth
            property int startHeight
            
            onPressed: {
                startPos = Qt.point(mouse.x, mouse.y)
                startWidth = targetWindow.width
                startHeight = targetWindow.height
            }
            
            onPositionChanged: {
                if (pressed && targetWindow) {
                    var deltaX = mouse.x - startPos.x
                    var deltaY = mouse.y - startPos.y
                    
                    var newWidth = startWidth + deltaX
                    var newHeight = startHeight + deltaY
                    
                    if (newWidth >= targetWindow.minimumWidth && newHeight >= targetWindow.minimumHeight) {
                        targetWindow.width = newWidth
                        targetWindow.height = newHeight
                    }
                }
            }
        }
    }
}
