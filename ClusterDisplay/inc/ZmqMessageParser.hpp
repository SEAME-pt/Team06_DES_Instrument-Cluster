#ifndef ZMQMESSAGEPARSER_HPP
#define ZMQMESSAGEPARSER_HPP

#include <QObject>
#include <QMap>
#include <QString>

/**
 * @brief Parser for ZeroMQ messages in key:value format
 *
 * This class parses messages with the format "key1:value1;key2:value2;..."
 * and provides easy access to the parsed values.
 */
class ZmqMessageParser : public QObject
{
    Q_OBJECT

public:
    explicit ZmqMessageParser(QObject* parent = nullptr);
    virtual ~ZmqMessageParser();

    /**
     * @brief Parse a message in the format "key1:value1;key2:value2;..."
     * @param message The message string to parse
     * @return Map of key-value pairs
     */
    QMap<QString, QString> parseMessage(const QString& message);

    /**
     * @brief Get a specific value from the last parsed message
     * @param key The key to get the value for
     * @param defaultValue The default value to return if key not found
     * @return The value associated with the key, or defaultValue if not found
     */
    QString getValue(const QString& key, const QString& defaultValue = QString());

    /**
     * @brief Get a specific value from the last parsed message as an integer
     * @param key The key to get the value for
     * @param defaultValue The default value to return if key not found
     * @return The value as integer, or defaultValue if not found or not a valid number
     */
    int getIntValue(const QString& key, int defaultValue = 0);

    /**
     * @brief Get a specific value from the last parsed message as a boolean
     * @param key The key to get the value for
     * @param defaultValue The default value to return if key not found
     * @return The value as boolean (1=true, 0=false), or defaultValue if not found
     */
    bool getBoolValue(const QString& key, bool defaultValue = false);

private:
    QMap<QString, QString> m_lastParsedMessage;
};

#endif // ZMQMESSAGEPARSER_HPP
