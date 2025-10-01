#include "MockUpdateServer.h"
#include <QDebug>
#include <QTimer>

MockUpdateServer::MockUpdateServer(QObject *parent)
    : QObject(parent)
    , m_server(new QTcpServer(this))
    , m_responseDelay(0)
    , m_httpStatusCode(200)
{
    connect(m_server, &QTcpServer::newConnection,
            this, &MockUpdateServer::onNewConnection);
}

MockUpdateServer::~MockUpdateServer()
{
    stop();
}

bool MockUpdateServer::start(quint16 port)
{
    if (m_server->isListening()) {
        return true;
    }
    
    bool success = m_server->listen(QHostAddress::LocalHost, port);
    if (success) {
        qDebug() << "Mock server started on port" << m_server->serverPort();
    } else {
        qWarning() << "Failed to start mock server:" << m_server->errorString();
    }
    return success;
}

void MockUpdateServer::stop()
{
    if (m_server->isListening()) {
        m_server->close();
        qDebug() << "Mock server stopped";
    }
}

QString MockUpdateServer::url() const
{
    if (!m_server->isListening()) {
        return QString();
    }
    return QString("http://localhost:%1/version.json").arg(m_server->serverPort());
}

quint16 MockUpdateServer::port() const
{
    return m_server->serverPort();
}

void MockUpdateServer::setResponse(const QByteArray &response)
{
    m_response = response;
}

void MockUpdateServer::setResponseDelay(int ms)
{
    m_responseDelay = ms;
}

void MockUpdateServer::setHttpStatusCode(int statusCode)
{
    m_httpStatusCode = statusCode;
}

void MockUpdateServer::onNewConnection()
{
    QTcpSocket *socket = m_server->nextPendingConnection();
    connect(socket, &QTcpSocket::readyRead,
            this, &MockUpdateServer::onReadyRead);
    connect(socket, &QTcpSocket::disconnected,
            this, &MockUpdateServer::onClientDisconnected);
    
    qDebug() << "Client connected:" << socket->peerAddress();
}

void MockUpdateServer::onClientDisconnected()
{
    QTcpSocket *socket = qobject_cast<QTcpSocket*>(sender());
    if (socket) {
        qDebug() << "Client disconnected:" << socket->peerAddress();
        socket->deleteLater();
    }
}

void MockUpdateServer::onReadyRead()
{
    QTcpSocket *socket = qobject_cast<QTcpSocket*>(sender());
    if (!socket) {
        return;
    }
    
    // Read the HTTP request (we don't really need to parse it for testing)
    QByteArray request = socket->readAll();
    qDebug() << "Received request:" << request.left(200) << "...";
    
    // Send response after delay if specified
    if (m_responseDelay > 0) {
        QTimer::singleShot(m_responseDelay, [this, socket]() {
            if (socket && socket->state() == QTcpSocket::ConnectedState) {
                sendHttpResponse(socket, m_response, m_httpStatusCode);
            }
        });
    } else {
        sendHttpResponse(socket, m_response, m_httpStatusCode);
    }
}

void MockUpdateServer::sendHttpResponse(QTcpSocket *socket, const QByteArray &data, int statusCode)
{
    if (!socket || socket->state() != QTcpSocket::ConnectedState) {
        return;
    }
    
    QString statusText = (statusCode == 200) ? "OK" : 
                        (statusCode == 404) ? "Not Found" :
                        (statusCode == 500) ? "Internal Server Error" : "Unknown";
    
    QString headers = QString(
        "HTTP/1.1 %1 %2\r\n"
        "Content-Type: application/json\r\n"
        "Content-Length: %3\r\n"
        "Access-Control-Allow-Origin: *\r\n"
        "Connection: close\r\n"
        "\r\n"
    ).arg(statusCode).arg(statusText).arg(data.size());
    
    socket->write(headers.toUtf8());
    socket->write(data);
    socket->flush();
    
    // Close connection after sending response
    QTimer::singleShot(100, socket, &QTcpSocket::close);
    
    qDebug() << "Sent response:" << statusCode << statusText << "(" << data.size() << "bytes)";
}