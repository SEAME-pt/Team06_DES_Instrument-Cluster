#include "ZmqSubscriber.hpp"
#include <QDateTime>
#include <QDebug>
#include <iostream>

ZmqSubscriber::ZmqSubscriber(const QString& address, QObject* parent)
    : QObject(parent), _context(1), _socket(_context, zmq::socket_type::sub)
{
    // Set HWM to 1 to only keep latest message
    int hwm = 1;
    _socket.set(zmq::sockopt::rcvhwm, hwm);

    // Enable conflate option to only keep most recent message
    int conflate = 1;
    _socket.set(zmq::sockopt::conflate, conflate);

    // Set zero linger period for clean exits
    int linger = 0;
    _socket.set(zmq::sockopt::linger, linger);

    // Disable Nagle's algorithm for TCP connections
    int tcp_nodelay = 1;
    _socket.set(zmq::sockopt::ipv6, tcp_nodelay);  // This option also disables Nagle's algorithm

    // Sets the address the socket should read from and subscribes to it.
    _socket.connect(address.toStdString());
    _socket.set(zmq::sockopt::subscribe, "");

    // Sets up a socket notifier to send a signal in case of activity.
    int socketFd = _socket.get(zmq::sockopt::fd);
    _notifier = std::unique_ptr<QSocketNotifier>(
                new QSocketNotifier(socketFd, QSocketNotifier::Read));
    connect(_notifier.get(), &QSocketNotifier::activated,
            this, &ZmqSubscriber::onMessageReceived);
}

ZmqSubscriber::~ZmqSubscriber(){}

void    ZmqSubscriber::onMessageReceived()
{
    // Gets messages while there are messages to get.
    while (true)
    {
        zmq::message_t  message;
        zmq::recv_result_t  result = _socket.recv(message, zmq::recv_flags::dontwait);
        if (!result)
            break;
        std::string messageStr = message.to_string();
        QString msgContent = QString::fromStdString(message.to_string());
        std::cout << "Received message: " << messageStr << std::endl;
        // Calls pure virtual method so each child class can deal with the message.
        _handleMsg(msgContent);
    }
}
