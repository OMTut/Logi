cmake_minimum_required(VERSION 3.16)

project(Logi VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 Network)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appLogi
    main.cpp
    src/ProcessChecker.cpp
    src/Settings.cpp
    src/LogReader.cpp
    src/UpdateChecker.cpp
)

# Add resources
qt_add_resources(appLogi "resources"
    PREFIX "/"
    FILES
        resources/Logo_Logi_v1_desktop.ico
)

qt_add_qml_module(appLogi
    URI Logi
    VERSION 1.0
    QML_FILES
        Main.qml
        components/CustomTitleBar.qml
        components/ResizeHandles.qml
        components/StatusIndicator.qml
        components/SettingsDialog.qml
        components/SettingsWindow.qml
        components/LogEntryViewer.qml
        components/UpdateBanner.qml
        components/ResizeCorner.qml

    RESOURCES
        styles/Theme.js
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appLogi PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appLogi
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# Define PROJECT_VERSION as a compile-time definition
target_compile_definitions(appLogi PRIVATE 
    PROJECT_VERSION="${PROJECT_VERSION}"
)

target_link_libraries(appLogi
    PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::Network
)

# Testing support
enable_testing()
add_subdirectory(tests)

include(GNUInstallDirs)
install(TARGETS appLogi
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
