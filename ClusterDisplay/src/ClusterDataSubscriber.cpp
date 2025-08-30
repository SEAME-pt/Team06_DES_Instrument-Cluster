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
    , m_currentSignType("")
    , m_currentSignValue("")
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

    // Create sign hide timer but don't start it yet
    m_signHideTimer = new QTimer(this);
    m_signHideTimer->setSingleShot(true);
    connect(m_signHideTimer, &QTimer::timeout, [this]() {
        m_clusterModel->setSpeedLimitVisible(false);
        m_clusterModel->setSignVisible(false);
        m_currentSignType = "";
        m_currentSignValue = "";
    });
}

ClusterDataSubscriber::~ClusterDataSubscriber()
{
    // Stop mock timer if running
    if (m_mockTimer->isActive()) {
        m_mockTimer->stop();
    }

    // Stop sign hide timer if running
    if (m_signHideTimer && m_signHideTimer->isActive()) {
        m_signHideTimer->stop();
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
    int speedKmH = qRound(100 + 100 * qSin(angle)); // Generate speed in km/h for display
    // Convert to mm/s for transmission (km/h / 0.0036 = mm/s)
    int speedMmS = qRound(speedKmH / 0.0036);
    angle += 0.1;
    mockData["speed"] = QString::number(speedMmS);

    // Lane detection (1 for left, 2 for right, alternating)
    static int laneCounter = 0;
    if (++laneCounter >= 20) { // Change lane every 10 seconds (2x faster)
        laneCounter = 0;
        mockData["lane"] = QString::number(QRandomGenerator::global()->bounded(1, 3));
        // Add obstacle detection occasionally
        if (QRandomGenerator::global()->bounded(3) == 0) {
            // Generate either obs:1 or obs:2 for testing
            int obsValue = QRandomGenerator::global()->bounded(1, 3); // 1 or 2
            mockData["obs"] = QString::number(obsValue);
        }
    }

    // Street signs (varying between speed limits, stop, crosswalk, and yield)
    static int signalCounter = 0;
    if (++signalCounter >= 5) { // Change signal every 10 seconds (3x faster)
        signalCounter = 0;
        static const QStringList signs = {"50", "80", "stop", "crosswalk", "yield"};
        int signalIndex = QRandomGenerator::global()->bounded(signs.size());
        mockData["sign"] = signs[signalIndex];
    }

    // Driving mode (0 for manual, 1 for autonomous)
    static int modeCounter = 0;
    if (++modeCounter >= 40) { // Toggle every 20 seconds (2x faster)
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
    odo += speedKmH / 10; // Faster increase at higher speeds
    mockData["odo"] = QString::number(odo);

    // Process the mock data
    processData(mockData);
}

void ClusterDataSubscriber::processData(const QMap<QString, QString>& data)
{
    // Handle speed - convert from mm/s to km/h
    if (data.contains("speed")) {
        int speedMmPerSec = data["speed"].toInt();
        // Convert mm/s to km/h: mm/s * 0.0036 = km/h
        // Then multiply by 10 for scaled display
        int speedKmPerHour = static_cast<int>(speedMmPerSec * 0.0036 * 10);
        m_clusterModel->setSpeed(speedKmPerHour);
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
        int obsValue = data["obs"].toInt();
        bool hasObstacle = obsValue > 0;
        m_clusterModel->setObjectAlert(hasObstacle);

        // Emergency brake alert is triggered specifically by obs:2
        m_clusterModel->setEmergencyBrakeActive(obsValue == 2);
    }

    // Handle speed limit signal
    if (data.contains("sign")) {
        QString signValue = data["sign"];
        QString signType;
        QString displayValue;

        // Determine sign type and display value
        bool isNumeric;
        int speedLimit = signValue.toInt(&isNumeric);

        if (isNumeric) {
            // Traditional speed limit sign
            signType = "SPEED_LIMIT";
            displayValue = QString::number(speedLimit);
        } else if (signValue == "stop") {
            // Stop sign
            signType = "STOP";
            displayValue = "STOP";
        } else if (signValue == "crosswalk") {
            // Crosswalk sign
            signType = "CROSSWALK";
            displayValue = "CROSSWALK";
        } else if (signValue == "yield") {
            // Yield sign
            signType = "YIELD";
            displayValue = "YIELD";
        } else {
            // Unknown sign type, skip processing
            return;
        }

        // Check if this is the same sign we're currently displaying
        bool isSameSign = (m_currentSignType == signType && m_currentSignValue == displayValue);

        if (isSameSign) {
            // Same sign detected - just prolong the display by restarting the timer
            m_signHideTimer->start(6000);
        } else {
            // Different sign or no current sign - update display and start new timer
            m_currentSignType = signType;
            m_currentSignValue = displayValue;

            if (isNumeric) {
                // Traditional speed limit sign
                m_clusterModel->setSpeedLimitSignal(speedLimit);
                m_clusterModel->setSpeedLimitVisible(true);

                // Update the persistent speed limit display
                m_clusterModel->setLastSpeedLimit(speedLimit);

                // Also update the new generic sign system for consistency
                m_clusterModel->setSignType(signType);
                m_clusterModel->setSignValue(displayValue);
                m_clusterModel->setSignVisible(true);
            } else {
                // Non-numeric sign (stop, crosswalk, etc.)
                m_clusterModel->setSignType(signType);
                m_clusterModel->setSignValue(displayValue);
                m_clusterModel->setSignVisible(true);

                // Hide old speed limit display
                m_clusterModel->setSpeedLimitVisible(false);
            }

            // Start the hide timer for the new sign
            m_signHideTimer->start(6000);
        }
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
