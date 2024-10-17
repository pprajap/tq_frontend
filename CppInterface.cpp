// CppInterface.cpp
#include "CppInterface.h"
#include <QDebug>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonObject>
#include <QJsonDocument>
#include <QFile>

#define REVERSE_PROXY_IP "34.32.40.192" // External IP of the reverse proxy

CppInterface::CppInterface(QObject *parent) : QObject(parent) {}

void CppInterface::runOptimization(int dimensions, double lowerBound, double upperBound, int gridSizeFactorP, int gridSizeFactorQ, int evals, const QString &funcName, bool isFunc, bool isVect, bool withCache, bool withLog, bool withOpt, bool forceRecal)
{
    qDebug() << "Running optimization with parameters:"
             << "Function Name:" << funcName
             << "Dimensions:" << dimensions
             << "Lower Bound:" << lowerBound
             << "Upper Bound:" << upperBound
             << "Grid Size Factor P:" << gridSizeFactorP
             << "Grid Size Factor Q:" << gridSizeFactorQ
             << "Number of Evals:" << evals
             << "is_func:" << isFunc
             << "is_vect:" << isVect
             << "with_cache:" << withCache
             << "with_log:" << withLog
             << "with_opt:" << withOpt
             << "force_recalculate" << forceRecal;

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
    json["forceRecal"] = forceRecal;

    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    QNetworkRequest request;
    if(this->bIsOnline) {
        qDebug() << "Sending request at http://" REVERSE_PROXY_IP "/optimize";
        request.setUrl(QUrl("http://" REVERSE_PROXY_IP "/optimize")); // For cloud deployment
    }
    else {
        qDebug() << "Sending request at http://localhost:5000/optimize";
        request.setUrl(QUrl("http://localhost:5000/optimize")); // For local testing
    }
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    QNetworkReply *reply = manager->post(request, data);
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

void CppInterface::downloadSolution()
{
    qDebug() << "Downloading solution...";

#ifdef CLOUD_DEPLOYMENT
    qDebug() << "Sending request at http://" REVERSE_PROXY_IP "/download_solution";
    QNetworkRequest request(QUrl("http://" REVERSE_PROXY_IP "/download_solution")); // For cloud deployment
#elif defined(CONTAINERIZED_DEPLOYMENT)
    qDebug() << "Sending request at http://localhost/download_solution";
    QNetworkRequest request(QUrl("http://localhost/download_solution")); // For containerized deployment
#else
    qDebug() << "Sending request at http://localhost:5000/download_solution";
    QNetworkRequest request(QUrl("http://localhost:5000/download_solution")); // For local testing
#endif

    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    QNetworkReply *reply = manager->get(request);
    connect(reply, &QNetworkReply::finished, this, [reply, this]() {
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray data = reply->readAll();
            qDebug() << "Download completed";
            emit downloadCompleted(data);
        } else {
            qDebug() << "Download failed:" << reply->errorString();
        }
        reply->deleteLater();
    });
}

void CppInterface::saveSolution(const QString &filePath)
{
    qDebug() << "saving solution...";
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);

#ifdef CLOUD_DEPLOYMENT
    qDebug() << "Sending request at http://" REVERSE_PROXY_IP "/download_solution";
    QNetworkRequest request(QUrl("http://" REVERSE_PROXY_IP "/download_solution")); // For cloud deployment
#elif defined(CONTAINERIZED_DEPLOYMENT)
    qDebug() << "Sending request at http://localhost/download_solution";
    QNetworkRequest request(QUrl("http://localhost/download_solution")); // For containerized deployment
#else
    qDebug() << "Sending request at http://localhost:5000/download_solution";
    QNetworkRequest request(QUrl("http://localhost:5000/download_solution")); // For local testing
#endif

    QNetworkReply *reply = manager->get(request);
    connect(reply, &QNetworkReply::finished, this, [reply, this, filePath]() {
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray data = reply->readAll();
            QFile file(filePath);
            if (file.open(QIODevice::WriteOnly)) {
                file.write(data);
                file.close();
                qDebug() << "File saved at: " << filePath;              
            } else {
                qDebug() << "Failed to open file for writing";
            }
        } else {
            qDebug() << "Save failed:" << reply->errorString();
        }
        reply->deleteLater();
    });
}

void CppInterface::onlineOfflineSwitchChanged(bool isOnline)
{
    qDebug() << "Online/Offline Switch state changed to:" << (isOnline ? "ON" : "OFF");
    this->bIsOnline = isOnline;
}