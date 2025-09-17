#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QString>
#include <QSettings>

class Settings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString starCitizenDirectory READ starCitizenDirectory WRITE setStarCitizenDirectory NOTIFY starCitizenDirectoryChanged)

public:
    explicit Settings(QObject *parent = nullptr);

    // Property getters
    Q_INVOKABLE QString starCitizenDirectory() const;

    // Property setters
    Q_INVOKABLE void setStarCitizenDirectory(const QString &path);

    // Invokable methods (callable from QML)
    Q_INVOKABLE void saveSettings();
    Q_INVOKABLE void loadSettings();
    Q_INVOKABLE void resetToDefaults();
    Q_INVOKABLE bool isValidStarCitizenDirectory(const QString &path) const;

signals:
    void starCitizenDirectoryChanged();
    void settingsChanged();

private:
    void initializeDefaults();

    QString m_starCitizenDirectory;
    QSettings *m_settings;
};

#endif // SETTINGS_H
