// LCOV_EXCL_START - Header file should be excluded from coverage
#ifndef CLUSTERMODEL_HPP
#define CLUSTERMODEL_HPP

#include <QObject>
#include <QQmlEngine>
#include <QTimer>

/**
 * @brief Main data model for the automotive cluster display
 *
 * ClusterModel serves as the central data hub for the cluster display interface.
 * It manages all vehicle-related data including speed, battery status, driver assistance
 * alerts, and time/date information. The class exposes Qt properties that can be
 * accessed from QML for real-time UI updates.
 *
 * Key features:
 * - Vehicle telemetry (speed, battery, odometer)
 * - Driver assistance alerts (lane departure, object detection, emergency brake)
 * - Traffic sign recognition and speed limit notifications
 * - Real-time clock and date display
 * - Signal-based property change notifications
 *
 * @since 1.0.0
 */
class ClusterModel : public QObject
{
    Q_OBJECT

    // Vehicle telemetry properties
    Q_PROPERTY(int speed READ speed WRITE setSpeed NOTIFY speedChanged)
    Q_PROPERTY(int battery READ battery WRITE setBattery NOTIFY batteryChanged)
    Q_PROPERTY(bool charging READ charging WRITE setCharging NOTIFY chargingChanged)
    Q_PROPERTY(int odometer READ odometer WRITE setOdometer NOTIFY odometerChanged)
    Q_PROPERTY(QString drivingMode READ drivingMode WRITE setDrivingMode NOTIFY drivingModeChanged)

    // Time and date properties
    Q_PROPERTY(QString currentTime READ currentTime NOTIFY currentTimeChanged)
    Q_PROPERTY(QString currentDate READ currentDate NOTIFY currentDateChanged)

    // Driver assistance and safety alerts
    Q_PROPERTY(bool objectAlert READ objectAlert WRITE setObjectAlert NOTIFY objectAlertChanged)
    Q_PROPERTY(bool emergencyBrakeActive READ emergencyBrakeActive WRITE setEmergencyBrakeActive
                   NOTIFY emergencyBrakeActiveChanged)
    Q_PROPERTY(bool laneAlert READ laneAlert WRITE setLaneAlert NOTIFY laneAlertChanged)
    Q_PROPERTY(QString laneDeviationSide READ laneDeviationSide WRITE setLaneDeviationSide NOTIFY
                   laneDeviationSideChanged)

    // Speed limit and traffic sign recognition
    Q_PROPERTY(int speedLimitSignal READ speedLimitSignal WRITE setSpeedLimitSignal NOTIFY
                   speedLimitSignalChanged)
    Q_PROPERTY(bool speedLimitVisible READ speedLimitVisible WRITE setSpeedLimitVisible NOTIFY
                   speedLimitVisibleChanged)
    Q_PROPERTY(QString signType READ signType WRITE setSignType NOTIFY signTypeChanged)
    Q_PROPERTY(QString signValue READ signValue WRITE setSignValue NOTIFY signValueChanged)
    Q_PROPERTY(bool signVisible READ signVisible WRITE setSignVisible NOTIFY signVisibleChanged)
    Q_PROPERTY(
        int lastSpeedLimit READ lastSpeedLimit WRITE setLastSpeedLimit NOTIFY lastSpeedLimitChanged)

public:
    /**
     * @brief Constructs a new ClusterModel instance
     * @param parent Parent QObject for memory management
     */
    explicit ClusterModel(QObject *parent = nullptr);

    /**
     * @brief Destructor - stops internal timers and cleans up resources
     */
    virtual ~ClusterModel();

    // Getters
    /** @brief Gets current vehicle speed in km/h */
    int speed() const { return m_speed; }

    /** @brief Gets current battery level as percentage (0-100) */
    int battery() const { return m_battery; }

    /** @brief Gets charging state of the vehicle */
    bool charging() const { return m_charging; }

    /** @brief Gets total odometer reading in kilometers */
    int odometer() const { return m_odometer; }

    /** @brief Gets current driving mode (e.g., "MAN", "AUTO", "ECO") */
    QString drivingMode() const { return m_drivingMode; }

    /** @brief Gets current time formatted as "hh:mm" */
    QString currentTime() const { return m_currentTime; }

    /** @brief Gets current date formatted as "dd MMM yyyy" */
    QString currentDate() const { return m_currentDate; }

    /** @brief Gets object detection alert status */
    bool objectAlert() const { return m_objectAlert; }

    /** @brief Gets emergency brake activation status */
    bool emergencyBrakeActive() const { return m_emergencyBrakeActive; }

    /** @brief Gets lane departure alert status */
    bool laneAlert() const { return m_laneAlert; }

    /** @brief Gets lane deviation side ("left" or "right") */
    QString laneDeviationSide() const { return m_laneDeviationSide; }

    /** @brief Gets detected speed limit value */
    int speedLimitSignal() const { return m_speedLimitSignal; }

    /** @brief Gets speed limit display visibility status */
    bool speedLimitVisible() const { return m_speedLimitVisible; }

    /** @brief Gets detected traffic sign type */
    QString signType() const { return m_signType; }

    /** @brief Gets detected traffic sign value/text */
    QString signValue() const { return m_signValue; }

    /** @brief Gets traffic sign display visibility status */
    bool signVisible() const { return m_signVisible; }

    /** @brief Gets last valid speed limit for reference */
    int lastSpeedLimit() const { return m_lastSpeedLimit; }

    // Setters
    /**
     * @brief Sets vehicle speed and emits change signal if different
     * @param value Speed in km/h (typically 0-300)
     */
    void setSpeed(int value);

    /**
     * @brief Sets battery level and emits change signal if different
     * @param value Battery percentage (0-100)
     */
    void setBattery(int value);

    /**
     * @brief Sets charging state and emits change signal if different
     * @param value True if vehicle is charging, false otherwise
     */
    void setCharging(bool value);

    /**
     * @brief Sets odometer reading and emits change signal if different
     * @param value Total distance in kilometers
     */
    void setOdometer(int value);

    /**
     * @brief Sets driving mode and emits change signal if different
     * @param value Driving mode string (e.g., "MAN", "AUTO", "ECO")
     */
    void setDrivingMode(const QString &value);

    /**
     * @brief Sets object detection alert and emits change signal if different
     * @param value True if object detected ahead, false otherwise
     */
    void setObjectAlert(bool value);

    /**
     * @brief Sets emergency brake status and emits change signal if different
     * @param value True if emergency braking is active, false otherwise
     */
    void setEmergencyBrakeActive(bool value);

    /**
     * @brief Sets lane departure alert and emits change signal if different
     * @param value True if lane departure detected, false otherwise
     */
    void setLaneAlert(bool value);

    /**
     * @brief Sets lane deviation side and emits change signal if different
     * @param value Side of deviation ("left" or "right")
     */
    void setLaneDeviationSide(const QString &value);

    /**
     * @brief Sets detected speed limit and emits change signal if different
     * @param value Speed limit in km/h
     */
    void setSpeedLimitSignal(int value);

    /**
     * @brief Sets speed limit visibility and emits change signal if different
     * @param value True to show speed limit display, false to hide
     */
    void setSpeedLimitVisible(bool value);

    /**
     * @brief Sets traffic sign type and emits change signal if different
     * @param value Type of detected sign (e.g., "speed_limit", "stop", "yield")
     */
    void setSignType(const QString &value);

    /**
     * @brief Sets traffic sign value and emits change signal if different
     * @param value Value/text content of the detected sign
     */
    void setSignValue(const QString &value);

    /**
     * @brief Sets traffic sign visibility and emits change signal if different
     * @param value True to show sign display, false to hide
     */
    void setSignVisible(bool value);

    /**
     * @brief Sets last valid speed limit for reference and emits change signal if different
     * @param value Last known speed limit in km/h
     */
    void setLastSpeedLimit(int value);

signals:
    /** @brief Emitted when speed changes */
    void speedChanged(int value);

    /** @brief Emitted when battery level changes */
    void batteryChanged(int value);

    /** @brief Emitted when charging state changes */
    void chargingChanged(bool value);

    /** @brief Emitted when odometer reading changes */
    void odometerChanged(int value);

    /** @brief Emitted when driving mode changes */
    void drivingModeChanged(const QString &value);

    /** @brief Emitted when current time changes */
    void currentTimeChanged(const QString &value);

    /** @brief Emitted when current date changes */
    void currentDateChanged(const QString &value);

    /** @brief Emitted when object alert status changes */
    void objectAlertChanged(bool value);

    /** @brief Emitted when emergency brake status changes */
    void emergencyBrakeActiveChanged(bool value);

    /** @brief Emitted when lane alert status changes */
    void laneAlertChanged(bool value);

    /** @brief Emitted when lane deviation side changes */
    void laneDeviationSideChanged(const QString &value);

    /** @brief Emitted when speed limit signal changes */
    void speedLimitSignalChanged(int value);

    /** @brief Emitted when speed limit visibility changes */
    void speedLimitVisibleChanged(bool value);

    /** @brief Emitted when sign type changes */
    void signTypeChanged(const QString &value);

    /** @brief Emitted when sign value changes */
    void signValueChanged(const QString &value);

    /** @brief Emitted when sign visibility changes */
    void signVisibleChanged(bool value);

    /** @brief Emitted when last speed limit changes */
    void lastSpeedLimitChanged(int value);

private slots:
    /**
     * @brief Updates current time and date from system clock
     * Called automatically every second by internal timer
     */
    void updateDateTime();

private:
    // Vehicle telemetry data
    int m_speed;            ///< Current vehicle speed in km/h
    int m_battery;          ///< Battery level percentage (0-100)
    bool m_charging;        ///< Charging state of the vehicle
    int m_odometer;         ///< Total distance traveled in km
    QString m_drivingMode;  ///< Current driving mode

    // Time and date
    QString m_currentTime;  ///< Current time formatted as "hh:mm"
    QString m_currentDate;  ///< Current date formatted as "dd MMM yyyy"

    // Driver assistance alerts
    bool m_objectAlert;           ///< Object detection alert status
    bool m_emergencyBrakeActive;  ///< Emergency brake activation status
    bool m_laneAlert;             ///< Lane departure alert status
    QString m_laneDeviationSide;  ///< Side of lane deviation

    // Traffic sign recognition
    int m_speedLimitSignal;    ///< Detected speed limit value
    bool m_speedLimitVisible;  ///< Speed limit display visibility
    QString m_signType;        ///< Type of detected traffic sign
    QString m_signValue;       ///< Value/content of detected sign
    bool m_signVisible;        ///< Traffic sign display visibility
    int m_lastSpeedLimit;      ///< Last valid speed limit for reference

    QTimer *m_timeUpdateTimer;  ///< Timer for updating time/date display
};

#endif  // CLUSTERMODEL_HPP
// LCOV_EXCL_STOP
