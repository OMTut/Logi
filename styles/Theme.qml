pragma Singleton
import QtQuick

QtObject {
    // Access to Colors singleton (imported relatively)
    readonly property QtObject colors: Colors
    
    // Typography
    readonly property FontLoader primaryFont: FontLoader {
        source: "qrc:/fonts/Roboto-Regular.ttf" // You can add custom fonts later
    }
    
    readonly property FontLoader monoFont: FontLoader {
        source: "qrc:/fonts/RobotoMono-Regular.ttf" // For code/data display
    }
    
    // Font Sizes
    readonly property int fontSizeXS: 10
    readonly property int fontSizeSM: 12
    readonly property int fontSizeMD: 14
    readonly property int fontSizeLG: 16
    readonly property int fontSizeXL: 18
    readonly property int fontSize2XL: 20
    readonly property int fontSize3XL: 24
    readonly property int fontSize4XL: 32
    
    // Spacing System (8px base unit)
    readonly property int spacing1: 4   // 0.5 units
    readonly property int spacing2: 8   // 1 unit
    readonly property int spacing3: 12  // 1.5 units
    readonly property int spacing4: 16  // 2 units
    readonly property int spacing6: 24  // 3 units
    readonly property int spacing8: 32  // 4 units
    readonly property int spacing12: 48 // 6 units
    readonly property int spacing16: 64 // 8 units
    readonly property int spacing20: 80 // 10 units
    
    // Border Radius
    readonly property int radiusSM: 4
    readonly property int radiusMD: 8
    readonly property int radiusLG: 12
    readonly property int radiusXL: 16
    readonly property int radiusFull: 9999
    
    // Elevation/Shadow (for future use)
    readonly property int elevation1: 2
    readonly property int elevation2: 4
    readonly property int elevation3: 8
    readonly property int elevation4: 16
    
    // Animation Durations
    readonly property int animationFast: 150
    readonly property int animationNormal: 300
    readonly property int animationSlow: 500
    
    // Easing Curves
    readonly property var easingStandard: Easing.OutCubic
    readonly property var easingDecelerate: Easing.OutQuart
    readonly property var easingAccelerate: Easing.InQuart
    
    // Component Specific Styles
    readonly property QtObject window: QtObject {
        readonly property color backgroundColor: colors.background
        readonly property int minWidth: 800
        readonly property int minHeight: 600
    }
    
    readonly property QtObject button: QtObject {
        readonly property color backgroundColor: colors.accent
        readonly property color backgroundHover: Qt.lighter(colors.accent, 1.1)
        readonly property color backgroundPressed: Qt.darker(colors.accent, 1.1)
        readonly property color backgroundDisabled: colors.surfaceVariant
        readonly property color text: colors.textPrimary
        readonly property int borderRadius: radiusMD
        readonly property int paddingHorizontal: spacing4
        readonly property int paddingVertical: spacing3
    }
    
    readonly property QtObject card: QtObject {
        readonly property color backgroundColor: colors.surface
        readonly property color borderColor: colors.border
        readonly property int borderRadius: radiusLG
        readonly property int borderWidth: 1
        readonly property int padding: spacing6
    }
}
