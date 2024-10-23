#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "CppInterface.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    CppInterface cppInterface;
    engine.rootContext()->setContextProperty("cppInterface", &cppInterface);

    // Determine deployment location
    bool isDeployedOnCloud = false;
#ifdef DEPLOYMENT_LOCATION_CLOUD
    isDeployedOnCloud = true;
#endif
    // Pass the build type information to QML
    engine.rootContext()->setContextProperty("isDeployedOnCloud", isDeployedOnCloud);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
