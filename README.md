# Overlay Starter Application
A Qt Quick overlay application featuring a window that stays on top of other applications. I started working on a game overlay but decided to polish the window as a starting application.

## ✨ Features

- **Always On Top**: Overlay window that stays above other applications
- **Dynamic Opacity**: Automatically adjusts transparency based on mouse hover
  - 50% opacity when not in focus (overlay mode)
  - 100% opacity when hovering (interaction mode)
- **Borderless Design**: Clean, modern interface without traditional window decorations
- **Custom Title Bar**: Draggable title bar with minimize/close controls
- **Resizable Layout**: Drag the bottom right corner to resize the window with content awareness
- **Scrollable Content**: Content can be scrolled
- **Smooth Animations**: Fluid transitions and hover effects

## 🚀 Quick Start

### Prerequisites

- **Qt 6.9.2** or later with MinGW 64-bit
- **CMake 3.16** or later
- **Windows 10/11** (currently Windows-only)

### Building

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd OverLayAppStarter
   ```

2. **Configure with CMake**
   ```bash
   cmake -B build -S . -DCMAKE_BUILD_TYPE=Release
   ```

3. **Build the application**
   ```bash
   cmake --build build --config Release
   ```

4. **Run the application**
   ```bash
   .\build\Release\appOverlayStarter.exe
   ```

### Development Build

For development with Qt Creator:
1. Open `CMakeLists.txt` in Qt Creator
2. Configure with Desktop Qt 6.9.2 MinGW 64-bit kit
3. Build and run (Ctrl+R)

## Architecture

### Project Structure

```
Logi/
├── main.cpp                    # Application entry point
├── Main.qml                     # Main window and layout
├── CMakeLists.txt              # Build configuration
├── components/                 # Reusable QML components
│   ├── CustomTitleBar.qml      # Custom title bar with controls
│   └── ResizeHandles.qml       # Window resize functionality
└── styles/                     # Centralized theming
    └── Theme.js                # Design system (colors, fonts, spacing)
```

### Design System

The app uses a centralized theming approach with `Theme.js` containing:

- **Colors**: Star Citizen-inspired dark palette with blue accents
- **Typography**: Consistent font sizing scale
- **Spacing**: 8px-based spacing system
- **Layout**: Responsive layout constants
- **Components**: Reusable style definitions

### Key Technologies

- **Qt Quick**: Modern declarative UI framework
- **QML**: Declarative markup for user interfaces
- **JavaScript**: Theme system and component logic
- **CMake**: Cross-platform build system
- **Qt Quick Controls**: Native-feeling UI components

## Theming

### Color Palette

- **Background**: `#0d1117` (Dark space)
- **Surface**: `#1c2128` (Card backgrounds)
- **Accent**: `#4a90e2` (Star Citizen blue)
- **Text Primary**: `#f0f6fc` (White)
- **Text Secondary**: `#8b949e` (Gray)
- **Error**: `#ef4444` (Red for close button)

### Customizing Theme

Edit `styles/Theme.js` to modify:
- Colors and visual styling
- Font sizes and typography
- Spacing and layout values
- Component-specific styles

## Configuration

### Window Behavior

- **Opacity States**: Modify in `Theme.js` → `opacity` object
- **Window Size**: Adjust `minWidth`/`minHeight` in `Theme.js` → `window`
- **Transition Speed**: Change `transitionDuration` for animation timing

### Layout Customization

- **Content Margins**: Adjust `layout.contentTopMargin`, etc.
- **Title Bar Height**: Modify `layout.titleBarHeight`
- **Spacing System**: Update `spacing` object for consistent gaps

### Development Guidelines

- Follow existing code style and organization
- Use the centralized Theme.js for all styling
- Keep components focused and reusable
- Test on different window sizes
- Ensure smooth animations and transitions

## Acknowledgments

- **Qt Project** - Excellent framework for modern applications
- **Qt Quick** - Powerful declarative UI toolkit

---
