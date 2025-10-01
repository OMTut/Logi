#ifndef MOCKUPDATESERVER_H
#define MOCKUPDATESERVER_H

#include <QObject>
#include <QTcpServer>
#include <QTcpSocket>
#include <QString>
#include <QUrl>

class MockUpdateServer : public QObject
{
    Q_OBJECT

public:
    explicit MockUpdateServer(QObject *parent = nullptr);
    ~MockUpdateServer();

    bool start(quint16 port = 0); // 0 = auto-assign port
    void stop();
    
    QString url() const;
    quint16 port() const;
    
    // Set the JSON response to return
    void setResponse(const QByteArray &response);
    void setResponseDelay(int ms); // For testing timeouts
    void setHttpStatusCode(int statusCode);

private slots:
    void onNewConnection();
    void onClientDisconnected();
    void onReadyRead();

private:
    void sendHttpResponse(QTcpSocket *socket, const QByteArray &data, int statusCode = 200);
    
    QTcpServer *m_server;
    QByteArray m_response;
    int m_responseDelay;
    int m_httpStatusCode;
};

#endif // MOCKUPDATESERVER_H