#include "ZmqSubscriber.hpp"

#include <QDebug>

ZmqSubscriber::ZmqSubscriber(const QString& address, QObject* parent)
    : QObject(parent), _context(1), _socket(_context, zmq::socket_type::sub)
{
    // Configure socket options for optimal performance

    // Set high water mark to 1 to only keep latest message
    _socket.set(zmq::sockopt::rcvhwm, 1);

    // Enable conflate option to only keep most recent message
    _socket.set(zmq::sockopt::conflate, 1);

    // Set zero linger period for clean exits
    _socket.set(zmq::sockopt::linger, 0);

    // Disable Nagle's algorithm for TCP connections
    _socket.set(zmq::sockopt::ipv6, 1);

    // Connect to the specified address
    _socket.connect(address.toStdString());

    // Subscribe to all messages (empty filter)
    _socket.set(zmq::sockopt::subscribe, "");

    // Set up socket notifier for Qt event integration
    int socketFd = _socket.get(zmq::sockopt::fd);
    _notifier = std::make_unique<QSocketNotifier>(socketFd, QSocketNotifier::Read);
    connect(_notifier.get(), &QSocketNotifier::activated, this, &ZmqSubscriber::onMessageReceived);
}

ZmqSubscriber::~ZmqSubscriber()
{
    // Socket and context are automatically closed by their destructors
}

void ZmqSubscriber::onMessageReceived()
{
    // Process all available messages in the queue
    while (true)
    {
        zmq::message_t message;
        zmq::recv_result_t result = _socket.recv(message, zmq::recv_flags::dontwait);

        // Break if no more messages
        if (!result)
            break;

        // Convert message to QString and emit signal
        QString msgContent = QString::fromStdString(message.to_string());
        qDebug() << "ZMQ received:" << msgContent;

        emit messageReceived(msgContent);
    }
}
