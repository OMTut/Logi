#include "UpdateChecker.h"
#include <QCoreApplication>
#include <QJsonArray>
#include <QJsonParseError>
#include <QDesktopServices>
#include <QUrl>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>
#include <QProcess>

const QString UpdateChecker::VERSION_CHECK_URL = "https://raw.githubusercontent.com/OMTut/Logi/master/version.json";
const int UpdateChecker::CHECK_TIMEOUT_MS = 10000; // 10 seconds

UpdateChecker::UpdateChecker(QObject *parent)
    : QObject(parent)
    , m_networkManager(new QNetworkAccessManager(this))
    , m_currentReply(nullptr)
    , m_downloadReply(nullptr)
    , m_updateAvailable(false)
    , m_fileSize(0)
    , m_updateRequired(false)
    , m_isChecking(false)
{
    // Set timeout for network requests
    m_networkManager->setTransferTimeout(CHECK_TIMEOUT_MS);
}

void UpdateChecker::checkForUpdates()
{
    if (m_isChecking) {
        qDebug() << "Update check already in progress";
        return;
    }

    setIsChecking(true);
    setUpdateAvailable(false);

    QString url = m_customUrl.isEmpty() ? VERSION_CHECK_URL : m_customUrl;
    qDebug() << "Checking for updates from:" << url;

    QNetworkRequest request{QUrl(url)};
    request.setHeader(QNetworkRequest::UserAgentHeader, 
                     QString("Logi/%1").arg(getCurrentVersion()));
    
    // Add cache control headers to ensure fresh data
    request.setRawHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    request.setRawHeader("Pragma", "no-cache");
    request.setRawHeader("Expires", "0");

    m_currentReply = m_networkManager->get(request);
    
    connect(m_currentReply, &QNetworkReply::finished, 
            this, &UpdateChecker::onUpdateCheckFinished);
}

void UpdateChecker::onUpdateCheckFinished()
{
    if (!m_currentReply) {
        setIsChecking(false);
        return;
    }

    QNetworkReply::NetworkError error = m_currentReply->error();
    QString errorMessage;
    
    if (error != QNetworkReply::NoError) {
        errorMessage = QString("Network error: %1").arg(m_currentReply->errorString());
        qWarning() << "Update check failed:" << errorMessage;
        emit updateCheckComplete(false, errorMessage);
    } else {
        QByteArray data = m_currentReply->readAll();
        qDebug() << "Received update data:" << data;
        
        QJsonParseError parseError;
        QJsonDocument doc = QJsonDocument::fromJson(data, &parseError);
        
        if (parseError.error != QJsonParseError::NoError) {
            errorMessage = QString("JSON parse error: %1").arg(parseError.errorString());
            qWarning() << "Failed to parse version JSON:" << errorMessage;
            emit updateCheckComplete(false, errorMessage);
        } else {
            QJsonObject jsonObj = doc.object();
            parseVersionInfo(jsonObj);
            emit updateCheckComplete(true);
        }
    }

    m_currentReply->deleteLater();
    m_currentReply = nullptr;
    setIsChecking(false);
}

void UpdateChecker::parseVersionInfo(const QJsonObject &json)
{
    QString latestVersion = json["version"].toString();
    QString currentVersion = getCurrentVersion();
    
    qDebug() << "Current version:" << currentVersion;
    qDebug() << "Latest version:" << latestVersion;
    
    if (isVersionNewer(currentVersion, latestVersion)) {
        m_latestVersion = latestVersion;
        m_updateMessage = json["update_message"].toString();
        m_downloadUrl = json["download_url"].toString();
        m_releaseNotesUrl = json["release_notes_url"].toString();
        m_fileSize = json["file_size"].toInteger();
        m_updateRequired = json["update_required"].toBool();
        
        // Parse changelog array
        m_changelog.clear();
        QJsonArray changelogArray = json["changelog"].toArray();
        for (const QJsonValue &value : changelogArray) {
            m_changelog.append(value.toString());
        }
        
        setUpdateAvailable(true);
        emit updateInfoChanged();
        
        qDebug() << "Update available!" << latestVersion;
        qDebug() << "Download URL:" << m_downloadUrl;
        qDebug() << "File size:" << m_fileSize << "bytes";
        qDebug() << "Update required:" << m_updateRequired;
    } else {
        setUpdateAvailable(false);
        qDebug() << "No update available. Current version is up to date.";
    }
}

bool UpdateChecker::isVersionNewer(const QString &currentVersion, const QString &latestVersion) const
{
    QVersionNumber current = QVersionNumber::fromString(currentVersion);
    QVersionNumber latest = QVersionNumber::fromString(latestVersion);
    
    return QVersionNumber::compare(latest, current) > 0;
}

void UpdateChecker::downloadUpdate()
{
    if (m_downloadUrl.isEmpty()) {
        emit downloadFailed("No download URL available");
        return;
    }
    
    if (m_downloadReply) {
        qDebug() << "Download already in progress";
        return;
    }
    
    qDebug() << "Starting download from:" << m_downloadUrl;
    
    QNetworkRequest request{QUrl(m_downloadUrl)};
    request.setHeader(QNetworkRequest::UserAgentHeader, 
                     QString("Logi/%1").arg(getCurrentVersion()));
    
    m_downloadReply = m_networkManager->get(request);
    
    connect(m_downloadReply, &QNetworkReply::downloadProgress,
            this, &UpdateChecker::onDownloadProgress);
    connect(m_downloadReply, &QNetworkReply::finished,
            this, &UpdateChecker::onDownloadFinished);
}

void UpdateChecker::onDownloadProgress(qint64 received, qint64 total)
{
    emit downloadProgress(received, total);
}

void UpdateChecker::onDownloadFinished()
{
    if (!m_downloadReply) {
        return;
    }
    
    QNetworkReply::NetworkError error = m_downloadReply->error();
    
    if (error != QNetworkReply::NoError) {
        QString errorMessage = QString("Download failed: %1").arg(m_downloadReply->errorString());
        qWarning() << errorMessage;
        emit downloadFailed(errorMessage);
    } else {
        // Save the downloaded file
        QByteArray data = m_downloadReply->readAll();
        
        QString downloadsPath = QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
        QString fileName = QString("LogiSetup_%1.exe").arg(m_latestVersion);
        QString filePath = QDir(downloadsPath).filePath(fileName);
        
        QFile file(filePath);
        if (file.open(QIODevice::WriteOnly)) {
            file.write(data);
            file.close();
            
            qDebug() << "Download complete:" << filePath;
            emit downloadComplete(filePath);
            
            // Optional: Launch the installer
            QDesktopServices::openUrl(QUrl::fromLocalFile(QDir(downloadsPath).absolutePath()));
            
        } else {
            QString errorMessage = QString("Failed to save file: %1").arg(file.errorString());
            qWarning() << errorMessage;
            emit downloadFailed(errorMessage);
        }
    }
    
    m_downloadReply->deleteLater();
    m_downloadReply = nullptr;
}

void UpdateChecker::openReleaseNotes()
{
    if (!m_releaseNotesUrl.isEmpty()) {
        QDesktopServices::openUrl(QUrl(m_releaseNotesUrl));
    }
}

QString UpdateChecker::getCurrentVersion() const
{
    return QCoreApplication::applicationVersion();
}

void UpdateChecker::setUpdateAvailable(bool available)
{
    if (m_updateAvailable != available) {
        m_updateAvailable = available;
        emit updateAvailableChanged();
    }
}

void UpdateChecker::setIsChecking(bool checking)
{
    if (m_isChecking != checking) {
        m_isChecking = checking;
        emit isCheckingChanged();
    }
}

void UpdateChecker::setVersionCheckUrl(const QString &url)
{
    m_customUrl = url;
}
