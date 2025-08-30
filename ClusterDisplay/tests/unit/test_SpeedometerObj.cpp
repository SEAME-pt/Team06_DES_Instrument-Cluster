#include <gtest/gtest.h>

#include <QSignalSpy>

#include "SpeedometerObj.hpp"

// Mock class for SpeedometerObj to avoid actual network connections
class MockSpeedometerObj : public SpeedometerObj
{
public:
    MockSpeedometerObj(QObject* parent = nullptr) : SpeedometerObj(parent) {}

    // Expose protected method for testing
    void callHandleMsg(QString& message) { _handleMsg(message); }
};

class SpeedometerObjTest : public ::testing::Test
{
protected:
    void SetUp() override { speedometer = new MockSpeedometerObj(); }

    void TearDown() override { delete speedometer; }

    MockSpeedometerObj* speedometer;
};

TEST_F(SpeedometerObjTest, InitialValue)
{
    // Test initial value
    EXPECT_EQ(speedometer->speed(), 0);
}

TEST_F(SpeedometerObjTest, SetSpeed)
{
    QSignalSpy spy(speedometer, &SpeedometerObj::speedChanged);

    // Set a new value
    speedometer->setSpeed(120);

    // Check if the value was updated
    EXPECT_EQ(speedometer->speed(), 120);

    // Check if the signal was emitted
    EXPECT_EQ(spy.count(), 1);
    EXPECT_EQ(spy.at(0).at(0).toDouble(), 120);

    // Set the same value again
    speedometer->setSpeed(120);

    // Signal should not be emitted again
    EXPECT_EQ(spy.count(), 1);
}

TEST_F(SpeedometerObjTest, HandleMessage)
{
    QSignalSpy spy(speedometer, &SpeedometerObj::speedChanged);

    // Create a message with speed in mm/s that converts to 85 km/h
    // 85 km/h = 85 / 0.0036 ≈ 23612 mm/s
    // With 10x scaling, display should show 850
    QString message = "23612";

    // Call the handle message method
    speedometer->callHandleMsg(message);

    // Check if the value was updated (should be 850 for 85 km/h * 10)
    EXPECT_EQ(speedometer->speed(), 850);

    // Check if the signal was emitted
    EXPECT_EQ(spy.count(), 1);
    EXPECT_EQ(spy.at(0).at(0).toDouble(), 850);
}

TEST_F(SpeedometerObjTest, HandleInvalidMessage)
{
    // Set initial value
    speedometer->setSpeed(50);

    QSignalSpy spy(speedometer, &SpeedometerObj::speedChanged);

    // Create an invalid message
    QString message = "invalid";

    // Call the handle message method
    speedometer->callHandleMsg(message);

    // Check if the value was updated to 0 (invalid string converts to 0 mm/s, which is 0 km/h)
    EXPECT_EQ(speedometer->speed(), 0);

    // Check if the signal was emitted
    EXPECT_EQ(spy.count(), 1);
}

TEST_F(SpeedometerObjTest, ConversionFromMmSToKmH)
{
    QSignalSpy spy(speedometer, &SpeedometerObj::speedChanged);

    // Test conversion: 100 km/h = 100 / 0.0036 ≈ 27778 mm/s
    // Implementation multiplies by 10 for scaled display: 27778 * 0.0036 * 10 = 1000
    QString message100 = "27778";
    speedometer->callHandleMsg(message100);
    EXPECT_EQ(speedometer->speed(), 1000);

    // Test conversion: 50 km/h = 50 / 0.0036 ≈ 13889 mm/s
    // Implementation multiplies by 10 for scaled display: 13889 * 0.0036 * 10 = 500
    QString message50 = "13889";
    speedometer->callHandleMsg(message50);
    EXPECT_EQ(speedometer->speed(), 500);

    // Test conversion: 0 km/h = 0 mm/s
    QString message0 = "0";
    speedometer->callHandleMsg(message0);
    EXPECT_EQ(speedometer->speed(), 0);

    // Check signals were emitted for each change
    EXPECT_EQ(spy.count(), 3);
}

int main(int argc, char** argv)
{
    QCoreApplication app(argc, argv);
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
