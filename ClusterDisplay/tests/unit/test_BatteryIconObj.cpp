#include <gtest/gtest.h>
#include <QSignalSpy>
#include "BatteryIconObj.hpp"

// Mock class for BatteryIconObj to avoid actual network connections
class MockBatteryIconObj : public BatteryIconObj {
public:
    MockBatteryIconObj(QObject* parent = nullptr)
        : BatteryIconObj(parent) {}

    // Expose protected method for testing
    void callHandleMsg(QString& message) {
        _handleMsg(message);
    }
};

class BatteryIconObjTest : public ::testing::Test {
protected:
    void SetUp() override {
        batteryIcon = new MockBatteryIconObj();
    }

    void TearDown() override {
        delete batteryIcon;
    }

    MockBatteryIconObj* batteryIcon;
};

TEST_F(BatteryIconObjTest, InitialValue) {
    // Test initial value
    EXPECT_EQ(batteryIcon->percentage(), 0);
}

TEST_F(BatteryIconObjTest, SetPercentage) {
    QSignalSpy spy(batteryIcon, &BatteryIconObj::percentageChanged);

    // Set a new value
    batteryIcon->setPercentage(75);

    // Check if the value was updated
    EXPECT_EQ(batteryIcon->percentage(), 75);

    // Check if the signal was emitted
    EXPECT_EQ(spy.count(), 1);
    EXPECT_EQ(spy.at(0).at(0).toInt(), 75);

    // Set the same value again
    batteryIcon->setPercentage(75);

    // Signal should not be emitted again
    EXPECT_EQ(spy.count(), 1);
}

TEST_F(BatteryIconObjTest, HandleMessage) {
    QSignalSpy spy(batteryIcon, &BatteryIconObj::percentageChanged);

    // Create a message
    QString message = "85";

    // Call the handle message method
    batteryIcon->callHandleMsg(message);

    // Check if the value was updated
    EXPECT_EQ(batteryIcon->percentage(), 85);

    // Check if the signal was emitted
    EXPECT_EQ(spy.count(), 1);
    EXPECT_EQ(spy.at(0).at(0).toInt(), 85);
}

TEST_F(BatteryIconObjTest, HandleInvalidMessage) {
    // Set initial value
    batteryIcon->setPercentage(50);

    QSignalSpy spy(batteryIcon, &BatteryIconObj::percentageChanged);

    // Create an invalid message
    QString message = "invalid";

    // Call the handle message method
    batteryIcon->callHandleMsg(message);

    // Check if the value was updated to 0 (default for toInt() on invalid string)
    EXPECT_EQ(batteryIcon->percentage(), 0);

    // Check if the signal was emitted
    EXPECT_EQ(spy.count(), 1);
}

int main(int argc, char **argv) {
    QCoreApplication app(argc, argv);
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
