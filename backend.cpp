#include "backend.h"
#include <wiringpi2/wiringPi.h>
Backend::Backend(QObject* parent) : QObject(parent)
{

}
void Backend::toggle()
{
 digitalWrite(0,switchValue?LOW:HIGH);
 switchValue=!switchValue;
 //digitalWrite(0,HIGH);
}
