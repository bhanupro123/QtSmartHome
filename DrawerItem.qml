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

 Rectangle{
     anchors.fill: parent
     function getRandomColor() {
         var letters = '123456789ABCDEF'
         var color = ''
         for (var i = 0; i < 6; i++) {
             color += letters[Math.floor(Math.random() * Math.random() * 16)]
         }
         return color
     }
     property int font_size: Qt.application.font.pixelSize * 2
     property string randomColor: getRandomColor()
     Rectangle{
     id:background
     color: '#40'+randomColor
     RadialGradient {
         y: -parent.width / 6
         x: -parent.width / 6
         width: parent.width / 2
         height: parent.width / 2
         gradient: Gradient {
             GradientStop {
                 position: 0.0
                 color: '#80'+randomColor
             }
             GradientStop {
                 position: 0.5
                 color: "transparent"
             }
         }
     }
     RadialGradient {
         y: parent.height - (parent.height / 1.8)
         x: parent.width - (parent.width / 2)
         width: parent.width / 2
         height: parent.width / 2
         gradient: Gradient {
             GradientStop {
                 position: 0.0
                 color: '#80'+randomColor
             }
             GradientStop {
                 position: 0.5
                 color: "transparent"
             }
         }
     }

     }


 }
