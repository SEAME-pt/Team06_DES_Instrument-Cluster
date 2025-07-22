#ifndef CLUSTERDATASUBSCRIBER_HPP
#define CLUSTERDATASUBSCRIBER_HPP

#include <QObject>
#include <QMap>
#include <memory>

#include "ZmqMessageParser.hpp"
#include "ZmqSubscriber.hpp"
#include "ClusterModel.hpp"

// Port definitions
#define CRITICAL_DATA_PORT 5555
#define NON_CRITICAL_DATA_PORT 5556

/**
 * @brief Class to manage ZeroMQ subscribers for cluster data
 *
 * This class creates and manages subscribers for critical and non-critical
 * data, parses incoming messages, and updates the cluster model accordingly.
 */
class ClusterDataSubscriber : public QObject
{
    Q_OBJECT

public:
    explicit ClusterDataSubscriber(ClusterModel* clusterModel, QObject* parent = nullptr);
    virtual ~ClusterDataSubscriber();

    /**
     * @brief Enable or disable mocking of data
     * @param enable True to enable mocking, false to use real ZeroMQ data
     */
    void enableMocking(bool enable);

    /**
     * @brief Check if mocking is enabled
     * @return True if mocking is enabled, false otherwise
     */
    bool isMockingEnabled() const;

private slots:
    /**
     * @brief Handle critical data messages
     * @param message The received message
     */
    void handleCriticalData(const QString& message);

    /**
     * @brief Handle non-critical data messages
     * @param message The received message
     */
    void handleNonCriticalData(const QString& message);

    /**
     * @brief Generate mock data for testing
     * Used when mocking is enabled
     */
    void generateMockData();

private:
    /**
     * @brief Process parsed message data and update the cluster model
     * @param data The parsed key-value pairs from the message
     */
    void processData(const QMap<QString, QString>& data);

    ClusterModel* m_clusterModel;                   ///< Pointer to cluster model
    std::unique_ptr<ZmqSubscriber> m_criticalSub;   ///< Critical data subscriber
    std::unique_ptr<ZmqSubscriber> m_nonCriticalSub;///< Non-critical data subscriber
    ZmqMessageParser m_parser;                      ///< Message parser
    QTimer* m_mockTimer;                            ///< Timer for mock data generation
    bool m_mockingEnabled;                          ///< Mocking status
};

#endif // CLUSTERDATASUBSCRIBER_HPP
