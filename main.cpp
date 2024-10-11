#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "CppInterface.h"

/**
 * @file main.cpp
 * @brief Entry point for the tq_frontend application.
 *
 * This file contains the main function which initializes the QGuiApplication,
 * sets up the QQmlApplicationEngine, and loads the main QML file.
 * It also exposes the CppInterface to QML.
 *
 * @param argc Number of command-line arguments.
 * @param argv Array of command-line arguments.
 * @return int Returns the exit status of the application.
 */
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    CppInterface cppInterface;
    engine.rootContext()->setContextProperty("cppInterface", &cppInterface);

    engine.load(QUrl(QStringLiteral("qrc:/tq_frontend/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
