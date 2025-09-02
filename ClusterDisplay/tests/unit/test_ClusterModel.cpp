#include <gtest/gtest.h>

#include <QCoreApplication>
#include <QSignalSpy>

#include "ClusterModel.hpp"

class ClusterModelTest : public ::testing::Test {
 protected:
  void SetUp() override {
    model = new ClusterModel();
  }

  void TearDown() override {
    delete model;
  }

  ClusterModel* model;
};

TEST_F(ClusterModelTest, InitialValues) {
  // Test initial values
  EXPECT_EQ(model->speed(), 0);
  EXPECT_EQ(model->battery(), 100);
  EXPECT_FALSE(model->charging());
  EXPECT_EQ(model->odometer(), 0);
  EXPECT_EQ(model->drivingMode(), "MAN");
  EXPECT_FALSE(model->objectAlert());
  EXPECT_FALSE(model->emergencyBrakeActive());
  EXPECT_FALSE(model->laneAlert());
  EXPECT_EQ(model->laneDeviationSide(), "left");
  EXPECT_EQ(model->speedLimitSignal(), 50);
  EXPECT_FALSE(model->speedLimitVisible());
  EXPECT_EQ(model->signType(), "");
  EXPECT_EQ(model->signValue(), "");
  EXPECT_FALSE(model->signVisible());
  EXPECT_EQ(model->lastSpeedLimit(), 0);
}

TEST_F(ClusterModelTest, SpeedSetter) {
  QSignalSpy spy(model, &ClusterModel::speedChanged);

  // Set a new value
  model->setSpeed(50);

  // Check if the value was updated
  EXPECT_EQ(model->speed(), 50);

  // Check if the signal was emitted
  EXPECT_EQ(spy.count(), 1);
  EXPECT_EQ(spy.at(0).at(0).toInt(), 50);

  // Set the same value again
  model->setSpeed(50);

  // Signal should not be emitted again
  EXPECT_EQ(spy.count(), 1);
}

TEST_F(ClusterModelTest, BatterySetter) {
  QSignalSpy spy(model, &ClusterModel::batteryChanged);

  // Set a new value
  model->setBattery(75);

  // Check if the value was updated
  EXPECT_EQ(model->battery(), 75);

  // Check if the signal was emitted
  EXPECT_EQ(spy.count(), 1);
  EXPECT_EQ(spy.at(0).at(0).toInt(), 75);

  // Set the same value again
  model->setBattery(75);

  // Signal should not be emitted again
  EXPECT_EQ(spy.count(), 1);
}

TEST_F(ClusterModelTest, ChargingSetter) {
  QSignalSpy spy(model, &ClusterModel::chargingChanged);

  // Set a new value
  model->setCharging(true);

  // Check if the value was updated
  EXPECT_TRUE(model->charging());

  // Check if the signal was emitted
  EXPECT_EQ(spy.count(), 1);
  EXPECT_EQ(spy.at(0).at(0).toBool(), true);

  // Set the same value again
  model->setCharging(true);

  // Signal should not be emitted again
  EXPECT_EQ(spy.count(), 1);
}

TEST_F(ClusterModelTest, OdometerSetter) {
  QSignalSpy spy(model, &ClusterModel::odometerChanged);

  // Set a new value
  model->setOdometer(1000);

  // Check if the value was updated
  EXPECT_EQ(model->odometer(), 1000);

  // Check if the signal was emitted
  EXPECT_EQ(spy.count(), 1);
  EXPECT_EQ(spy.at(0).at(0).toInt(), 1000);

  // Set the same value again
  model->setOdometer(1000);

  // Signal should not be emitted again
  EXPECT_EQ(spy.count(), 1);
}

TEST_F(ClusterModelTest, DrivingModeSetter) {
  QSignalSpy spy(model, &ClusterModel::drivingModeChanged);

  // Set a new value
  model->setDrivingMode("AUTO");

  // Check if the value was updated
  EXPECT_EQ(model->drivingMode(), "AUTO");

  // Check if the signal was emitted
  EXPECT_EQ(spy.count(), 1);
  EXPECT_EQ(spy.at(0).at(0).toString(), "AUTO");

  // Set the same value again
  model->setDrivingMode("AUTO");

  // Signal should not be emitted again
  EXPECT_EQ(spy.count(), 1);
}

TEST_F(ClusterModelTest, ObjectAlertSetter) {
  QSignalSpy spy(model, &ClusterModel::objectAlertChanged);

  // Set a new value
  model->setObjectAlert(true);

  // Check if the value was updated
  EXPECT_TRUE(model->objectAlert());

  // Check if the signal was emitted
  EXPECT_EQ(spy.count(), 1);
  EXPECT_EQ(spy.at(0).at(0).toBool(), true);

  // Set the same value again
  model->setObjectAlert(true);

  // Signal should not be emitted again
  EXPECT_EQ(spy.count(), 1);
}

TEST_F(ClusterModelTest, LaneAlertSetter) {
  QSignalSpy spy(model, &ClusterModel::laneAlertChanged);

  // Set a new value
  model->setLaneAlert(true);

  // Check if the value was updated
  EXPECT_TRUE(model->laneAlert());

  // Check if the signal was emitted
  EXPECT_EQ(spy.count(), 1);
  EXPECT_EQ(spy.at(0).at(0).toBool(), true);

  // Set the same value again
  model->setLaneAlert(true);

  // Signal should not be emitted again
  EXPECT_EQ(spy.count(), 1);
}

TEST_F(ClusterModelTest, LaneDeviationSideSetter) {
  QSignalSpy spy(model, &ClusterModel::laneDeviationSideChanged);

  // Set a new value
  model->setLaneDeviationSide("right");

  // Check if the value was updated
  EXPECT_EQ(model->laneDeviationSide(), "right");

  // Check if the signal was emitted
  EXPECT_EQ(spy.count(), 1);
  EXPECT_EQ(spy.at(0).at(0).toString(), "right");

  // Set the same value again
  model->setLaneDeviationSide("right");

  // Signal should not be emitted again
  EXPECT_EQ(spy.count(), 1);
}

TEST_F(ClusterModelTest, SpeedLimitSignalSetter) {
  QSignalSpy spy(model, &ClusterModel::speedLimitSignalChanged);

  // Set a new value
  model->setSpeedLimitSignal(80);

  // Check if the value was updated
  EXPECT_EQ(model->speedLimitSignal(), 80);

  // Check if the signal was emitted
  EXPECT_EQ(spy.count(), 1);
  EXPECT_EQ(spy.at(0).at(0).toInt(), 80);

  // Set the same value again
  model->setSpeedLimitSignal(80);

  // Signal should not be emitted again
  EXPECT_EQ(spy.count(), 1);
}

TEST_F(ClusterModelTest, SpeedLimitVisibleSetter) {
  QSignalSpy spy(model, &ClusterModel::speedLimitVisibleChanged);

  // Set a new value
  model->setSpeedLimitVisible(true);

  // Check if the value was updated
  EXPECT_TRUE(model->speedLimitVisible());

  // Check if the signal was emitted
  EXPECT_EQ(spy.count(), 1);
  EXPECT_EQ(spy.at(0).at(0).toBool(), true);

  // Set the same value again
  model->setSpeedLimitVisible(true);

  // Signal should not be emitted again
  EXPECT_EQ(spy.count(), 1);
}

TEST_F(ClusterModelTest, SignTypeSetter) {
  QSignalSpy spy(model, &ClusterModel::signTypeChanged);

  // Set a new value
  model->setSignType("STOP");

  // Check if the value was updated
  EXPECT_EQ(model->signType(), "STOP");

  // Check if the signal was emitted
  EXPECT_EQ(spy.count(), 1);
  EXPECT_EQ(spy.at(0).at(0).toString(), "STOP");

  // Set the same value again
  model->setSignType("STOP");

  // Signal should not be emitted again
  EXPECT_EQ(spy.count(), 1);
}

TEST_F(ClusterModelTest, SignValueSetter) {
  QSignalSpy spy(model, &ClusterModel::signValueChanged);

  // Set a new value
  model->setSignValue("CROSSWALK");

  // Check if the value was updated
  EXPECT_EQ(model->signValue(), "CROSSWALK");

  // Check if the signal was emitted
  EXPECT_EQ(spy.count(), 1);
  EXPECT_EQ(spy.at(0).at(0).toString(), "CROSSWALK");

  // Set the same value again
  model->setSignValue("CROSSWALK");

  // Signal should not be emitted again
  EXPECT_EQ(spy.count(), 1);
}

TEST_F(ClusterModelTest, SignVisibleSetter) {
  QSignalSpy spy(model, &ClusterModel::signVisibleChanged);

  // Set a new value
  model->setSignVisible(true);

  // Check if the value was updated
  EXPECT_TRUE(model->signVisible());

  // Check if the signal was emitted
  EXPECT_EQ(spy.count(), 1);
  EXPECT_TRUE(spy.at(0).at(0).toBool());

  // Set the same value again
  model->setSignVisible(true);

  // Signal should not be emitted again
  EXPECT_EQ(spy.count(), 1);
}

TEST_F(ClusterModelTest, EmergencyBrakeActiveSetter) {
  QSignalSpy spy(model, &ClusterModel::emergencyBrakeActiveChanged);

  // Test setting to true
  model->setEmergencyBrakeActive(true);

  // Check if the value was updated
  EXPECT_TRUE(model->emergencyBrakeActive());

  // Check if the signal was emitted
  EXPECT_EQ(spy.count(), 1);
  EXPECT_TRUE(spy.at(0).at(0).toBool());

  // Set the same value again
  model->setEmergencyBrakeActive(true);

  // Signal should not be emitted again
  EXPECT_EQ(spy.count(), 1);

  // Test setting to false
  model->setEmergencyBrakeActive(false);

  // Check if the value was updated
  EXPECT_FALSE(model->emergencyBrakeActive());

  // Check if the signal was emitted again
  EXPECT_EQ(spy.count(), 2);
  EXPECT_FALSE(spy.at(1).at(0).toBool());
}

TEST_F(ClusterModelTest, LastSpeedLimitSetter) {
  QSignalSpy spy(model, &ClusterModel::lastSpeedLimitChanged);

  // Set a new value
  model->setLastSpeedLimit(80);

  // Check if the value was updated
  EXPECT_EQ(model->lastSpeedLimit(), 80);

  // Check if the signal was emitted
  EXPECT_EQ(spy.count(), 1);
  EXPECT_EQ(spy.at(0).at(0).toInt(), 80);

  // Set the same value again
  model->setLastSpeedLimit(80);

  // Signal should not be emitted again
  EXPECT_EQ(spy.count(), 1);

  // Test setting different speed limits
  model->setLastSpeedLimit(120);
  EXPECT_EQ(model->lastSpeedLimit(), 120);
  EXPECT_EQ(spy.count(), 2);
  EXPECT_EQ(spy.at(1).at(0).toInt(), 120);

  // Test setting to zero (no speed limit)
  model->setLastSpeedLimit(0);
  EXPECT_EQ(model->lastSpeedLimit(), 0);
  EXPECT_EQ(spy.count(), 3);
  EXPECT_EQ(spy.at(2).at(0).toInt(), 0);
}

TEST_F(ClusterModelTest, DateTimeInitialization) {
  // Test that time and date are initialized properly
  EXPECT_FALSE(model->currentTime().isEmpty());
  EXPECT_FALSE(model->currentTime().isNull());
  EXPECT_FALSE(model->currentDate().isEmpty());
  EXPECT_FALSE(model->currentDate().isNull());

  // Check time format (hh:mm)
  EXPECT_EQ(model->currentTime().length(), 5);
  EXPECT_EQ(model->currentTime().at(2), ':');

  // Check date format (dd MMM yyyy)
  EXPECT_EQ(model->currentDate().length(), 11);
  EXPECT_EQ(model->currentDate().at(2), ' ');
  EXPECT_EQ(model->currentDate().at(6), ' ');
}

int main(int argc, char** argv) {
  QCoreApplication app(argc, argv);
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
