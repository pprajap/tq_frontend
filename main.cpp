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

    // Determine if the build is for WebAssembly
    bool isWasmBuild = false;
#ifdef BUILD_TYPE_WASM
    isWasmBuild = true;
#endif
    // Pass the build type information to QML
    engine.rootContext()->setContextProperty("isWasmBuild", isWasmBuild);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
