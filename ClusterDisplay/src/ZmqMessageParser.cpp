#include "ZmqMessageParser.hpp"

ZmqMessageParser::ZmqMessageParser(QObject* parent)
    : QObject(parent)
{
}

ZmqMessageParser::~ZmqMessageParser()
{
}

QMap<QString, QString> ZmqMessageParser::parseMessage(const QString& message)
{
    m_lastParsedMessage.clear();

    // Split the message by semicolons to get key:value pairs
    QStringList pairs = message.split(';', Qt::SkipEmptyParts);

    // Process each pair
    for (const QString& pair : pairs)
    {
        // Split by colon to get key and value
        QStringList keyValue = pair.split(':', Qt::SkipEmptyParts);

        // Only add if we have both a key and value
        if (keyValue.size() == 2)
        {
            m_lastParsedMessage[keyValue[0].trimmed()] = keyValue[1].trimmed();
        }
    }

    return m_lastParsedMessage;
}

QString ZmqMessageParser::getValue(const QString& key, const QString& defaultValue)
{
    return m_lastParsedMessage.value(key, defaultValue);
}

int ZmqMessageParser::getIntValue(const QString& key, int defaultValue)
{
    QString value = getValue(key);

    bool ok;
    int intValue = value.toInt(&ok);

    return ok ? intValue : defaultValue;
}

bool ZmqMessageParser::getBoolValue(const QString& key, bool defaultValue)
{
    QString value = getValue(key);

    // Empty value, return default
    if (value.isEmpty())
    {
        return defaultValue;
    }

    // Convert to integer and check if it's 1 (true) or 0 (false)
    bool ok;
    int intValue = value.toInt(&ok);

    // If conversion failed, return default
    if (!ok)
    {
        return defaultValue;
    }

    // Return true for 1, false for 0, default for other values
    return intValue == 1 ? true : (intValue == 0 ? false : defaultValue);
}
