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
import QtWebSockets 1.0
import QtQml 2.3
import Backend 1.0
ApplicationWindow {
    id: window
    flags: Qt.FramelessWindowHint
    visible: true
    width: Screen.width
    height: Screen.height
    title: qsTr("Stack")
    Component.onCompleted: {

    }
    function getRandomColor(min = 0, max = colorcodes.length - 1) {
        min = Math.ceil(min)
        max = Math.floor(max)
        let a = Math.floor(Math.random() * (max - min) + min)
        let b = colorcodes[a]
        console.log(a, b)
        return b
    }
    //constants
    readonly property string underGroundEsp: "#E0*"
    readonly property string hallEsp: "#HESP*"
    readonly property string tankAlive: underGroundEsp + "T1"
    readonly property string motorTerminated: underGroundEsp + "M0"
    readonly property string kitchenAlive: underGroundEsp + "K1"
    readonly property string mainLightAlive: underGroundEsp + "L1"
    readonly property string mainLightTerminated: underGroundEsp + "L0"
    property var wsUnderGroundEsp: null //motor
    property var esp2: null //gallery
    property int font_size: Qt.application.font.pixelSize * 2
    property int font_size_small: Qt.application.font.pixelSize * 1.5
    property int font_size_medium: Qt.application.font.pixelSize * 2
    property int font_size_large: Qt.application.font.pixelSize * 3
    property string randomColor: getRandomColor()
    property string motorStatus: ""
    property string entryLampStatus: "L0"
    property int numberOfConnections: 0
    property bool isAlive: false
    property var sourceArray: ["qrc:/images/water-pump.png", "qrc:/images/lampgradiant.png", "qrc:/images/tapwater.png", "qrc:/images/tapwater.png", "qrc:/images/tapwater.png"]
    property var colorcodes: ["DB7E81", "D93C1C", "5D3AB7", "D26461", "542325", "321B8A", "286757", "3724A2", "9A35A7", "D74247", "2E1D77", "5E2599", "D5664A"]
    property var days: ["ఆదివారం", "సోమవారం", "మంగళవారం", "బుధవారం", "గురువారం", "శుక్రవారం", "శనివారం"]
    property var espArray: []
    property var clientArray: []
    property string noofclinetsprefix: "#N"

    property var dispatchCommandsToClients: (function (client,command) {
        if (command) {
            for (var i = 0; i < clientArray.length; i++) {
                try {
                    if (clientArray[i].id!==client&&clientArray[i].socket) {
                        console.log("dispatching......  cmd= ", command,
                                    "  -- client", clientArray[i].id)
                        clientArray[i].socket.sendTextMessage(command)
                    }
                } catch (e) {
                    clientArray[i].socket = ""
                }
            }
        }
    })
    property var onClientMessaged: (function (client,message) {
        if (message === kitchenAlive
                || message === motorTerminated
                || message === tankAlive) {
            motorStatus = message
        } else if (message === mainLightAlive
                   || message === mainLightTerminated) {
            entryLampStatus = message
        }
        dispatchCommandsToClients(client,message)
    })
    property var sendInitParmsToClient: (function (socket) {
        socket.sendTextMessage(motorStatus)
        socket.sendTextMessage(entryLampStatus)
    })


    property var onClientStatusChanged: (function (client,value) {
        for (let k = 0; k < clientArray.length; k++) {
            try {
                if (clientArray[k].id === client) {
                    clientArray[k].socket = value
                }
                if (clientArray[k].socket) {
                    clientArray[k].socket.sendTextMessage(
                                noofclinetsprefix + numberOfConnections + "#")
                    sendInitParmsToClient(clientArray[k].socket)
                }
            } catch (e) {

            }
        }
    })



    background: Rectangle {
        id: background
        color: '#70' + randomColor
        RadialGradient {
            y: -parent.width / 6
            x: -parent.width / 6
            width: parent.width / 2
            height: parent.width / 2
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: '#80' + randomColor
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
                    color: '#80' + randomColor
                }
                GradientStop {
                    position: 0.5
                    color: "transparent"
                }
            }
        }
    }
 Backend{
   id:backend
 }
    WebSocketServer {
        id: server
        accept: true
        listen: true
        host: "192.168.1.7"
        port: 8080
        onClientConnected: {
            let client = ""
            webSocket.onStatusChanged.connect(function (status) {
                console.log("Status changed", status)
                    if (status === WebSocket.Closed) {
                        numberOfConnections = numberOfConnections - 1
                        if (client.startsWith("!")) {
                            onClientStatusChanged(client,"")
                        } else if (client == underGroundEsp) {
                            wsUnderGroundEsp = ""
                        }
                    }
            })
            webSocket.onTextMessageReceived.connect(function (message) {
                console.log(message, client)
                message = message.replace("\n", "")
                if (client) {
                    if (message.startsWith(underGroundEsp)) {
                     onClientMessaged(client,message)
                    }
                } else if (message.startsWith("!") && message.endsWith("!")) {
                    client = message
                    clientArray.push({
                                         "id": message,
                                         "socket": webSocket
                                     })
                    onClientStatusChanged(client,webSocket)
                    numberOfConnections = numberOfConnections + 1
                } else if (message === underGroundEsp) {
                    client = message
                    wsUnderGroundEsp = webSocket
                }
            })
        }

        onErrorStringChanged: {
            console.log(errorString)
        }
    }

    Timer {
        id: reconnect
        interval: 3000
        running: false
        repeat: false
        onTriggered: {
            console.log("Reconnecting...........")
        }
    }
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            let date = new Date()
            timeText.text = days[date.getDay()] + Qt.formatDateTime(
                        date, " dd/MM/yyyy h:mm:ss")
        }
    }
    header: ToolBar {
        background: Rectangle {
            color: "#60" + randomColor
        }
        contentHeight: toolButton.implicitHeight + 20
        RowLayout {
            width: parent.width
            Layout.alignment: Qt.AlignVCenter
            ToolButton {
                id: toolButton
                text: (stackView.depth > 1 ? "\u25C0" : "\u2630")
                font.pixelSize: font_size
                onClicked: {

                }
            }

            Label {
                Layout.fillWidth: true
                id: timeText
                font.bold: Font.DemiBold
                font.pixelSize: font_size_small
                text: ""
            }

            ToolButton {
                text: noofclinetsprefix + numberOfConnections
                font.pixelSize: font_size
                onClicked: {
                    try {
                        if (wsUnderGroundEsp)
                            wsUnderGroundEsp.sendTextMessage("sending to esp1")
                    } catch (e) {
                        input.text = input.text + "ERROR"
                        console.log(e)
                    }
                }
            }

            ToolButton {
                text: "\u0950"
                font.pixelSize: font_size
                onClicked: {
                    Qt.quit()
                }
            }
            ToolButton {
                text: "\u0058"
                font.pixelSize: font_size
                onClicked: {

                }
            }
        }
    }

    Row {
        anchors.fill: parent
        spacing: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.centerIn: parent
        ScrollView {
            anchors.verticalCenter: parent.verticalCenter
            width: 200
            clip: true
            height: parent.height - 20
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
            ListView {
                model: 2
                spacing: 20
                delegate: Rectangle {
                    width: 200
                    id: rect
                    height: window.height / 5
                    anchors.margins: 10
                    radius: 5
                    color: "#30" + getRandomColor()
                    Image {
                        width: 2 * 40
                        height: 2 * 40
                        anchors.centerIn: parent
                        anchors.verticalCenter: parent.verticalCenter
                        fillMode: Image.PreserveAspectFit
                        sourceSize.width: 2 * 40
                        sourceSize.height: 2 * 40
                        source: sourceArray[index]
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                stackView.replace("Page" + (index + 1) + ".qml")
                                randomColor = getRandomColor()
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            clip: true
            width: (parent.width - 200) - 10
            height: parent.height - 20
            Layout.fillHeight: true
            Layout.fillWidth: true
            StackView {
                id: stackView
                onDepthChanged: {
                    console.log(stackView.depth, ":::::::::")
                    randomColor = getRandomColor()
                }
                initialItem: "Page1.qml"
                anchors.fill: parent
            }
        }
    }

    Drawer {
        id: drawer
        background: Rectangle {
            color: "transparent"
        }
        anchors.centerIn: parent
        width: window.width * 0.5
        FastBlur {
            width: parent.width
            height: width
            anchors.centerIn: parent
            source: background
            radius: 40
            Column {
                anchors.fill: parent
                ItemDelegate {
                    text: qsTr("Page 1")
                    width: parent.width
                    onClicked: {
                        stackView.push("Page1.qml")
                        drawer.close()
                    }
                }
                ItemDelegate {
                    text: qsTr("Page 2")
                    width: parent.width
                    onClicked: {
                        stackView.push("Page2.qml")
                        drawer.close()
                    }
                }
            }
        }
    }
}
