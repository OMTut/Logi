#ifndef UPDATECHECKER_H
#define UPDATECHECKER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonObject>
#include <QJsonDocument>
#include <QTimer>
#include <QVersionNumber>

class UpdateChecker : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool updateAvailable READ updateAvailable NOTIFY updateAvailableChanged)
    Q_PROPERTY(QString latestVersion READ latestVersion NOTIFY updateInfoChanged)
    Q_PROPERTY(QString updateMessage READ updateMessage NOTIFY updateInfoChanged)
    Q_PROPERTY(QStringList changelog READ changelog NOTIFY updateInfoChanged)
    Q_PROPERTY(QString downloadUrl READ downloadUrl NOTIFY updateInfoChanged)
    Q_PROPERTY(QString releaseNotesUrl READ releaseNotesUrl NOTIFY updateInfoChanged)
    Q_PROPERTY(qint64 fileSize READ fileSize NOTIFY updateInfoChanged)
    Q_PROPERTY(bool updateRequired READ updateRequired NOTIFY updateInfoChanged)
    Q_PROPERTY(bool isChecking READ isChecking NOTIFY isCheckingChanged)

public:
    explicit UpdateChecker(QObject *parent = nullptr);

    // Property getters
    bool updateAvailable() const { return m_updateAvailable; }
    QString latestVersion() const { return m_latestVersion; }
    QString updateMessage() const { return m_updateMessage; }
    QStringList changelog() const { return m_changelog; }
    QString downloadUrl() const { return m_downloadUrl; }
    QString releaseNotesUrl() const { return m_releaseNotesUrl; }
    qint64 fileSize() const { return m_fileSize; }
    bool updateRequired() const { return m_updateRequired; }
    bool isChecking() const { return m_isChecking; }

    // Invokable methods (callable from QML)
    Q_INVOKABLE void checkForUpdates();
    Q_INVOKABLE void downloadUpdate();
    Q_INVOKABLE void openReleaseNotes();
    Q_INVOKABLE QString getCurrentVersion() const;
    
    // Testing support
    void setVersionCheckUrl(const QString &url);

signals:
    void updateAvailableChanged();
    void updateInfoChanged();
    void isCheckingChanged();
    void updateCheckComplete(bool success, const QString &errorMessage = QString());
    void downloadProgress(qint64 received, qint64 total);
    void downloadComplete(const QString &filePath);
    void downloadFailed(const QString &errorMessage);

private slots:
    void onUpdateCheckFinished();
    void onDownloadProgress(qint64 received, qint64 total);
    void onDownloadFinished();

private:
    void parseVersionInfo(const QJsonObject &json);
    bool isVersionNewer(const QString &currentVersion, const QString &latestVersion) const;
    void setUpdateAvailable(bool available);
    void setIsChecking(bool checking);

    // Network
    QNetworkAccessManager *m_networkManager;
    QNetworkReply *m_currentReply;
    QNetworkReply *m_downloadReply;
    
    // Update info
    bool m_updateAvailable;
    QString m_latestVersion;
    QString m_updateMessage;
    QStringList m_changelog;
    QString m_downloadUrl;
    QString m_releaseNotesUrl;
    qint64 m_fileSize;
    bool m_updateRequired;
    bool m_isChecking;
    
    // Configuration
    static const QString VERSION_CHECK_URL;
    static const int CHECK_TIMEOUT_MS;
    QString m_customUrl; // For testing
};

#endif // UPDATECHECKER_H