#include <QCommandLineParser>
#include <QDebug>
#include <QDir>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>

#include "ClusterDataSubscriber.hpp"
#include "ClusterModel.hpp"

/**
 * @brief Main entry point for the Automotive Cluster Display application
 *
 * Sets up the Qt application, registers the cluster model with QML,
 * and loads the main QML interface.
 */
int main(int argc, char* argv[]) {
  // Create Qt application
  QGuiApplication app(argc, argv);
  app.setApplicationName("Automotive Cluster Display");
  app.setApplicationVersion("2.0");
  app.setOrganizationName("Team06");

  // Set up command line options
  QCommandLineParser parser;
  parser.setApplicationDescription("Automotive Cluster Display");
  parser.addHelpOption();
  parser.addVersionOption();

  // Add option to enable mocking (default: disabled - use real ZMQ data)
  QCommandLineOption mockOption(QStringList() << "m" << "mock",
                                "Enable data mocking (no ZeroMQ needed)");
  parser.addOption(mockOption);

  // Process the command line
  parser.process(app);
  bool enableMocking = parser.isSet(mockOption);

  // Apply Material Design style for modern look
  QQuickStyle::setStyle("Material");

  // Create and initialize the cluster data model
  ClusterModel clusterModel;

  // Create the cluster data subscriber
  ClusterDataSubscriber dataSubscriber(&clusterModel);

  // Enable mocking if specified on command line
  dataSubscriber.enableMocking(enableMocking);

  // Output mode to console
  if (enableMocking) {
    qDebug() << "Running in MOCK mode (no ZeroMQ connection needed)";
  } else {
    qDebug() << "Running in LIVE mode (expecting ZeroMQ data on ports 5555 and 5556)";
  }

  // Set up QML engine and expose the model to QML
  QQmlApplicationEngine engine;
  engine.rootContext()->setContextProperty("clusterModel", &clusterModel);

  // Load the main QML interface
  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

  // Check if QML loaded successfully
  if (engine.rootObjects().isEmpty()) {
    qCritical() << "Failed to load QML interface";
    return -1;
  }

  // Start the application event loop
  return app.exec();
}
