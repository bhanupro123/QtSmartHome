#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>

class Backend:public QObject
{
    Q_OBJECT
public: explicit Backend(QObject *parent = nullptr);
    signals:
public slots:
    void toggle();
public:
    bool switchValue=false;
};

#endif // BACKEND_H
