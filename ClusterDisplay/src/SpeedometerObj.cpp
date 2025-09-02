#include "SpeedometerObj.hpp"

SpeedometerObj::SpeedometerObj(QObject* parent)
    : ZmqSubscriber(SPEEDOMETER_ADDRESS, parent), m_speed{0} {
  setSpeed(0); // Needed so the first value gets displayed on screen
}
SpeedometerObj::~SpeedometerObj() {}

double SpeedometerObj::speed(void) const {
  return (m_speed);
}
void SpeedometerObj::setSpeed(int newSpeed) {
  if (newSpeed == m_speed)
    return;
  m_speed = newSpeed;
  emit speedChanged(newSpeed); // This is what makes the value be updated on screen.
}

void SpeedometerObj::_handleMsg(QString& message) {
  int speedMmPerSec = message.toInt();
  // Convert mm/s to km/h: mm/s * 0.0036 = km/h
  // Then multiply by 10 for scaled display
  int speedKmPerHour = static_cast<int>(std::round(speedMmPerSec * 0.0036 * 10));
  setSpeed(speedKmPerHour);
}
