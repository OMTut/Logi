import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import "styles/Theme.js" as Theme
import "components"

Window {
    id: mainWindow
    width: Theme.window.minWidth
    height: Theme.window.minHeight
    visible: true
    title: qsTr("Logi")
    color: Theme.window.backgroundColor
    
    // Borderless window for overlay
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    
    // Window opacity management - Start in overlay mode
    opacity: Theme.window.opacityHidden
    
    // Optional: Set minimum size
    minimumWidth: 540
    minimumHeight: 280
    
    // Smooth opacity transitions
    Behavior on opacity {
        NumberAnimation {
            duration: Theme.window.transitionDuration
            easing.type: Easing.OutCubic
        }
    }
    
    // Main content area
    Rectangle {
        id: mainContentArea
        anchors.fill: parent
        color: Theme.colors.background
        
        // Window-wide hover detection
        HoverHandler {
            id: mainHoverHandler
            enabled: !settingsWindow.visible
            onHoveredChanged: {
                if (hovered) {
                    mainWindow.opacity = Theme.window.opacityFocused
                } else {
                    mainWindow.opacity = Theme.window.opacityHidden
                }
            }
        }
        
        // Custom title bar
        CustomTitleBar {
            id: customTitleBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            
            title: "Logi -"
            targetWindow: mainWindow
            windowOpacity: mainWindow.opacity
            showOpacity: true
        }
        
        // Update notification banner - positioned below title bar
        Rectangle {
            id: updateBannerWrapper
            anchors.top: customTitleBar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 5  // Add space between title bar and banner
            height: updateChecker.updateAvailable ? 50 : 0

            
            Behavior on height {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
            
            UpdateBanner {
                id: updateBanner
                anchors.fill: parent
                updateChecker: updateChecker
            }
        }
        
        // Settings button overlay on top of title bar
        Button {
            id: settingsButton
            width: 30
            height: 30
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: (Theme.layout.titleBarHeight - height) / 2
            anchors.rightMargin: 35 // Leave space for window controls
            z: 15 // Ensure it's above everything
            
            background: Rectangle {
                color: parent.pressed ? Qt.darker(Theme.colors.accent, 1.3) :
                       parent.hovered ? Theme.colors.accent : "transparent"
                radius: 4
                opacity: parent.hovered || parent.pressed ? 0.8 : 0.5
            }
            
            contentItem: Text {
                text: "⚙"
                color: Theme.colors.textPrimary
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            ToolTip.visible: hovered
            ToolTip.text: "Settings"
            ToolTip.delay: 500
            
            onClicked: {
                settingsWindow.show()
                settingsWindow.raise()
                settingsWindow.requestActivate()
            }
        }
        
        // Resize corner (bottom-right)
        ResizeCorner {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            targetWindow: mainWindow
        }
        
        
        // Scrollable content area that flows below update banner
        ScrollView {
            anchors.top: updateBannerWrapper.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.topMargin: Theme.layout.contentSideMargin
            anchors.bottomMargin: Theme.layout.contentBottomMargin
            anchors.leftMargin: Theme.layout.contentSideMargin
            anchors.rightMargin: Theme.layout.contentSideMargin
            
            contentWidth: -1  // Use ScrollView width
            contentHeight: statusIndicator.height
            
            // Hide scroll bars but keep scrolling functionality
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            StatusIndicator {
                id: statusIndicator
                width: parent.width
                height: parent.height
            }
        }
    }
    
    // Auto-check for updates when app starts
    Component.onCompleted: {
        // Delay the check slightly to let the app finish loading
        Qt.callLater(updateChecker.checkForUpdates)
    }
    
    // Settings Window
    SettingsWindow {
        id: settingsWindow
        mainWindow: mainWindow
        mainHoverHandler: mainHoverHandler
    }
}
