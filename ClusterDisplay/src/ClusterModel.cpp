#include "ClusterModel.hpp"
#include <QDateTime>
#include <QTimer>
#include <iostream>
#include <QtMath>

ClusterModel::ClusterModel(QObject *parent)
    : QObject(parent),
      m_speed(0),
      m_battery(100),
      m_charging(false),
      m_odometer(0),
      m_drivingMode("MAN")
{
    // Initialize time update timer
    m_timeUpdateTimer = new QTimer(this);
    m_timeUpdateTimer->setInterval(1000);  // Update every second
    connect(m_timeUpdateTimer, &QTimer::timeout, this, &ClusterModel::updateDateTime);
    m_timeUpdateTimer->start();

    // Setup data simulation timer
    m_dataSimulationTimer = new QTimer(this);
    m_dataSimulationTimer->setInterval(500);  // Update every 500ms
    connect(m_dataSimulationTimer, &QTimer::timeout, this, &ClusterModel::simulateDataUpdate);
    m_dataSimulationTimer->start();

    // Initial update of date/time
    updateDateTime();
}

ClusterModel::~ClusterModel()
{
    m_timeUpdateTimer->stop();
    m_dataSimulationTimer->stop();
}

void ClusterModel::setSpeed(int value)
{
    if (m_speed != value) {
        m_speed = value;
        emit speedChanged(value);
    }
}

void ClusterModel::setBattery(int value)
{
    if (m_battery != value) {
        m_battery = value;
        emit batteryChanged(value);
    }
}

void ClusterModel::setCharging(bool value)
{
    if (m_charging != value) {
        m_charging = value;
        emit chargingChanged(value);
    }
}

void ClusterModel::setOdometer(int value)
{
    if (m_odometer != value) {
        m_odometer = value;
        emit odometerChanged(value);
    }
}

void ClusterModel::setDrivingMode(const QString &value)
{
    if (m_drivingMode != value) {
        m_drivingMode = value;
        emit drivingModeChanged(value);
    }
}

void ClusterModel::updateDateTime()
{
    QDateTime now = QDateTime::currentDateTime();
    QString newTime = now.toString("hh:mm");
    QString newDate = now.toString("dd MMM yyyy");

    if (m_currentTime != newTime) {
        m_currentTime = newTime;
        emit currentTimeChanged(m_currentTime);
    }

    if (m_currentDate != newDate) {
        m_currentDate = newDate;
        emit currentDateChanged(m_currentDate);
    }
}

void ClusterModel::simulateDataUpdate()
{
    // Simulate speed changes (0-200)
    static qreal angle = 0;
    int newSpeed = qRound(100 + 100 * qSin(angle));
    angle += 0.1;
    setSpeed(newSpeed);

    // Simulate battery changes (0-100)
    static qreal batteryAngle = 0;
    int newBattery = qRound(50 + 50 * qSin(batteryAngle));
    batteryAngle += 0.05;
    setBattery(newBattery);

    // Simulate charging status changes
    static int chargingCounter = 0;
    if (++chargingCounter >= 20) { // Toggle every 10 seconds
        setCharging(!m_charging);
        chargingCounter = 0;
    }

    // Increment odometer
    setOdometer(m_odometer + 1);

    // Toggle driving mode occasionally
    static int modeCounter = 0;
    if (++modeCounter >= 40) { // Toggle every 20 seconds
        setDrivingMode(m_drivingMode == "MAN" ? "AUTO" : "MAN");
        modeCounter = 0;
    }
}
