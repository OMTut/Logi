#include "LogReader.h"
#include <QDir>
#include <QFileInfo>
#include <QTextStream>
#include <QDebug>

LogReader::LogReader(QObject *parent)
    : QObject(parent)
    , m_logFileExists(false)
    , m_monitoring(false)
    , m_timer(new QTimer(this))
    , m_lastPosition(0)
{
    connect(m_timer, &QTimer::timeout, this, &LogReader::checkLogFile);
    qDebug() << "LogReader: Initialized";
}

QString LogReader::logFilePath() const
{
    return m_logFilePath;
}

bool LogReader::logFileExists() const
{
    return m_logFileExists;
}

QString LogReader::lastUpdate() const
{
    return m_lastUpdate;
}

QString LogReader::lastLogLine() const
{
    return m_lastLogLine;
}

bool LogReader::monitoring() const
{
    return m_monitoring;
}

void LogReader::findLogFile(const QString &scDirectory)
{
    if (scDirectory.isEmpty()) {
        qDebug() << "LogReader: No Star Citizen directory provided";
        return;
    }

    qDebug() << "LogReader: Searching for Game.log in directory:" << scDirectory;
    
    // Look for Game.log in the provided directory
    QString logPath = QDir(scDirectory).filePath("Game.log");
    qDebug() << "LogReader: Checking path:" << logPath;
    QFileInfo logInfo(logPath);

    if (logInfo.exists() && logInfo.isFile()) {
        qDebug() << "LogReader: Found Game.log directly in main directory";
        if (m_logFilePath != logPath) {
            m_logFilePath = logPath;
            m_lastPosition = 0; // Reset position for new file
            emit logFilePathChanged();
            qDebug() << "LogReader: Found Game.log at:" << logPath;
        }
        
        bool wasExists = m_logFileExists;
        m_logFileExists = true;
        if (wasExists != m_logFileExists) {
            emit logFileExistsChanged();
        }
    } else {
        // Look in common subdirectories
        QStringList subdirs = {"LIVE", "PTU", "EPTU"};
        bool found = false;
        
        for (const QString &subdir : subdirs) {
            logPath = QDir(scDirectory).filePath(subdir + "/Game.log");
            qDebug() << "LogReader: Checking subdirectory path:" << logPath;
            logInfo.setFile(logPath);
            
            if (logInfo.exists() && logInfo.isFile()) {
                qDebug() << "LogReader: Found Game.log in subdirectory:" << subdir;
                if (m_logFilePath != logPath) {
                    m_logFilePath = logPath;
                    m_lastPosition = 0; // Reset position for new file
                    emit logFilePathChanged();
                    qDebug() << "LogReader: Found Game.log at:" << logPath;
                }
                
                bool wasExists = m_logFileExists;
                m_logFileExists = true;
                if (wasExists != m_logFileExists) {
                    emit logFileExistsChanged();
                }
                found = true;
                break;
            }
        }
        
        if (!found) {
            qDebug() << "LogReader: Game.log not found in" << scDirectory;
            bool wasExists = m_logFileExists;
            m_logFileExists = false;
            if (wasExists != m_logFileExists) {
                emit logFileExistsChanged();
            }
        }
    }
}

void LogReader::startMonitoring(int interval)
{
    if (!m_logFileExists || m_logFilePath.isEmpty()) {
        qDebug() << "LogReader: Cannot start monitoring - no valid log file";
        return;
    }

    qDebug() << "LogReader: Starting log monitoring with" << interval << "ms interval";
    m_timer->start(interval);
    
    bool wasMonitoring = m_monitoring;
    m_monitoring = true;
    if (wasMonitoring != m_monitoring) {
        emit monitoringChanged();
    }
    
    // Do initial check
    checkLogFile();
}

void LogReader::stopMonitoring()
{
    qDebug() << "LogReader: Stopping log monitoring";
    m_timer->stop();
    
    bool wasMonitoring = m_monitoring;
    m_monitoring = false;
    if (wasMonitoring != m_monitoring) {
        emit monitoringChanged();
    }
}

QStringList LogReader::getLastLogLines(int count)
{
    QStringList lines;
    
    if (!m_logFileExists || m_logFilePath.isEmpty()) {
        return lines;
    }
    
    QFile file(m_logFilePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "LogReader: Could not open log file for reading";
        return lines;
    }
    
    QTextStream stream(&file);
    QStringList allLines;
    
    while (!stream.atEnd()) {
        allLines.append(stream.readLine());
    }
    
    // Return the last 'count' lines
    int start = qMax(0, allLines.size() - count);
    for (int i = start; i < allLines.size(); ++i) {
        lines.append(allLines[i]);
    }
    
    return lines;
}

void LogReader::checkLogFile()
{
    if (m_logFilePath.isEmpty()) {
        return;
    }
    
    QFile file(m_logFilePath);
    if (!file.exists()) {
        bool wasExists = m_logFileExists;
        m_logFileExists = false;
        if (wasExists != m_logFileExists) {
            emit logFileExistsChanged();
        }
        return;
    }
    
    QFileInfo fileInfo(file);
    QString newUpdate = formatTimestamp(fileInfo.lastModified());
    
    if (newUpdate != m_lastUpdate) {
        m_lastUpdate = newUpdate;
        emit lastUpdateChanged();
    }
    
    // Check for new content
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qint64 fileSize = file.size();
        
        if (fileSize > m_lastPosition) {
            file.seek(m_lastPosition);
            QTextStream stream(&file);
            QStringList newLines;
            
            while (!stream.atEnd()) {
                QString line = stream.readLine();
                if (!line.isEmpty()) {
                    newLines.append(line);
                    m_lastLogLine = line; // Keep track of the very last line
                }
            }
            
            m_lastPosition = fileSize;
            
            if (!newLines.isEmpty()) {
                emit lastLogLineChanged();
                emit newLogLinesAvailable(newLines);
            }
        }
        
        file.close();
    }
}

QString LogReader::formatTimestamp(const QDateTime &time)
{
    return time.toString("hh:mm:ss");
}
