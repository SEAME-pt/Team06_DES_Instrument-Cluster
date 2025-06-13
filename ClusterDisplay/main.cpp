#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include <QFontDatabase>
#include <QDir>
#include <QDebug>
#include "ClusterModel.hpp"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Set application properties
    app.setApplicationName("Automotive Cluster Display");
    app.setApplicationVersion("2.0");
    app.setOrganizationName("Team06");

    // Set modern Qt Quick style
    QQuickStyle::setStyle("Material");

    // Create cluster model instance
    ClusterModel clusterModel;

    // Set up QML engine
    QQmlApplicationEngine engine;

    // Register cluster model with QML
    engine.rootContext()->setContextProperty("clusterModel", &clusterModel);

    // Load the main QML file
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
