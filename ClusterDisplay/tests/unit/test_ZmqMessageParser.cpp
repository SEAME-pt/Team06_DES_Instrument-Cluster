#include <gtest/gtest.h>

#include <QSignalSpy>

#include "ZmqMessageParser.hpp"

class ZmqMessageParserTest : public ::testing::Test
{
protected:
    void SetUp() override { parser = new ZmqMessageParser(); }

    void TearDown() override { delete parser; }

    ZmqMessageParser* parser;
};

TEST_F(ZmqMessageParserTest, BasicParsing)
{
    QString message = "key1:value1;key2:value2;key3:value3;";

    QMap<QString, QString> result = parser->parseMessage(message);

    EXPECT_EQ(result.size(), 3);
    EXPECT_EQ(result["key1"], "value1");
    EXPECT_EQ(result["key2"], "value2");
    EXPECT_EQ(result["key3"], "value3");
}

TEST_F(ZmqMessageParserTest, GetValue)
{
    QString message = "speed:120;battery:85;charging:1;";
    parser->parseMessage(message);

    EXPECT_EQ(parser->getValue("speed"), "120");
    EXPECT_EQ(parser->getValue("battery"), "85");
    EXPECT_EQ(parser->getValue("charging"), "1");
    EXPECT_EQ(parser->getValue("nonexistent", "default"), "default");
}

TEST_F(ZmqMessageParserTest, GetIntValue)
{
    QString message = "speed:120;battery:85;invalid:abc;";
    parser->parseMessage(message);

    EXPECT_EQ(parser->getIntValue("speed"), 120);
    EXPECT_EQ(parser->getIntValue("battery"), 85);
    EXPECT_EQ(parser->getIntValue("invalid", 42), 42); // Should return default
    EXPECT_EQ(parser->getIntValue("nonexistent", 99), 99);
}

TEST_F(ZmqMessageParserTest, GetBoolValue)
{
    QString message = "charging:1;off:0;invalid:abc;";
    parser->parseMessage(message);

    EXPECT_TRUE(parser->getBoolValue("charging"));
    EXPECT_FALSE(parser->getBoolValue("off"));
    EXPECT_EQ(parser->getBoolValue("invalid", true), true); // Should return default
    EXPECT_EQ(parser->getBoolValue("nonexistent", false), false);
}

TEST_F(ZmqMessageParserTest, InvalidFormat)
{
    QString message = "key1=value1;key2:value2";

    QMap<QString, QString> result = parser->parseMessage(message);

    // Should only contain the correctly formatted key-value pair
    EXPECT_EQ(result.size(), 1);
    EXPECT_FALSE(result.contains("key1"));
    EXPECT_EQ(result["key2"], "value2");
}

TEST_F(ZmqMessageParserTest, EmptyString)
{
    QString message = "";

    QMap<QString, QString> result = parser->parseMessage(message);

    EXPECT_EQ(result.size(), 0);
}

TEST_F(ZmqMessageParserTest, RealWorldExample)
{
    QString message = "battery:20;charging:1;lane:1;obs:1;sign:50";

    QMap<QString, QString> result = parser->parseMessage(message);

    EXPECT_EQ(result.size(), 5);
    EXPECT_EQ(parser->getIntValue("battery"), 20);
    EXPECT_TRUE(parser->getBoolValue("charging"));
    EXPECT_EQ(parser->getIntValue("lane"), 1);
    EXPECT_TRUE(parser->getBoolValue("obs"));
    EXPECT_EQ(parser->getIntValue("sign"), 50);
}

TEST_F(ZmqMessageParserTest, NewSignTypes)
{
    // Test stop sign message
    QString stopMessage = "speed:30;sign:stop;battery:80;";
    QMap<QString, QString> stopResult = parser->parseMessage(stopMessage);

    EXPECT_EQ(stopResult.size(), 3);
    EXPECT_EQ(parser->getValue("sign"), "stop");
    EXPECT_EQ(parser->getIntValue("speed"), 30);
    EXPECT_EQ(parser->getIntValue("battery"), 80);

    // Test crosswalk sign message
    QString crosswalkMessage = "speed:45;sign:crosswalk;mode:1;";
    QMap<QString, QString> crosswalkResult = parser->parseMessage(crosswalkMessage);

    EXPECT_EQ(crosswalkResult.size(), 3);
    EXPECT_EQ(parser->getValue("sign"), "crosswalk");
    EXPECT_EQ(parser->getIntValue("speed"), 45);
    EXPECT_EQ(parser->getIntValue("mode"), 1);

    // Test numeric speed limit still works
    QString speedLimitMessage = "speed:60;sign:70;battery:90;";
    QMap<QString, QString> speedLimitResult = parser->parseMessage(speedLimitMessage);

    EXPECT_EQ(speedLimitResult.size(), 3);
    EXPECT_EQ(parser->getValue("sign"), "70");
    EXPECT_EQ(parser->getIntValue("sign"), 70);
    EXPECT_EQ(parser->getIntValue("speed"), 60);
}

int main(int argc, char** argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
