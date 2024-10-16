// CppInterface.h
#ifndef CPPINTERFACE_H
#define CPPINTERFACE_H

#include <QObject>

class CppInterface : public QObject
{
    Q_OBJECT

public:
    explicit CppInterface(QObject *parent = nullptr);

    Q_INVOKABLE void runOptimization(int dimensions, double lowerBound, double upperBound, int gridSizeFactorP, int gridSizeFactorQ, int evals, const QString &funcName, bool isFunc, bool isVect, bool withCache, bool withLog, bool withOpt, bool forceRecal=false);
    Q_INVOKABLE void downloadSolution();
    Q_INVOKABLE void saveSolution(const QString &filePath);

signals:
    void optimizationDone(const QByteArray &response);
    void optimizationError(const QString &errorString);
    void downloadCompleted(const QByteArray &data);
};

#endif // CPPINTERFACE_H
