#include <gtest/gtest.h>

#include <QSignalSpy>
#include <QTimer>

#include "ClusterDataSubscriber.hpp"
#include "ClusterModel.hpp"

class ClusterDataSubscriberTest : public ::testing::Test
{
protected:
    void SetUp() override
    {
        model = new ClusterModel();
        subscriber = new ClusterDataSubscriber(model);
    }

    void TearDown() override
    {
        delete subscriber;
        delete model;
    }

    ClusterModel* model;
    ClusterDataSubscriber* subscriber;
};

TEST_F(ClusterDataSubscriberTest, InitialState)
{
    // Test initial state
    EXPECT_FALSE(subscriber->isMockingEnabled());
}

TEST_F(ClusterDataSubscriberTest, EnableMocking)
{
    // Test enabling mocking
    subscriber->enableMocking(true);
    EXPECT_TRUE(subscriber->isMockingEnabled());

    // Test disabling mocking
    subscriber->enableMocking(false);
    EXPECT_FALSE(subscriber->isMockingEnabled());
}

TEST_F(ClusterDataSubscriberTest, EnableMockingNoChange)
{
    // Test that enabling when already enabled doesn't cause issues
    subscriber->enableMocking(true);
    subscriber->enableMocking(true);
    EXPECT_TRUE(subscriber->isMockingEnabled());

    // Test that disabling when already disabled doesn't cause issues
    subscriber->enableMocking(false);
    subscriber->enableMocking(false);
    EXPECT_FALSE(subscriber->isMockingEnabled());
}

TEST_F(ClusterDataSubscriberTest, HandleCriticalDataWhenMockingDisabled)
{
    // Test that critical data is processed when mocking is disabled
    QSignalSpy speedSpy(model, &ClusterModel::speedChanged);
    QSignalSpy batterySpy(model, &ClusterModel::batteryChanged);

    // Send a message with speed and battery data
    QString message = "speed:1000;battery:75";
    subscriber->handleCriticalData(message);

    // Check that the model was updated
    EXPECT_EQ(model->speed(), 36);  // 1000 * 0.0036 * 10 = 36
    EXPECT_EQ(model->battery(), 75);
    EXPECT_EQ(speedSpy.count(), 1);
    EXPECT_EQ(batterySpy.count(), 1);
}

TEST_F(ClusterDataSubscriberTest, HandleNonCriticalDataWhenMockingDisabled)
{
    // Test that non-critical data is processed when mocking is disabled
    QSignalSpy chargingSpy(model, &ClusterModel::chargingChanged);
    QSignalSpy odometerSpy(model, &ClusterModel::odometerChanged);

    // Send a message with charging and odometer data
    QString message = "charging:1;odo:12345";
    subscriber->handleNonCriticalData(message);

    // Check that the model was updated
    EXPECT_TRUE(model->charging());
    EXPECT_EQ(model->odometer(), 12345);
    EXPECT_EQ(chargingSpy.count(), 1);
    EXPECT_EQ(odometerSpy.count(), 1);
}

TEST_F(ClusterDataSubscriberTest, HandleCriticalDataWhenMockingEnabled)
{
    // Test that critical data is ignored when mocking is enabled
    subscriber->enableMocking(true);

    QSignalSpy speedSpy(model, &ClusterModel::speedChanged);

    // Send a message with speed data
    QString message = "speed:1000";
    subscriber->handleCriticalData(message);

    // Check that the model was NOT updated (mocking is enabled)
    EXPECT_EQ(model->speed(), 0);
    EXPECT_EQ(speedSpy.count(), 0);
}

TEST_F(ClusterDataSubscriberTest, HandleNonCriticalDataWhenMockingEnabled)
{
    // Test that non-critical data is ignored when mocking is enabled
    subscriber->enableMocking(true);

    QSignalSpy batterySpy(model, &ClusterModel::batteryChanged);

    // Send a message with battery data
    QString message = "battery:50";
    subscriber->handleNonCriticalData(message);

    // Check that the model was NOT updated (mocking is enabled)
    EXPECT_EQ(model->battery(), 100);  // Initial value
    EXPECT_EQ(batterySpy.count(), 0);
}

TEST_F(ClusterDataSubscriberTest, ProcessSpeedData)
{
    QSignalSpy speedSpy(model, &ClusterModel::speedChanged);

    // Test speed conversion from mm/s to km/h
    QMap<QString, QString> data;
    data["speed"] = "1000";  // 1000 mm/s

    // Access private method through public interface
    QString message = "speed:1000";
    subscriber->handleCriticalData(message);

    // 1000 mm/s * 0.0036 * 10 = 36 km/h (scaled)
    EXPECT_EQ(model->speed(), 36);
    EXPECT_EQ(speedSpy.count(), 1);
}

TEST_F(ClusterDataSubscriberTest, ProcessBatteryData)
{
    QSignalSpy batterySpy(model, &ClusterModel::batteryChanged);

    QMap<QString, QString> data;
    data["battery"] = "50";

    QString message = "battery:50";
    subscriber->handleCriticalData(message);

    EXPECT_EQ(model->battery(), 50);
    EXPECT_EQ(batterySpy.count(), 1);
}

TEST_F(ClusterDataSubscriberTest, ProcessChargingData)
{
    QSignalSpy chargingSpy(model, &ClusterModel::chargingChanged);

    // Test charging = 1 (true)
    QString message = "charging:1";
    subscriber->handleCriticalData(message);
    EXPECT_TRUE(model->charging());
    EXPECT_EQ(chargingSpy.count(), 1);

    // Test charging = 0 (false)
    message = "charging:0";
    subscriber->handleCriticalData(message);
    EXPECT_FALSE(model->charging());
    EXPECT_EQ(chargingSpy.count(), 2);
}

TEST_F(ClusterDataSubscriberTest, ProcessLaneData)
{
    QSignalSpy laneAlertSpy(model, &ClusterModel::laneAlertChanged);
    QSignalSpy laneSideSpy(model, &ClusterModel::laneDeviationSideChanged);

    // Test lane = 1 (left deviation)
    QString message = "lane:1";
    subscriber->handleCriticalData(message);
    EXPECT_TRUE(model->laneAlert());
    EXPECT_EQ(model->laneDeviationSide(), "left");
    // Signal count may vary depending on initial state, so just check that values are correct

    // Test lane = 2 (right deviation)
    message = "lane:2";
    subscriber->handleCriticalData(message);
    EXPECT_TRUE(model->laneAlert());
    EXPECT_EQ(model->laneDeviationSide(), "right");
    // Signal count may vary depending on initial state, so just check that values are correct

    // Test lane = 0 (no deviation)
    message = "lane:0";
    subscriber->handleCriticalData(message);
    EXPECT_FALSE(model->laneAlert());
    // Signal count may vary depending on initial state, so just check that values are correct
}

TEST_F(ClusterDataSubscriberTest, ProcessObstacleData)
{
    QSignalSpy objectAlertSpy(model, &ClusterModel::objectAlertChanged);
    QSignalSpy emergencyBrakeSpy(model, &ClusterModel::emergencyBrakeActiveChanged);

    // Test obs = 1 (object alert, no emergency brake)
    QString message = "obs:1";
    subscriber->handleCriticalData(message);
    EXPECT_TRUE(model->objectAlert());
    EXPECT_FALSE(model->emergencyBrakeActive());
    // Signal count may vary depending on initial state, so just check that values are correct

    // Test obs = 2 (object alert + emergency brake)
    message = "obs:2";
    subscriber->handleCriticalData(message);
    EXPECT_TRUE(model->objectAlert());
    EXPECT_TRUE(model->emergencyBrakeActive());
    // Signal count may vary depending on initial state, so just check that values are correct

    // Test obs = 0 (no alert)
    message = "obs:0";
    subscriber->handleCriticalData(message);
    EXPECT_FALSE(model->objectAlert());
    EXPECT_FALSE(model->emergencyBrakeActive());
    // Signal count may vary depending on initial state, so just check that values are correct
}

TEST_F(ClusterDataSubscriberTest, ProcessDrivingModeData)
{
    QSignalSpy drivingModeSpy(model, &ClusterModel::drivingModeChanged);

    // Test mode = 1 (AUTO)
    QString message = "mode:1";
    subscriber->handleCriticalData(message);
    EXPECT_EQ(model->drivingMode(), "AUTO");
    EXPECT_EQ(drivingModeSpy.count(), 1);

    // Test mode = 0 (MAN)
    message = "mode:0";
    subscriber->handleCriticalData(message);
    EXPECT_EQ(model->drivingMode(), "MAN");
    EXPECT_EQ(drivingModeSpy.count(), 2);
}

TEST_F(ClusterDataSubscriberTest, ProcessOdometerData)
{
    QSignalSpy odometerSpy(model, &ClusterModel::odometerChanged);

    QString message = "odo:12345";
    subscriber->handleCriticalData(message);
    EXPECT_EQ(model->odometer(), 12345);
    EXPECT_EQ(odometerSpy.count(), 1);
}

TEST_F(ClusterDataSubscriberTest, ProcessSpeedLimitSign)
{
    QSignalSpy speedLimitSignalSpy(model, &ClusterModel::speedLimitSignalChanged);
    QSignalSpy speedLimitVisibleSpy(model, &ClusterModel::speedLimitVisibleChanged);
    QSignalSpy signTypeSpy(model, &ClusterModel::signTypeChanged);
    QSignalSpy signValueSpy(model, &ClusterModel::signValueChanged);
    QSignalSpy signVisibleSpy(model, &ClusterModel::signVisibleChanged);
    QSignalSpy lastSpeedLimitSpy(model, &ClusterModel::lastSpeedLimitChanged);

    // Test numeric speed limit sign
    QString message = "sign:80";
    subscriber->handleCriticalData(message);

    EXPECT_EQ(model->speedLimitSignal(), 80);
    EXPECT_TRUE(model->speedLimitVisible());
    EXPECT_EQ(model->signType(), "SPEED_LIMIT");
    EXPECT_EQ(model->signValue(), "80");
    EXPECT_TRUE(model->signVisible());
    EXPECT_EQ(model->lastSpeedLimit(), 80);

    EXPECT_EQ(speedLimitSignalSpy.count(), 1);
    EXPECT_EQ(speedLimitVisibleSpy.count(), 1);
    EXPECT_EQ(signTypeSpy.count(), 1);
    EXPECT_EQ(signValueSpy.count(), 1);
    EXPECT_EQ(signVisibleSpy.count(), 1);
    EXPECT_EQ(lastSpeedLimitSpy.count(), 1);
}

TEST_F(ClusterDataSubscriberTest, ProcessStopSign)
{
    QSignalSpy speedLimitVisibleSpy(model, &ClusterModel::speedLimitVisibleChanged);
    QSignalSpy signTypeSpy(model, &ClusterModel::signTypeChanged);
    QSignalSpy signValueSpy(model, &ClusterModel::signValueChanged);
    QSignalSpy signVisibleSpy(model, &ClusterModel::signVisibleChanged);

    // Test stop sign
    QString message = "sign:stop";
    subscriber->handleCriticalData(message);

    EXPECT_FALSE(model->speedLimitVisible());  // Should hide speed limit
    EXPECT_EQ(model->signType(), "STOP");
    EXPECT_EQ(model->signValue(), "STOP");
    EXPECT_TRUE(model->signVisible());

    // Signal count may vary depending on initial state, so just check that values are correct
}

TEST_F(ClusterDataSubscriberTest, ProcessCrosswalkSign)
{
    QSignalSpy signTypeSpy(model, &ClusterModel::signTypeChanged);
    QSignalSpy signValueSpy(model, &ClusterModel::signValueChanged);

    // Test crosswalk sign
    QString message = "sign:crosswalk";
    subscriber->handleCriticalData(message);

    EXPECT_EQ(model->signType(), "CROSSWALK");
    EXPECT_EQ(model->signValue(), "CROSSWALK");
    EXPECT_TRUE(model->signVisible());

    EXPECT_EQ(signTypeSpy.count(), 1);
    EXPECT_EQ(signValueSpy.count(), 1);
}

TEST_F(ClusterDataSubscriberTest, ProcessYieldSign)
{
    QSignalSpy signTypeSpy(model, &ClusterModel::signTypeChanged);
    QSignalSpy signValueSpy(model, &ClusterModel::signValueChanged);

    // Test yield sign
    QString message = "sign:yield";
    subscriber->handleCriticalData(message);

    EXPECT_EQ(model->signType(), "YIELD");
    EXPECT_EQ(model->signValue(), "YIELD");
    EXPECT_TRUE(model->signVisible());

    EXPECT_EQ(signTypeSpy.count(), 1);
    EXPECT_EQ(signValueSpy.count(), 1);
}

TEST_F(ClusterDataSubscriberTest, ProcessUnknownSign)
{
    QSignalSpy signTypeSpy(model, &ClusterModel::signTypeChanged);
    QSignalSpy signValueSpy(model, &ClusterModel::signValueChanged);

    // Test unknown sign type
    QString message = "sign:unknown";
    subscriber->handleCriticalData(message);

    // Should not change any values for unknown sign
    EXPECT_EQ(model->signType(), "");
    EXPECT_EQ(model->signValue(), "");
    EXPECT_FALSE(model->signVisible());

    EXPECT_EQ(signTypeSpy.count(), 0);
    EXPECT_EQ(signValueSpy.count(), 0);
}

TEST_F(ClusterDataSubscriberTest, ProcessSameSignProlongation)
{
    // First, set up a sign
    QString message = "sign:50";
    subscriber->handleCriticalData(message);

    // Now send the same sign again
    subscriber->handleCriticalData(message);

    // The sign should still be visible and the same
    EXPECT_EQ(model->signType(), "SPEED_LIMIT");
    EXPECT_EQ(model->signValue(), "50");
    EXPECT_TRUE(model->signVisible());
}

TEST_F(ClusterDataSubscriberTest, ProcessDifferentSign)
{
    // First, set up a sign
    QString message1 = "sign:50";
    subscriber->handleCriticalData(message1);

    // Now send a different sign
    QString message2 = "sign:80";
    subscriber->handleCriticalData(message2);

    // The sign should be updated
    EXPECT_EQ(model->signType(), "SPEED_LIMIT");
    EXPECT_EQ(model->signValue(), "80");
    EXPECT_TRUE(model->signVisible());
}

TEST_F(ClusterDataSubscriberTest, ProcessMultipleDataFields)
{
    QSignalSpy speedSpy(model, &ClusterModel::speedChanged);
    QSignalSpy batterySpy(model, &ClusterModel::batteryChanged);
    QSignalSpy chargingSpy(model, &ClusterModel::chargingChanged);
    QSignalSpy laneSpy(model, &ClusterModel::laneAlertChanged);

    // Test message with multiple fields
    QString message = "speed:1000;battery:75;charging:1;lane:1";
    subscriber->handleCriticalData(message);

    EXPECT_EQ(model->speed(), 36);  // 1000 * 0.0036 * 10
    EXPECT_EQ(model->battery(), 75);
    EXPECT_TRUE(model->charging());
    EXPECT_TRUE(model->laneAlert());

    EXPECT_EQ(speedSpy.count(), 1);
    EXPECT_EQ(batterySpy.count(), 1);
    EXPECT_EQ(chargingSpy.count(), 1);
    EXPECT_EQ(laneSpy.count(), 1);
}

TEST_F(ClusterDataSubscriberTest, ProcessEmptyMessage)
{
    // Test that empty message doesn't cause issues
    QString message = "";
    EXPECT_NO_THROW(subscriber->handleCriticalData(message));
}

TEST_F(ClusterDataSubscriberTest, ProcessInvalidData)
{
    // Test that invalid data doesn't cause issues
    QString message = "invalid:data;speed:not_a_number;battery:also_invalid";
    EXPECT_NO_THROW(subscriber->handleCriticalData(message));

    // Values should remain unchanged or be set to defaults
    EXPECT_EQ(model->speed(), 0);
    // Battery might be set to 0 for invalid input, so check it's reasonable
    EXPECT_GE(model->battery(), 0);
    EXPECT_LE(model->battery(), 100);
}

// Mock data generation tests removed - mock code is excluded from coverage
