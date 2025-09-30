#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include "src/ProcessChecker.h"
#include "src/Settings.h"
#include "src/LogReader.h"
#include "src/UpdateChecker.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    
    // Set application metadata for QSettings
    app.setApplicationName("Logi");
    app.setApplicationVersion("0.1.0");
    app.setOrganizationName("LogiApp");
    app.setOrganizationDomain("logi.app");
    
    // Set Qt Quick Controls style to Basic to allow customization
    QQuickStyle::setStyle("Basic");

    QQmlApplicationEngine engine;
    
    // Create Settings instance and expose it to QML as a context property
    Settings settings;
    engine.rootContext()->setContextProperty("appSettings", &settings);
    
    // Create ProcessChecker instance and expose it to QML as a context property
    ProcessChecker processChecker;
    engine.rootContext()->setContextProperty("processChecker", &processChecker);
    
    // Create LogReader instance and expose it to QML as a context property
    LogReader logReader;
    engine.rootContext()->setContextProperty("logReader", &logReader);
    
    // Create UpdateChecker instance and expose it to QML as a context property
    UpdateChecker updateChecker;
    engine.rootContext()->setContextProperty("updateChecker", &updateChecker);
    
    // Connect settings to log reader for automatic log file discovery
    QObject::connect(&settings, &Settings::starCitizenDirectoryChanged, [&]() {
        QString directory = settings.starCitizenDirectory();
        if (!directory.isEmpty()) {
            logReader.findLogFile(directory);
        }
    });
    
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Logi", "Main");

    return app.exec();
}
