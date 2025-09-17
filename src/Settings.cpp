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
    m_settings->setValue("starCitizenDirectory", m_starCitizenDirectory);
    m_settings->sync();
    qDebug() << "Settings: Settings saved to registry/config";
}

void Settings::loadSettings()
{
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

