#ifndef CLUSTERMODEL_HPP
#define CLUSTERMODEL_HPP

#include <QObject>
#include <QQmlEngine>
#include <QTimer>

class ClusterModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int speed READ speed WRITE setSpeed NOTIFY speedChanged)
    Q_PROPERTY(int battery READ battery WRITE setBattery NOTIFY batteryChanged)
    Q_PROPERTY(bool charging READ charging WRITE setCharging NOTIFY chargingChanged)
    Q_PROPERTY(int odometer READ odometer WRITE setOdometer NOTIFY odometerChanged)
    Q_PROPERTY(QString drivingMode READ drivingMode WRITE setDrivingMode NOTIFY drivingModeChanged)
    Q_PROPERTY(QString currentTime READ currentTime NOTIFY currentTimeChanged)
    Q_PROPERTY(QString currentDate READ currentDate NOTIFY currentDateChanged)
    Q_PROPERTY(bool objectAlert READ objectAlert WRITE setObjectAlert NOTIFY objectAlertChanged)
    Q_PROPERTY(bool laneAlert READ laneAlert WRITE setLaneAlert NOTIFY laneAlertChanged)
    Q_PROPERTY(QString laneDeviationSide READ laneDeviationSide WRITE setLaneDeviationSide NOTIFY
                   laneDeviationSideChanged)
    Q_PROPERTY(int speedLimitSignal READ speedLimitSignal WRITE setSpeedLimitSignal NOTIFY speedLimitSignalChanged)
    Q_PROPERTY(bool speedLimitVisible READ speedLimitVisible WRITE setSpeedLimitVisible NOTIFY speedLimitVisibleChanged)

public:
    explicit ClusterModel(QObject *parent = nullptr);
    virtual ~ClusterModel();

    // Getters
    int speed() const { return m_speed; }
    int battery() const { return m_battery; }
    bool charging() const { return m_charging; }
    int odometer() const { return m_odometer; }
    QString drivingMode() const { return m_drivingMode; }
    QString currentTime() const { return m_currentTime; }
    QString currentDate() const { return m_currentDate; }
    bool objectAlert() const { return m_objectAlert; }
    bool laneAlert() const { return m_laneAlert; }
    QString laneDeviationSide() const { return m_laneDeviationSide; }
    int speedLimitSignal() const { return m_speedLimitSignal; }
    bool speedLimitVisible() const { return m_speedLimitVisible; }

    // Setters
    void setSpeed(int value);
    void setBattery(int value);
    void setCharging(bool value);
    void setOdometer(int value);
    void setDrivingMode(const QString &value);
    void setObjectAlert(bool value);
    void setLaneAlert(bool value);
    void setLaneDeviationSide(const QString &value);
    void setSpeedLimitSignal(int value);
    void setSpeedLimitVisible(bool value);

signals:
    void speedChanged(int value);
    void batteryChanged(int value);
    void chargingChanged(bool value);
    void odometerChanged(int value);
    void drivingModeChanged(const QString &value);
    void currentTimeChanged(const QString &value);
    void currentDateChanged(const QString &value);
    void objectAlertChanged(bool value);
    void laneAlertChanged(bool value);
    void laneDeviationSideChanged(const QString &value);
    void speedLimitSignalChanged(int value);
    void speedLimitVisibleChanged(bool value);

private slots:
    void updateDateTime();

private:
    int m_speed;
    int m_battery;
    bool m_charging;
    int m_odometer;
    QString m_drivingMode;
    QString m_currentTime;
    QString m_currentDate;
    bool m_objectAlert;
    bool m_laneAlert;
    QString m_laneDeviationSide;
    int m_speedLimitSignal;
    bool m_speedLimitVisible;

    QTimer *m_timeUpdateTimer;
};

#endif  // CLUSTERMODEL_HPP
