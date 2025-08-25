#include "ClusterDataSubscriber.hpp"
#include <QTimer>
#include <QDateTime>
#include <QRandomGenerator>

// Connection string templates
const QString CRITICAL_DATA_ADDRESS = "tcp://100.93.45.188:%1";
const QString NON_CRITICAL_DATA_ADDRESS = "tcp://100.93.45.188:%1";

ClusterDataSubscriber::ClusterDataSubscriber(ClusterModel* clusterModel, QObject* parent)
    : QObject(parent)
    , m_clusterModel(clusterModel)
    , m_parser(this)
    , m_mockingEnabled(false)
{
    // Create critical data subscriber (for speed, lane, etc.)
    m_criticalSub = std::make_unique<ZmqSubscriber>(
        CRITICAL_DATA_ADDRESS.arg(CRITICAL_DATA_PORT), this);
    connect(m_criticalSub.get(), &ZmqSubscriber::messageReceived,
            this, &ClusterDataSubscriber::handleCriticalData);

    // Create non-critical data subscriber (for battery, charging, etc.)
    m_nonCriticalSub = std::make_unique<ZmqSubscriber>(
        NON_CRITICAL_DATA_ADDRESS.arg(NON_CRITICAL_DATA_PORT), this);
    connect(m_nonCriticalSub.get(), &ZmqSubscriber::messageReceived,
            this, &ClusterDataSubscriber::handleNonCriticalData);

    // Create mock timer but don't start it yet
    m_mockTimer = new QTimer(this);
    m_mockTimer->setInterval(500); // Update every 500ms
    connect(m_mockTimer, &QTimer::timeout, this, &ClusterDataSubscriber::generateMockData);
}

ClusterDataSubscriber::~ClusterDataSubscriber()
{
    // Stop mock timer if running
    if (m_mockTimer->isActive()) {
        m_mockTimer->stop();
    }
}

void ClusterDataSubscriber::enableMocking(bool enable)
{
    if (m_mockingEnabled == enable) {
        return; // No change
    }

    m_mockingEnabled = enable;

    if (m_mockingEnabled) {
        // Start mock timer
        m_mockTimer->start();
    } else {
        // Stop mock timer
        m_mockTimer->stop();
    }
}

bool ClusterDataSubscriber::isMockingEnabled() const
{
    return m_mockingEnabled;
}

void ClusterDataSubscriber::handleCriticalData(const QString& message)
{
    if (!m_mockingEnabled) {
        // Parse and process message
        QMap<QString, QString> data = m_parser.parseMessage(message);
        processData(data);
    }
}

void ClusterDataSubscriber::handleNonCriticalData(const QString& message)
{
    if (!m_mockingEnabled) {
        // Parse and process message
        QMap<QString, QString> data = m_parser.parseMessage(message);
        processData(data);
    }
}

void ClusterDataSubscriber::generateMockData()
{
    if (!m_mockingEnabled) {
        return;
    }

    QMap<QString, QString> mockData;

    // Mock critical data (speed, lane, signal, etc.)
    static qreal angle = 0;
    int speed = qRound(100 + 100 * qSin(angle));
    angle += 0.1;
    mockData["speed"] = QString::number(speed);

    // Lane detection (1 for left, 2 for right, alternating)
    static int laneCounter = 0;
    if (++laneCounter >= 40) { // Change lane every 20 seconds
        laneCounter = 0;
        mockData["lane"] = QString::number(QRandomGenerator::global()->bounded(1, 3));
        // Add obstacle detection occasionally
        if (QRandomGenerator::global()->bounded(3) == 0) {
            // Generate either obs:1 or obs:2 for testing
            int obsValue = QRandomGenerator::global()->bounded(1, 3); // 1 or 2
            mockData["obs"] = QString::number(obsValue);
        }
    }

    // Speed limit sign (varying between 50, 80)
    static int signalCounter = 0;
    if (++signalCounter >= 60) { // Change signal every 30 seconds
        signalCounter = 0;
        static const QList<int> speedLimits = {50, 80};
        int signalIndex = QRandomGenerator::global()->bounded(speedLimits.size());
        mockData["sign"] = QString::number(speedLimits[signalIndex]);
    }

    // Driving mode (0 for manual, 1 for autonomous)
    static int modeCounter = 0;
    if (++modeCounter >= 80) { // Toggle every 40 seconds
        modeCounter = 0;
        static bool autoMode = false;
        autoMode = !autoMode;
        mockData["mode"] = QString::number(autoMode ? 1 : 0);
    }

    // Mock non-critical data
    static qreal batteryAngle = 0;
    int battery = qRound(50 + 50 * qSin(batteryAngle));
    batteryAngle += 0.05;
    mockData["battery"] = QString::number(battery);

    // Charging status (0 or 1)
    static int chargingCounter = 0;
    if (++chargingCounter >= 20) { // Toggle every 10 seconds
        chargingCounter = 0;
        static bool charging = false;
        charging = !charging;
        mockData["charging"] = QString::number(charging ? 1 : 0);
    }

    // Odometer (constantly increasing)
    static int odo = 0;
    odo += speed / 10; // Faster increase at higher speeds
    mockData["odo"] = QString::number(odo);

    // Process the mock data
    processData(mockData);
}

void ClusterDataSubscriber::processData(const QMap<QString, QString>& data)
{
    // Handle speed
    if (data.contains("speed")) {
        m_clusterModel->setSpeed(data["speed"].toInt());
    }

    // Handle battery level
    if (data.contains("battery")) {
        m_clusterModel->setBattery(data["battery"].toInt());
    }

    // Handle charging status
    if (data.contains("charging")) {
        m_clusterModel->setCharging(data["charging"].toInt() == 1);
    }

    // Handle lane detection
    if (data.contains("lane")) {
        int lane = data["lane"].toInt();
        if (lane == 1) {
            m_clusterModel->setLaneAlert(true);
            m_clusterModel->setLaneDeviationSide("left");
        } else if (lane == 2) {
            m_clusterModel->setLaneAlert(true);
            m_clusterModel->setLaneDeviationSide("right");
        } else {
            m_clusterModel->setLaneAlert(false);
        }
    }

    // Handle obstacle detection
    if (data.contains("obs")) {
        m_clusterModel->setObjectAlert(data["obs"].toInt() > 0);
    }

    // Handle speed limit signal
    if (data.contains("sign")) {
        int signalValue = data["sign"].toInt();

        // Show the speed limit sign with the received value
        m_clusterModel->setSpeedLimitSignal(signalValue);
        m_clusterModel->setSpeedLimitVisible(true);

        // Create a timer to hide the sign after a few seconds
        QTimer::singleShot(6000, [this]() {
            m_clusterModel->setSpeedLimitVisible(false);
        });
    }

    // Handle driving mode
    if (data.contains("mode")) {
        m_clusterModel->setDrivingMode(data["mode"].toInt() == 1 ? "AUTO" : "MAN");
    }

    // Handle odometer
    if (data.contains("odo")) {
        m_clusterModel->setOdometer(data["odo"].toInt());
    }
}
