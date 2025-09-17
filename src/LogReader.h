#ifndef LOGREADER_H
#define LOGREADER_H

#include <QObject>
#include <QString>
#include <QFile>
#include <QTimer>
#include <QDateTime>

class LogReader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString logFilePath READ logFilePath NOTIFY logFilePathChanged)
    Q_PROPERTY(bool logFileExists READ logFileExists NOTIFY logFileExistsChanged)
    Q_PROPERTY(QString lastUpdate READ lastUpdate NOTIFY lastUpdateChanged)
    Q_PROPERTY(QString lastLogLine READ lastLogLine NOTIFY lastLogLineChanged)
    Q_PROPERTY(bool monitoring READ monitoring NOTIFY monitoringChanged)

public:
    explicit LogReader(QObject *parent = nullptr);

    // Property getters
    QString logFilePath() const;
    bool logFileExists() const;
    QString lastUpdate() const;
    QString lastLogLine() const;
    bool monitoring() const;

    // Invokable methods (callable from QML)
    Q_INVOKABLE void findLogFile(const QString &scDirectory);
    Q_INVOKABLE void startMonitoring(int interval = 1000);
    Q_INVOKABLE void stopMonitoring();
    Q_INVOKABLE QStringList getLastLogLines(int count = 10);

signals:
    void logFilePathChanged();
    void logFileExistsChanged();
    void lastUpdateChanged();
    void lastLogLineChanged();
    void monitoringChanged();
    void newLogLinesAvailable(const QStringList &lines);

private slots:
    void checkLogFile();

private:
    QString m_logFilePath;
    bool m_logFileExists;
    QString m_lastUpdate;
    QString m_lastLogLine;
    bool m_monitoring;
    QTimer *m_timer;
    qint64 m_lastPosition;
    QString formatTimestamp(const QDateTime &time);
};

#endif // LOGREADER_H
