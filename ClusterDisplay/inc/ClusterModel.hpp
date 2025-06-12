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

    // Setters
    void setSpeed(int value);
    void setBattery(int value);
    void setCharging(bool value);
    void setOdometer(int value);
    void setDrivingMode(const QString &value);

signals:
    void speedChanged(int value);
    void batteryChanged(int value);
    void chargingChanged(bool value);
    void odometerChanged(int value);
    void drivingModeChanged(const QString &value);
    void currentTimeChanged(const QString &value);
    void currentDateChanged(const QString &value);

private slots:
    void updateDateTime();
    void simulateDataUpdate();

private:
    int m_speed;
    int m_battery;
    bool m_charging;
    int m_odometer;
    QString m_drivingMode;
    QString m_currentTime;
    QString m_currentDate;

    QTimer* m_timeUpdateTimer;
    QTimer* m_dataSimulationTimer;
};

#endif // CLUSTERMODEL_HPP
