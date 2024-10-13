// CppInterface.cpp
#include "CppInterface.h"
#include <QDebug>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonObject>
#include <QJsonDocument>
#include <QEventLoop>

CppInterface::CppInterface(QObject *parent) : QObject(parent) {}

/**
 * @brief Runs the optimization process with the given parameters.
 *
 * This function sends a POST request to the optimization server with the provided parameters
 * and handles the response. It emits signals to notify the QML side about the completion or
 * error of the optimization process.
 *
 * @param dimensions The number of dimensions for the optimization.
 * @param lowerBound The lower bound for the optimization.
 * @param upperBound The upper bound for the optimization.
 * @param gridSizeFactorP The grid size factor P.
 * @param gridSizeFactorQ The grid size factor Q.
 * @param evals The number of evaluations to perform.
 * @param funcName The name of the function to optimize.
 * @param isFunc A boolean indicating if the function is a single function.
 * @param isVect A boolean indicating if the function is a vector function.
 * @param withCache A boolean indicating if caching should be used.
 * @param withLog A boolean indicating if logging should be enabled.
 * @param withOpt A boolean indicating if optimization should be performed.
 */
void CppInterface::runOptimization(int dimensions, double lowerBound, double upperBound, int gridSizeFactorP, int gridSizeFactorQ, int evals, const QString &funcName, bool isFunc, bool isVect, bool withCache, bool withLog, bool withOpt)
{
    // Implement the optimization logic here
    qDebug() << "Running optimization with parameters:";
    qDebug() << "Function Name:" << funcName;
    qDebug() << "Dimensions:" << dimensions;
    qDebug() << "Lower Bound:" << lowerBound;
    qDebug() << "Upper Bound:" << upperBound;
    qDebug() << "Grid Size Factor P:" << gridSizeFactorP;
    qDebug() << "Grid Size Factor Q:" << gridSizeFactorQ;
    qDebug() << "Number of Evals:" << evals;
    qDebug() << "is_func:" << isFunc;
    qDebug() << "is_vect:" << isVect;
    qDebug() << "with_cache:" << withCache;
    qDebug() << "with_log:" << withLog;
    qDebug() << "with_opt:" << withOpt;

    // Prepare the JSON payload
    QJsonObject json;
    json["dimensions"] = dimensions;
    json["lowerBound"] = lowerBound;
    json["upperBound"] = upperBound;
    json["gridSizeFactorP"] = gridSizeFactorP;
    json["gridSizeFactorQ"] = gridSizeFactorQ;
    json["evals"] = evals;
    json["funcName"] = funcName;
    json["isFunc"] = isFunc;
    json["isVect"] = isVect;
    json["withCache"] = withCache;
    json["withLog"] = withLog;
    json["withOpt"] = withOpt;

    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    // Setup the network request
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    QNetworkRequest request(QUrl("http://tq_backend:5000/optimize")); // For containerized deployment
    // QNetworkRequest request(QUrl("http://localhost:5000/optimize")); // For local testing
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    // Send the request
    QNetworkReply *reply = manager->post(request, data);

    // Handle the reply asynchronously
    connect(reply, &QNetworkReply::finished, this, [reply, this]() {
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray response = reply->readAll();
            qDebug() << "Response received:" << response;
            emit optimizationDone(response);
        } else {
            qDebug() << "Error:" << reply->errorString();
            emit optimizationError(reply->errorString());
        }
        reply->deleteLater();
    });
}
