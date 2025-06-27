#include <gmock/gmock.h>
#include <gtest/gtest.h>

#include <QSignalSpy>

#include "ZmqSubscriber.hpp"

// Mock class for ZmqSubscriber to avoid actual network connections
class MockZmqSubscriber : public ZmqSubscriber
{
public:
    MockZmqSubscriber(QObject* parent = nullptr) : ZmqSubscriber("tcp://localhost:5555", parent) {}

    // Method to simulate message reception
    void simulateMessageReceived(const QString& message) { emit messageReceived(message); }
};

class ZmqSubscriberTest : public ::testing::Test
{
protected:
    void SetUp() override { subscriber = new MockZmqSubscriber(); }

    void TearDown() override { delete subscriber; }

    MockZmqSubscriber* subscriber;
};

TEST_F(ZmqSubscriberTest, MessageReceivedSignalEmission)
{
    QSignalSpy spy(subscriber, &ZmqSubscriber::messageReceived);

    // Simulate receiving a message
    subscriber->simulateMessageReceived("test_message");

    // Check if the signal was emitted
    EXPECT_EQ(spy.count(), 1);
    EXPECT_EQ(spy.at(0).at(0).toString(), "test_message");
}

TEST_F(ZmqSubscriberTest, MultipleMessageReception)
{
    QSignalSpy spy(subscriber, &ZmqSubscriber::messageReceived);

    // Simulate receiving multiple messages
    subscriber->simulateMessageReceived("message1");
    subscriber->simulateMessageReceived("message2");
    subscriber->simulateMessageReceived("message3");

    // Check if all signals were emitted
    EXPECT_EQ(spy.count(), 3);
    EXPECT_EQ(spy.at(0).at(0).toString(), "message1");
    EXPECT_EQ(spy.at(1).at(0).toString(), "message2");
    EXPECT_EQ(spy.at(2).at(0).toString(), "message3");
}

int main(int argc, char** argv)
{
    QCoreApplication app(argc, argv);
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
