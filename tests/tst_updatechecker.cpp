#include <QtTest/QtTest>
#include <QSignalSpy>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QCoreApplication>
#include "UpdateChecker.h"
#include "MockUpdateServer.h"

class TestUpdateChecker : public QObject
{
    Q_OBJECT

private slots:
    void initTestCase();
    void cleanupTestCase();
    void init();
    void cleanup();

    // Test version comparison
    void testVersionComparison_data();
    void testVersionComparison();

    // Test update checking
    void testNoUpdateAvailable();
    void testOptionalUpdateAvailable();
    void testRequiredUpdateAvailable();
    void testMalformedResponse();
    void testNetworkError();

    // Test properties and signals
    void testUpdateAvailableProperty();
    void testUpdateRequiredProperty();
    void testVersionProperties();

    // Test async behavior
    void testMultipleSimultaneousChecks();
    void testCheckTimeout();

private:
    UpdateChecker *updateChecker;
    MockUpdateServer *mockServer;
};

void TestUpdateChecker::initTestCase()
{
    // Set test application version
    QCoreApplication::setApplicationVersion("1.0.0");
    
    // Start mock server
    mockServer = new MockUpdateServer(this);
    mockServer->start();
}

void TestUpdateChecker::cleanupTestCase()
{
    if (mockServer) {
        mockServer->stop();
        delete mockServer;
    }
}

void TestUpdateChecker::init()
{
    updateChecker = new UpdateChecker(this);
    // Point to mock server instead of real URL
    updateChecker->setVersionCheckUrl(mockServer->url());
}

void TestUpdateChecker::cleanup()
{
    delete updateChecker;
    updateChecker = nullptr;
}

void TestUpdateChecker::testVersionComparison_data()
{
    QTest::addColumn<QString>("currentVersion");
    QTest::addColumn<QString>("latestVersion");
    QTest::addColumn<bool>("expected");

    QTest::newRow("same version") << "1.0.0" << "1.0.0" << false;
    QTest::newRow("newer available") << "1.0.0" << "1.1.0" << true;
    QTest::newRow("major update") << "1.0.0" << "2.0.0" << true;
    QTest::newRow("already latest") << "1.1.0" << "1.0.0" << false;
    QTest::newRow("patch update") << "1.0.0" << "1.0.1" << true;
}

void TestUpdateChecker::testVersionComparison()
{
    QFETCH(QString, currentVersion);
    QFETCH(QString, latestVersion);
    QFETCH(bool, expected);

    QCoreApplication::setApplicationVersion(currentVersion);
    
    // Create test version.json
    QJsonObject versionJson;
    versionJson["version"] = latestVersion;
    versionJson["update_message"] = "Test update";
    versionJson["download_url"] = "https://example.com/download";
    versionJson["release_notes_url"] = "https://example.com/notes";
    versionJson["file_size"] = 1000000;
    versionJson["update_required"] = false;
    
    mockServer->setResponse(QJsonDocument(versionJson).toJson());
    
    QSignalSpy spy(updateChecker, &UpdateChecker::updateCheckComplete);
    updateChecker->checkForUpdates();
    
    // Wait for async operation
    QVERIFY(spy.wait(5000));
    QCOMPARE(spy.count(), 1);
    QCOMPARE(spy.first().first().toBool(), true); // Check succeeded
    
    QCOMPARE(updateChecker->updateAvailable(), expected);
}

void TestUpdateChecker::testNoUpdateAvailable()
{
    QCoreApplication::setApplicationVersion("1.1.0");
    
    QJsonObject versionJson;
    versionJson["version"] = "1.0.0"; // Older version
    versionJson["update_message"] = "No update needed";
    versionJson["download_url"] = "https://example.com/download";
    versionJson["release_notes_url"] = "https://example.com/notes";
    versionJson["file_size"] = 1000000;
    versionJson["update_required"] = false;
    
    mockServer->setResponse(QJsonDocument(versionJson).toJson());
    
    QSignalSpy completeSpy(updateChecker, &UpdateChecker::updateCheckComplete);
    updateChecker->checkForUpdates();
    
    QVERIFY(completeSpy.wait(5000));
    
    // Should not detect update since we have newer version
    QCOMPARE(updateChecker->updateAvailable(), false);
    QCOMPARE(updateChecker->updateRequired(), false);
}

void TestUpdateChecker::testOptionalUpdateAvailable()
{
    QCoreApplication::setApplicationVersion("1.0.0");
    
    QJsonObject versionJson;
    versionJson["version"] = "1.1.0";
    versionJson["update_message"] = "Optional update available";
    versionJson["download_url"] = "https://example.com/download";
    versionJson["release_notes_url"] = "https://example.com/notes";
    versionJson["file_size"] = 1500000;
    versionJson["update_required"] = false;
    
    mockServer->setResponse(QJsonDocument(versionJson).toJson());
    
    QSignalSpy availableSpy(updateChecker, &UpdateChecker::updateAvailableChanged);
    QSignalSpy infoSpy(updateChecker, &UpdateChecker::updateInfoChanged);
    QSignalSpy completeSpy(updateChecker, &UpdateChecker::updateCheckComplete);
    
    updateChecker->checkForUpdates();
    
    QVERIFY(completeSpy.wait(5000));
    
    // Verify properties
    QCOMPARE(updateChecker->updateAvailable(), true);
    QCOMPARE(updateChecker->updateRequired(), false);
    QCOMPARE(updateChecker->latestVersion(), QString("1.1.0"));
    QCOMPARE(updateChecker->updateMessage(), QString("Optional update available"));
    QCOMPARE(updateChecker->fileSize(), qint64(1500000));
    
    // Verify signals were emitted
    QCOMPARE(availableSpy.count(), 1);
    QCOMPARE(infoSpy.count(), 1);
}

void TestUpdateChecker::testRequiredUpdateAvailable()
{
    QCoreApplication::setApplicationVersion("1.0.0");
    
    QJsonObject versionJson;
    versionJson["version"] = "1.5.0";
    versionJson["update_message"] = "Critical security update";
    versionJson["download_url"] = "https://example.com/download";
    versionJson["release_notes_url"] = "https://example.com/notes";
    versionJson["file_size"] = 2000000;
    versionJson["update_required"] = true; // Required update
    
    mockServer->setResponse(QJsonDocument(versionJson).toJson());
    
    QSignalSpy completeSpy(updateChecker, &UpdateChecker::updateCheckComplete);
    
    updateChecker->checkForUpdates();
    QVERIFY(completeSpy.wait(5000));
    
    // Verify required update properties
    QCOMPARE(updateChecker->updateAvailable(), true);
    QCOMPARE(updateChecker->updateRequired(), true);
    QCOMPARE(updateChecker->latestVersion(), QString("1.5.0"));
    QCOMPARE(updateChecker->updateMessage(), QString("Critical security update"));
}

void TestUpdateChecker::testMalformedResponse()
{
    mockServer->setResponse("{ malformed json }");
    
    QSignalSpy completeSpy(updateChecker, &UpdateChecker::updateCheckComplete);
    
    updateChecker->checkForUpdates();
    QVERIFY(completeSpy.wait(5000));
    
    // Should fail gracefully
    QCOMPARE(completeSpy.count(), 1);
    QCOMPARE(completeSpy.first().first().toBool(), false); // Check failed
    QCOMPARE(updateChecker->updateAvailable(), false);
}

void TestUpdateChecker::testNetworkError()
{
    mockServer->stop(); // Simulate network failure
    
    QSignalSpy completeSpy(updateChecker, &UpdateChecker::updateCheckComplete);
    
    updateChecker->checkForUpdates();
    QVERIFY(completeSpy.wait(15000)); // Longer timeout for network error
    
    // Should handle error gracefully
    QCOMPARE(completeSpy.count(), 1);
    QCOMPARE(completeSpy.first().first().toBool(), false);
    QCOMPARE(updateChecker->updateAvailable(), false);
    
    mockServer->start(); // Restart for other tests
}

void TestUpdateChecker::testUpdateAvailableProperty()
{
    // Test initial state
    QCOMPARE(updateChecker->updateAvailable(), false);
    
    QSignalSpy spy(updateChecker, &UpdateChecker::updateAvailableChanged);
    
    // Trigger an update
    QCoreApplication::setApplicationVersion("1.0.0");
    QJsonObject versionJson;
    versionJson["version"] = "1.1.0";
    versionJson["update_required"] = false;
    mockServer->setResponse(QJsonDocument(versionJson).toJson());
    
    updateChecker->checkForUpdates();
    
    // Wait for property change
    QVERIFY(spy.wait(5000));
    QCOMPARE(spy.count(), 1);
    QCOMPARE(updateChecker->updateAvailable(), true);
}

void TestUpdateChecker::testMultipleSimultaneousChecks()
{
    QSignalSpy completeSpy(updateChecker, &UpdateChecker::updateCheckComplete);
    
    // Start multiple checks rapidly
    updateChecker->checkForUpdates();
    updateChecker->checkForUpdates();
    updateChecker->checkForUpdates();
    
    // Should only get one completion signal
    QVERIFY(completeSpy.wait(5000));
    QCOMPARE(completeSpy.count(), 1);
}

void TestUpdateChecker::testUpdateRequiredProperty()
{
    QCoreApplication::setApplicationVersion("1.0.0");
    
    // Create test JSON directly instead of loading from file
    QJsonObject versionJson;
    versionJson["version"] = "2.0.0";
    versionJson["update_message"] = "Critical security update required";
    versionJson["download_url"] = "https://example.com/download";
    versionJson["release_notes_url"] = "https://example.com/notes";
    versionJson["file_size"] = 28000000;
    versionJson["update_required"] = true;
    
    mockServer->setResponse(QJsonDocument(versionJson).toJson());
    
    QSignalSpy completeSpy(updateChecker, &UpdateChecker::updateCheckComplete);
    updateChecker->checkForUpdates();
    
    QVERIFY(completeSpy.wait(5000));
    QCOMPARE(updateChecker->updateRequired(), true);
}

void TestUpdateChecker::testVersionProperties()
{
    QCoreApplication::setApplicationVersion("1.0.0");
    
    QJsonObject versionJson;
    versionJson["version"] = "1.2.5";
    versionJson["update_message"] = "Test message";
    versionJson["download_url"] = "https://test.com/download";
    versionJson["release_notes_url"] = "https://test.com/notes";
    versionJson["file_size"] = 3000000;
    
    mockServer->setResponse(QJsonDocument(versionJson).toJson());
    
    QSignalSpy completeSpy(updateChecker, &UpdateChecker::updateCheckComplete);
    updateChecker->checkForUpdates();
    
    QVERIFY(completeSpy.wait(5000));
    
    // Test all properties
    QCOMPARE(updateChecker->latestVersion(), QString("1.2.5"));
    QCOMPARE(updateChecker->updateMessage(), QString("Test message"));
    QCOMPARE(updateChecker->downloadUrl(), QString("https://test.com/download"));
    QCOMPARE(updateChecker->releaseNotesUrl(), QString("https://test.com/notes"));
    QCOMPARE(updateChecker->fileSize(), qint64(3000000));
}

void TestUpdateChecker::testCheckTimeout()
{
    // TODO: Implement timeout testing
    // This would require a mock server that delays responses
}

QTEST_MAIN(TestUpdateChecker)
#include "tst_updatechecker.moc"
