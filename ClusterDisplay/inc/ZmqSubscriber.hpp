#ifndef ZMQSUBSCRIBER_HPP
#define ZMQSUBSCRIBER_HPP

#include <QObject>
#include <QSocketNotifier>
#include <memory>
#include <zmq.hpp>

/**
 * @brief ZeroMQ subscriber class for receiving messages from publishers
 *
 * This class handles ZeroMQ socket connections and message reception,
 * integrating with Qt's event system via QSocketNotifier.
 */
class ZmqSubscriber : public QObject
{
    Q_OBJECT

public:
    /**
     * @brief Constructs a ZMQ subscriber connected to the specified address
     * @param address The ZMQ endpoint address to connect to
     * @param parent The parent QObject
     */
    ZmqSubscriber(const QString& address, QObject* parent = nullptr);

    /**
     * @brief Destructor
     */
    ~ZmqSubscriber();

public slots:
    /**
     * @brief Slot called when new messages are available to read
     */
    void onMessageReceived();

signals:
    /**
     * @brief Signal emitted when a message is received
     * @param message The received message content
     */
    void messageReceived(const QString& message);

private:
    zmq::context_t _context;                     ///< ZMQ context managing thread resources
    zmq::socket_t _socket;                       ///< ZMQ socket for receiving messages
    std::unique_ptr<QSocketNotifier> _notifier;  ///< Notifier for socket activity
};

#endif  // ZMQSUBSCRIBER_HPP
