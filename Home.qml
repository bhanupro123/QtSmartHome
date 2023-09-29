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
  }
  function getRandomColor() {
      var letters = '0123456789ABCDEF'
      var color = '#10'
      for (var i = 0; i < 6; i++) {
          color += letters[Math.floor(Math.random() * Math.random() * 16)]
      }
      return color
  }
    title: qsTr("Home")



}
