// Theme.js.pragma library


const colors = {
    // Primary Colors
    scBlue: "#1e3a5f",         // blue
    scLightBlue: "#4a90e2",    // Lighter blue accent
    scDarkBlue: "#0f1d2f",     // Deep space blue
    
    // UI Colors
    background: "#0d1117",     // Dark background
    surface: "#1c2128",        // Card/panel background
    surfaceVariant: "#2d333b", // Elevated surfaces
    
    // Accent Colors
    accent: "#4a90e2",         // Primary accent
    accentSecondary: "#7c3aed", // Purple accent
    warning: "#f59e0b",        // Orange/amber warning
    success: "#10b981",        // Green success
    error: "#ef4444",          // Red error
    
    // Text Colors
    textPrimary: "#f0f6fc",    // Primary text (white)
    textSecondary: "#8b949e",  // Secondary text (gray)
    textMuted: "#6e7681",      // Muted text
    
    // Border Colors
    border: "#30363d",         // Default borders
    borderFocus: "#4a90e2"     // Focused borders
};

// Font Sizes
const fonts = {
    sizeXS: 10,
    sizeSM: 12,
    sizeMD: 14,
    sizeLG: 16,
    sizeXL: 18,
    size2XL: 20,
    size3XL: 24,
    size4XL: 32
};

// Spacing System (8px base unit)
const spacing = {
    s1: 4,   // 0.5 units
    s2: 8,   // 1 unit
    s3: 12,  // 1.5 units
    s4: 16,  // 2 units
    s6: 24,  // 3 units
    s8: 32,  // 4 units
    s12: 48, // 6 units
    s16: 64, // 8 units
    s20: 80  // 10 units
};

// Border Radius
const radius = {
    sm: 4,
    md: 8,
    lg: 12,
    xl: 16,
    full: 9999
};

// Opacity values for window states
const opacity = {
    hidden: 0.5,    // Semi-transparent overlay mode
    focused: 1.0,   // Full visibility when interacting
    transition: 300 // Animation duration in milliseconds
};

// Layout System - centralized spacing and positioning
const layout = {
    // Window layout constants
    titleBarHeight: 32,
    titleBarPadding: 8,
    
    // Content area margins
    contentTopMargin: 40,  // Your preferred title bar + padding
    contentBottomMargin: 25, // Resize handle + padding
    contentSideMargin: spacing.s4,
    
    // Component sizing
    resizeHandleSize: 20,
    scrollBarWidth: 10,
    
    // Content constraints
    maxContentWidth: 400,
    minContentPadding: spacing.s8
};

// Component Specific Styles
const window = {
    backgroundColor: colors.background,
    minWidth: 800,
    minHeight: 600,
    opacityHidden: opacity.hidden,
    opacityFocused: opacity.focused,
    transitionDuration: opacity.transition,
    
    // Layout integration
    layout: layout
};

const button = {
    backgroundColor: colors.accent,
    text: colors.textPrimary,
    borderRadius: radius.md,
    paddingHorizontal: spacing.s4,
    paddingVertical: spacing.s3
};

const card = {
    backgroundColor: colors.surface,
    borderColor: colors.border,
    borderRadius: radius.lg,
    borderWidth: 1,
    padding: spacing.s6
};
