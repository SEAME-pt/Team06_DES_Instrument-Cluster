#include <QDebug>
#include <QDir>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>

#include "ClusterModel.hpp"

/**
 * @brief Main entry point for the Automotive Cluster Display application
 *
 * Sets up the Qt application, registers the cluster model with QML,
 * and loads the main QML interface.
 */
int main(int argc, char *argv[])
{
    // Create Qt application
    QGuiApplication app(argc, argv);
    app.setApplicationName("Automotive Cluster Display");
    app.setApplicationVersion("2.0");
    app.setOrganizationName("Team06");

    // Apply Material Design style for modern look
    QQuickStyle::setStyle("Material");

    // Create and initialize the cluster data model
    ClusterModel clusterModel;

    // Set up QML engine and expose the model to QML
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("clusterModel", &clusterModel);

    // Load the main QML interface
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    // Check if QML loaded successfully
    if (engine.rootObjects().isEmpty())
    {
        qCritical() << "Failed to load QML interface";
        return -1;
    }

    // Start the application event loop
    return app.exec();
}
