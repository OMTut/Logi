#include "ProcessChecker.h"
#include <QDateTime>
#include <QDebug>

#ifdef Q_OS_WIN
#include <windows.h>
#include <tlhelp32.h>
#endif

ProcessChecker::ProcessChecker(QObject *parent)
    : QObject(parent)
    , m_isGameRunning(false)
    , m_logFileExists(false)
    , m_monitoringTimer(new QTimer(this))
    , m_targetProcessName("StarCitizen.exe")
{
    // Connect timer to periodic check
    connect(m_monitoringTimer, &QTimer::timeout, this, &ProcessChecker::performPeriodicCheck);
    
    qDebug() << "ProcessChecker: C++ backend initialized";
}

bool ProcessChecker::isGameRunning() const
{
    return m_isGameRunning;
}

QString ProcessChecker::lastCheckTime() const
{
    return m_lastCheckTime;
}

void ProcessChecker::checkStarCitizenProcess()
{
    qDebug() << "ProcessChecker: Checking for Star Citizen process...";
    
    setLastCheckTime(QDateTime::currentDateTime().toString("hh:mm:ss"));
    
    bool running = isProcessRunning(m_targetProcessName);
    setGameRunning(running);
    
    qDebug() << "ProcessChecker: Star Citizen is" << (running ? "RUNNING" : "NOT RUNNING");
    emit processCheckCompleted(running);
}

void ProcessChecker::startMonitoring(int intervalMs)
{
    qDebug() << "ProcessChecker: Starting monitoring with interval:" << intervalMs << "ms";
    
    // Perform initial check
    checkStarCitizenProcess();
    
    // Start periodic monitoring
    m_monitoringTimer->start(intervalMs);
}

void ProcessChecker::stopMonitoring()
{
    qDebug() << "ProcessChecker: Stopping monitoring";
    m_monitoringTimer->stop();
}

void ProcessChecker::performPeriodicCheck()
{
    checkStarCitizenProcess();
}

bool ProcessChecker::isProcessRunning(const QString& processName)
{
#ifdef Q_OS_WIN
    // Use Windows API to enumerate processes
    HANDLE hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hProcessSnap == INVALID_HANDLE_VALUE) {
        qDebug() << "ProcessChecker: Failed to create process snapshot";
        return false;
    }

    PROCESSENTRY32W pe32;
    pe32.dwSize = sizeof(PROCESSENTRY32W);

    // Get the first process
    if (!Process32FirstW(hProcessSnap, &pe32)) {
        qDebug() << "ProcessChecker: Failed to get first process";
        CloseHandle(hProcessSnap);
        return false;
    }

    // Convert QString to wide string for comparison
    std::wstring targetProcess = processName.toStdWString();

    // Walk through all processes
    do {
        std::wstring currentProcess(pe32.szExeFile);
        
        // Case-insensitive comparison
        if (_wcsicmp(currentProcess.c_str(), targetProcess.c_str()) == 0) {
            qDebug() << "ProcessChecker: Found" << processName << "with PID:" << pe32.th32ProcessID;
            CloseHandle(hProcessSnap);
            return true;
        }
    } while (Process32NextW(hProcessSnap, &pe32));

    CloseHandle(hProcessSnap);
    return false;

#else
    // For non-Windows platforms, you could use different methods
    // For now, return false
    qDebug() << "ProcessChecker: Process checking not implemented for this platform";
    return false;
#endif
}

void ProcessChecker::setGameRunning(bool running)
{
    if (m_isGameRunning != running) {
        m_isGameRunning = running;
        emit gameRunningChanged();
    }
}

void ProcessChecker::setLastCheckTime(const QString& time)
{
    if (m_lastCheckTime != time) {
        m_lastCheckTime = time;
        emit lastCheckTimeChanged();
    }
}

bool ProcessChecker::logFileExists() const
{
    return m_logFileExists;
}

QString ProcessChecker::logFilePath() const
{
    return m_logFilePath;
}

void ProcessChecker::setLogFilePath(const QString &path)
{
    if (m_logFilePath != path) {
        m_logFilePath = path;
        emit logFilePathChanged();
        qDebug() << "ProcessChecker: Log file path set to:" << path;
        
        // TODO: Check if the log file exists and update m_logFileExists
        // This will be implemented when we add log file monitoring
    }
}
