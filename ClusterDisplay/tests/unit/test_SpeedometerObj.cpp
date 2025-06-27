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

    // Create a message
    QString message = "85";

    // Call the handle message method
    speedometer->callHandleMsg(message);

    // Check if the value was updated
    EXPECT_EQ(speedometer->speed(), 85);

    // Check if the signal was emitted
    EXPECT_EQ(spy.count(), 1);
    EXPECT_EQ(spy.at(0).at(0).toDouble(), 85);
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

    // Check if the value was updated to 0 (default for toInt() on invalid string)
    EXPECT_EQ(speedometer->speed(), 0);

    // Check if the signal was emitted
    EXPECT_EQ(spy.count(), 1);
}

int main(int argc, char** argv)
{
    QCoreApplication app(argc, argv);
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
