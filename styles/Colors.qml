pragma Singleton
import QtQuick

QtObject {
    // Star Citizen inspired color palette
    
    // Primary Colors
    readonly property color scBlue: "#1e3a5f"         // Star Citizen's signature blue
    readonly property color scLightBlue: "#4a90e2"   // Lighter blue accent
    readonly property color scDarkBlue: "#0f1d2f"    // Deep space blue
    
    // UI Colors
    readonly property color background: "#0d1117"     // Dark space background
    readonly property color surface: "#1c2128"       // Card/panel background
    readonly property color surfaceVariant: "#2d333b" // Elevated surfaces
    
    // Accent Colors
    readonly property color accent: "#4a90e2"         // Primary accent
    readonly property color accentSecondary: "#7c3aed" // Purple accent
    readonly property color warning: "#f59e0b"        // Orange/amber warning
    readonly property color success: "#10b981"        // Green success
    readonly property color error: "#ef4444"          // Red error
    
    // Text Colors
    readonly property color textPrimary: "#f0f6fc"    // Primary text (white)
    readonly property color textSecondary: "#8b949e"  // Secondary text (gray)
    readonly property color textMuted: "#6e7681"      // Muted text
    
    // Border Colors
    readonly property color border: "#30363d"         // Default borders
    readonly property color borderFocus: "#4a90e2"   // Focused borders
    
    // Transparency variations
    readonly property real opacity15: 0.15
    readonly property real opacity25: 0.25
    readonly property real opacity50: 0.50
    readonly property real opacity75: 0.75
}
