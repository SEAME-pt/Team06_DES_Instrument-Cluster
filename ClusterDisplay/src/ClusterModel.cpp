#include "ClusterModel.hpp"

#include <QDateTime>
#include <QRandomGenerator>
#include <QTimer>
#include <QtMath>
#include <iostream>

ClusterModel::ClusterModel(QObject *parent)
    : QObject(parent),
      m_speed(0),
      m_battery(100),
      m_charging(false),
      m_odometer(0),
      m_drivingMode("MAN"),
      m_objectAlert(false),
      m_emergencyBrakeActive(false),
      m_laneAlert(false),
      m_laneDeviationSide("left"),
      m_speedLimitSignal(50),
      m_speedLimitVisible(false),
      m_signType(""),
      m_signValue(""),
      m_signVisible(false),
      m_lastSpeedLimit(0)
{
    // Initialize time update timer
    m_timeUpdateTimer = new QTimer(this);
    m_timeUpdateTimer->setInterval(1000);  // Update every second
    connect(m_timeUpdateTimer, &QTimer::timeout, this, &ClusterModel::updateDateTime);
    m_timeUpdateTimer->start();

    // Initial update of date/time
    updateDateTime();
}

ClusterModel::~ClusterModel()
{
    m_timeUpdateTimer->stop();
}

void ClusterModel::setSpeed(int value)
{
    if (m_speed != value)
    {
        m_speed = value;
        emit speedChanged(value);
    }
}

void ClusterModel::setBattery(int value)
{
    if (m_battery != value)
    {
        m_battery = value;
        emit batteryChanged(value);
    }
}

void ClusterModel::setCharging(bool value)
{
    if (m_charging != value)
    {
        m_charging = value;
        emit chargingChanged(value);
    }
}

void ClusterModel::setOdometer(int value)
{
    if (m_odometer != value)
    {
        m_odometer = value;
        emit odometerChanged(value);
    }
}

void ClusterModel::setDrivingMode(const QString &value)
{
    if (m_drivingMode != value)
    {
        m_drivingMode = value;
        emit drivingModeChanged(value);
    }
}

void ClusterModel::setObjectAlert(bool value)
{
    if (m_objectAlert != value)
    {
        m_objectAlert = value;
        emit objectAlertChanged(value);
    }
}

void ClusterModel::setEmergencyBrakeActive(bool value)
{
    if (m_emergencyBrakeActive != value)
    {
        m_emergencyBrakeActive = value;
        emit emergencyBrakeActiveChanged(value);
    }
}

void ClusterModel::setLaneAlert(bool value)
{
    if (m_laneAlert != value)
    {
        m_laneAlert = value;
        emit laneAlertChanged(value);
    }
}

void ClusterModel::setLaneDeviationSide(const QString &value)
{
    if (m_laneDeviationSide != value)
    {
        m_laneDeviationSide = value;
        emit laneDeviationSideChanged(value);
    }
}

void ClusterModel::setSpeedLimitSignal(int value)
{
    if (m_speedLimitSignal != value)
    {
        m_speedLimitSignal = value;
        emit speedLimitSignalChanged(value);
    }
}

void ClusterModel::setSpeedLimitVisible(bool value)
{
    if (m_speedLimitVisible != value)
    {
        m_speedLimitVisible = value;
        emit speedLimitVisibleChanged(value);
    }
}

void ClusterModel::setSignType(const QString &value)
{
    if (m_signType != value)
    {
        m_signType = value;
        emit signTypeChanged(value);
    }
}

void ClusterModel::setSignValue(const QString &value)
{
    if (m_signValue != value)
    {
        m_signValue = value;
        emit signValueChanged(value);
    }
}

void ClusterModel::setSignVisible(bool value)
{
    if (m_signVisible != value)
    {
        m_signVisible = value;
        emit signVisibleChanged(value);
    }
}

void ClusterModel::setLastSpeedLimit(int value)
{
    if (m_lastSpeedLimit != value)
    {
        m_lastSpeedLimit = value;
        emit lastSpeedLimitChanged(value);
    }
}

void ClusterModel::updateDateTime()
{
    QDateTime now = QDateTime::currentDateTime();
    QString newTime = now.toString("hh:mm");
    QString newDate = now.toString("dd MMM yyyy");

    if (m_currentTime != newTime)
    {
        m_currentTime = newTime;
        emit currentTimeChanged(m_currentTime);
    }

    if (m_currentDate != newDate)
    {
        m_currentDate = newDate;
        emit currentDateChanged(m_currentDate);
    }
}
