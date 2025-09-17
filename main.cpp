#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include "src/ProcessChecker.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    
    // Set Qt Quick Controls style to Basic to allow customization
    QQuickStyle::setStyle("Basic");

    QQmlApplicationEngine engine;
    
    // Create ProcessChecker instance and expose it to QML as a context property
    ProcessChecker processChecker;
    engine.rootContext()->setContextProperty("processChecker", &processChecker);
    
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Logi", "Main");

    return app.exec();
}
