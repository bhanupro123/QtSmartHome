import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.5
import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.0
import QtQuick.VirtualKeyboard 2.1
import QtQuick.Controls 2.2
Page {
    background: Rectangle{
        color: "#00000000"
            anchors.fill: parent

             Rectangle{
                anchors.fill: parent
            color: '#60'+randomColor
            RadialGradient {
                y: -parent.width / 6
                x: parent.width - (parent.width / 2)
                width: parent.width / 2
                height: parent.width / 2
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: '#70'+randomColor
                    }
                    GradientStop {
                        position: 0.5
                        color: "transparent"
                    }
                }
            }
            RadialGradient {
                y: parent.height - (parent.height / 1.8)
                x: -parent.width / 6
                width: parent.width / 2
                height: parent.width / 2
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: '#70'+randomColor
                    }
                    GradientStop {
                        position: 0.5
                        color: "transparent"
                    }
                }
            }

            }


        }

RowLayout{
anchors.centerIn: parent
        spacing: 20
        ColumnLayout{
            Layout.alignment: Qt.AlignHCenter
            spacing: 20
            Image {
                width: 2*parent.width*0.4
                height: 2*parent.width*0.4
                Layout.alignment: Qt.AlignHCenter
                fillMode: Image.PreserveAspectFit
                source:  entryLampStatus===mainLightAlive?"qrc:/images/garland.png":"qrc:/images/garlandwhite.png"

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        backend.toggle()
                        if(wsUnderGroundEsp)
                          wsUnderGroundEsp.sendTextMessage(entryLampStatus===mainLightAlive?mainLightTerminated:mainLightAlive)
                    }
                }
            }

        }



}



}
