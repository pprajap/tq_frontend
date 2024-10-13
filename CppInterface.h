// CppInterface.h
#ifndef CPPINTERFACE_H
#define CPPINTERFACE_H

#include <QObject>

/**
 * @class CppInterface
 * @brief A class that provides an interface for running optimization tasks.
 * 
 * This class inherits from QObject and provides a method to run optimization
 * tasks with various parameters. It also emits signals upon completion or 
 * error of the optimization process.
 */
class CppInterface : public QObject
{
    Q_OBJECT
public:
    /**
     * @brief Constructor for CppInterface.
     * 
     * @param parent The parent QObject, default is nullptr.
     */
    explicit CppInterface(QObject *parent = nullptr);

    /**
     * @brief Runs an optimization task with the given parameters.
     * 
     * @param dimensions The number of dimensions for the optimization.
     * @param lowerBound The lower bound for the optimization.
     * @param upperBound The upper bound for the optimization.
     * @param gridSizeFactorP The grid size factor P.
     * @param gridSizeFactorQ The grid size factor Q.
     * @param evals The number of evaluations to perform.
     * @param funcName The name of the function to optimize.
     * @param isFunc Boolean indicating if the target is a function.
     * @param isVect Boolean indicating if the target is a vector.
     * @param withCache Boolean indicating if caching should be used.
     * @param withLog Boolean indicating if logging should be enabled.
     * @param withOpt Boolean indicating if optimization should be performed.
     */
    Q_INVOKABLE void runOptimization(int dimensions, double lowerBound, double upperBound, int gridSizeFactorP, int gridSizeFactorQ, int evals, const QString &funcName, bool isFunc, bool isVect, bool withCache, bool withLog, bool withOpt, bool forceRecal=false);
    Q_INVOKABLE void downloadSolution();
    Q_INVOKABLE void saveSolution(const QString &filePath);
signals:
    /**
     * @brief Signal emitted when the optimization is done.
     * 
     * @param response The response data as a QByteArray.
     */
    void optimizationDone(const QByteArray &response);

    /**
     * @brief Signal emitted when there is an error in the optimization process.
     * 
     * @param errorString The error message as a QString.
     */
    void optimizationError(const QString &errorString);
    void downloadCompleted(const QByteArray &data);
};

#endif // CPPINTERFACE_H
