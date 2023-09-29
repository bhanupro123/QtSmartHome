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



    Timer{
    id:delayTimer
    running: false
    interval: 10000
    repeat: false
    onTriggered: {
        if(socket.active)
        {
            motorStatus="K0"
            sendMessageViaSocket(motorStatus)
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
          Layout.fillHeight: true
          Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                fillMode: Image.PreserveAspectFit
                source:  motorStatus===tankAlive?"qrc:/images/emptywatertank.png":"qrc:/images/water-tank-white.png"

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                         if(wsUnderGroundEsp)
                        {
                             try{
                                 wsUnderGroundEsp.sendTextMessage(motorStatus===tankAlive?motorTerminated:tankAlive)
                             }
                             catch(e)
                             {

                             }
                       }

                    }
                }
            }

        }


        ColumnLayout{
            Layout.alignment: Qt.AlignHCenter
            spacing: 20
            Image {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                fillMode: Image.PreserveAspectFit
                source: motorStatus===kitchenAlive? "qrc:/images/tap-water256.png":"qrc:/images/tap-water-white.png"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        console.log("Clcked....",wsUnderGroundEsp)
                          if(wsUnderGroundEsp)
                            wsUnderGroundEsp.sendTextMessage(motorStatus===kitchenAlive?motorTerminated:kitchenAlive)
                    }
                    onPressAndHold: {
                        if(socket.active)
                        {
                            motorStatus=(motorStatus==="K1"?"K0":"K1")
                            sendMessageViaSocket(motorStatus)
                            delayTimer.interval=6000
                            if(motorStatus==="K1")
                            delayTimer.restart()
                        }
                    }


                }
            }

        }



}



}
