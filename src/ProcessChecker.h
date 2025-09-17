#ifndef PROCESSCHECKER_H
#define PROCESSCHECKER_H

#include <QObject>
#include <QString>
#include <QTimer>

class ProcessChecker : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isGameRunning READ isGameRunning NOTIFY gameRunningChanged)
    Q_PROPERTY(QString lastCheckTime READ lastCheckTime NOTIFY lastCheckTimeChanged)

public:
    explicit ProcessChecker(QObject *parent = nullptr);

    // Property getters
    bool isGameRunning() const;
    QString lastCheckTime() const;

    // Invokable methods (callable from QML)
    Q_INVOKABLE void checkStarCitizenProcess();
    Q_INVOKABLE void startMonitoring(int intervalMs = 3000);
    Q_INVOKABLE void stopMonitoring();

signals:
    void gameRunningChanged();
    void lastCheckTimeChanged();
    void processCheckCompleted(bool found);

private slots:
    void performPeriodicCheck();

private:
    // Windows-specific process checking
    bool isProcessRunning(const QString& processName);
    void setGameRunning(bool running);
    void setLastCheckTime(const QString& time);

    bool m_isGameRunning;
    QString m_lastCheckTime;
    QTimer *m_monitoringTimer;
    QString m_targetProcessName;
};

#endif // PROCESSCHECKER_H
