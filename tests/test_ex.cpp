#include <QtTest/QtTest>
#include "CppInterface.h"

class TestCppInterface : public QObject
{
    Q_OBJECT

private slots:
    void testRunOptimization();
    void testDownloadSolution();
    void testSaveSolution();
};

void TestCppInterface::testRunOptimization()
{
    CppInterface cppInterface;
    QSignalSpy spySuccess(&cppInterface, &CppInterface::optimizationDone);
    QSignalSpy spyError(&cppInterface, &CppInterface::optimizationError);

    // Call the method with test parameters
    cppInterface.runOptimization(2, -10.0, 10.0, 1, 1, 100, "testFunction", true, false, true, true, true, false);

    // Wait for the signal to be emitted
    QVERIFY(spySuccess.wait(5000) || spyError.wait(5000));

    // Check if the optimization was successful
    if (spySuccess.count() > 0) {
        QList<QVariant> arguments = spySuccess.takeFirst();
        QByteArray response = arguments.at(0).toByteArray();
        QVERIFY(!response.isEmpty());
    } else {
        QList<QVariant> arguments = spyError.takeFirst();
        QString errorString = arguments.at(0).toString();
        QVERIFY(!errorString.isEmpty());
    }
}

void TestCppInterface::testDownloadSolution()
{
    CppInterface cppInterface;
    QSignalSpy spy(&cppInterface, &CppInterface::downloadCompleted);

    // Call the method
    cppInterface.downloadSolution();

    // Wait for the signal to be emitted
    QVERIFY(spy.wait(5000));

    // Check if the download was successful
    QList<QVariant> arguments = spy.takeFirst();
    QByteArray data = arguments.at(0).toByteArray();
    QVERIFY(!data.isEmpty());
}

void TestCppInterface::testSaveSolution()
{
    CppInterface cppInterface;
    QString filePath = "solution.txt";
    QFile::remove(filePath); // Ensure the file does not exist before the test

    // Call the method
    cppInterface.saveSolution(filePath);

    // Wait for the file to be saved
    QTest::qWait(5000);

    // Check if the file was saved successfully
    QFile file(filePath);
    QVERIFY(file.exists());
    QVERIFY(file.size() > 0);

    // Clean up
    file.remove();
}

QTEST_MAIN(TestCppInterface)
#include "test_ex.moc"
