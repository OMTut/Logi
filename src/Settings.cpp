#include "Settings.h"
#include <QDebug>
#include <QDir>
#include <QStandardPaths>
#include <QFileInfo>

Settings::Settings(QObject *parent)
    : QObject(parent)
    , m_settings(new QSettings(this))
{
    qDebug() << "Settings: Initializing settings system";
    initializeDefaults();
    loadSettings();
}

QString Settings::starCitizenDirectory() const
{
    return m_starCitizenDirectory;
}

void Settings::setStarCitizenDirectory(const QString &path)
{
    if (m_starCitizenDirectory != path) {
        m_starCitizenDirectory = path;
        emit starCitizenDirectoryChanged();
        emit settingsChanged();
        qDebug() << "Settings: Star Citizen directory set to:" << path;
    }
}

void Settings::saveSettings()
{
    qDebug() << "Settings: Saving starCitizenDirectory:" << m_starCitizenDirectory;
    m_settings->setValue("starCitizenDirectory", m_starCitizenDirectory);
    m_settings->sync();
    
    // Debug: Show where settings are being saved
    qDebug() << "Settings: Settings saved to:" << m_settings->fileName();
    qDebug() << "Settings: Sync status:" << (m_settings->status() == QSettings::NoError ? "Success" : "Error");
}

void Settings::loadSettings()
{
    // Debug: Show where settings are being loaded from
    qDebug() << "Settings: Loading from:" << m_settings->fileName();
    
    m_starCitizenDirectory = m_settings->value("starCitizenDirectory", m_starCitizenDirectory).toString();
    
    qDebug() << "Settings: Settings loaded - starCitizenDirectory:" << m_starCitizenDirectory;
    
    emit starCitizenDirectoryChanged();
}

void Settings::resetToDefaults()
{
    qDebug() << "Settings: Resetting to defaults";
    initializeDefaults();
    saveSettings();
    emit starCitizenDirectoryChanged();
    emit settingsChanged();
}


bool Settings::isValidStarCitizenDirectory(const QString &path) const
{
    if (path.isEmpty()) {
        return false;
    }
    
    QFileInfo fileInfo(path);
    // Simply check if the path exists and is a directory
    return fileInfo.exists() && fileInfo.isDir() && fileInfo.isReadable();
}

void Settings::initializeDefaults()
{
    // Set default empty path - user must manually configure
    m_starCitizenDirectory = "";
}

