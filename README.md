# Logi
A Star Citizen log monitoring overlay application that tracks actor deaths and game events in real-time. Built with Qt Quick, Logi provides an always-on-top overlay window that monitors your Star Citizen game logs and displays death events with smooth animations.

## Features

### Core Functionality
- **Real-time Log Monitoring**: Automatically detects and monitors Star Citizen log files
- **Game Process Detection**: Tracks when Star Citizen is running
- **Death Event Tracking**: Displays actor death events from game logs
- **Log File Status**: Shows current log file path and monitoring status

### Overlay Interface
- **Always On Top**: Overlay window that stays above other applications
- **Dynamic Opacity**: Automatically adjusts transparency based on mouse hover
  - 20% opacity when not in focus (overlay mode)
  - 100% opacity when hovering (interaction mode)
- **Custom Title Bar**: Draggable title bar with minimize/close controls
- **Resizable Layout**: Drag the bottom right corner to resize the window
- **Scrollable Log Viewer**: Browse through captured death events

### Update System
- **Automatic Update Checks**: Fetches version information from remote version.json
- **Update Notifications**: Displays update banner with Release Notes and Download buttons
- **Required Updates**: Forces app update when critical updates are available
- **Blocked Functionality**: Hides main features when required updates are pending

## Quick Start

### Prerequisites

- **Qt 6.9.2** or later with MinGW 64-bit
- **CMake 3.16** or later
- **Windows 10/11** (currently Windows-only)
- **Star Citizen** installed (for log monitoring functionality)

### Building

1. **Clone the repository**
   ```bash
   git clone https://github.com/OMTut/Logi.git
   cd Logi
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
   .\build\Release\Logi.exe
   ```

### First-Time Setup

1. **Configure Star Citizen Directory**
   - Click the settings gear icon in the title bar
   - Browse and select your Star Citizen installation directory

2. **Start Monitoring**
   - Launch Star Citizen
   - Launch Logi
   - Logi will automatically detect when the game is running
   - Death events will appear in the log viewer as they occur

### Development Build

For development with Qt Creator:
1. Open `CMakeLists.txt` in Qt Creator
2. Configure with Desktop Qt 6.9.2 MinGW 64-bit kit
3. Build and run (Ctrl+R)

## Architecture



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
- **C++**: Backend logic for file monitoring and process detection
- **JavaScript**: Theme system and component logic
- **CMake**: Cross-platform build system
- **Qt Quick Controls**: Native-feeling UI components
- **QNetworkAccessManager**: HTTP requests for update checking
- **QFileSystemWatcher**: Real-time log file monitoring

## Acknowledgments

- **Qt Project** - framework for applications
- **Qt Quick** - declarative UI toolkit
- **Star Citizen Community** - For inspiration and feedback
- **Cloud Imperium Games** - For creating the Star Citizen universe

## License

This project is open source and available under the MIT License.

---
