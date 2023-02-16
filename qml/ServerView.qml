import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import ServerListDemo

ApplicationWindow {
    id: window
    width: 360
    minimumWidth: 200
    height: 667
    visible: true
    flags: Qt.Window | Qt.FramelessWindowHint
    color: "#00000000"

    Shortcut {
        sequence: "Esc"
        onActivated: window.close()
    }

//    property string fontFamily: 'Consolas'
    property string fontFamily: 'Verdana'
    property int resizeAreaSize: 5

    background: Rectangle{
        anchors.fill:parent
        anchors.rightMargin: -radius
        radius: 10
        opacity:1
        layer.enabled: true
    }

    header: ToolBar{
        anchors.left: parent.left
        height: 55
        width:parent.width
        horizontalPadding: 0

        background: Rectangle{
            anchors.fill:parent
            anchors.rightMargin: -radius
            radius: 10
            opacity:1
            layer.enabled: true

            Rectangle {
                y: parent.height - height
                width: parent.width
                height: 2
                color: "#E0E2E5"
            }
        }

        Label {
            id: title
            anchors.fill: parent
            text: "Добавить сервер"
            font.pixelSize: 20
            font.family: fontFamily
            leftPadding: 20
            rightPadding: 50

            elide: Label.ElideRight
            horizontalAlignment: Qt.AlignLeft
            verticalAlignment: Qt.AlignVCenter

            MouseArea {
                anchors.fill: parent
                height: resizeAreaSize
                hoverEnabled: true

                onPositionChanged: (mouse) =>{
                    cursorShape = cursorFromPos(mouse)
                }
                property int resizeAreaLength: 5

                onPressed: (mouse) =>{
                    switch (cursorFromPos(mouse)) {
                    case Qt.SizeHorCursor:
                        window.startSystemResize(mouse.x < resizeAreaLength?
                                                     Qt.LeftEdge : Qt.RightEdge);
                        break;
                    case Qt.SizeBDiagCursor:
                        window.startSystemResize(Qt.RightEdge | Qt.TopEdge);
                        break;
                    case Qt.SizeVerCursor:
                        window.startSystemResize(Qt.TopEdge);
                        break;
                    case Qt.SizeFDiagCursor:
                       window.startSystemResize(Qt.LeftEdge | Qt.TopEdge);
                       break;
                    case Qt.ArrowCursor:
                    default:
                        window.startSystemMove();
                    }
                }

                function cursorFromPos(mouse){
                    if(mouse.x < resizeAreaLength){
                        return (mouse.y > resizeAreaLength)?
                                    Qt.SizeHorCursor : Qt.SizeFDiagCursor
                    }
                    else if(mouse.x > width - resizeAreaLength)
                        return (mouse.y > resizeAreaLength)?
                                    Qt.SizeHorCursor : Qt.SizeBDiagCursor
                    else
                        return (mouse.y < resizeAreaLength)?
                                    Qt.SizeVerCursor : Qt.ArrowCursor
                }
            }
        }

        ToolButton {
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: title.verticalCenter
            background: Rectangle{}
            contentItem: Image {
                source: "images/addIcon64.png"
                sourceSize: Qt.size(24, 24)
            }
            hoverEnabled: false
            onClicked: serverModel.addServer()
        }
    }

    ServerListModel{
        id: serverModel
    }

    Component {
        id: servDelegate
        Item {
            id: delegateItem
            property var selected: ListView.isCurrentItem
            width: ListView.view.width-20
            height: 70

            GridLayout {
                columns: 3
                columnSpacing: 0
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.topMargin: 6
                anchors.rightMargin: 10

                Rectangle {
                    width: 14
                    height: 14
                    color: "#34c6a1"
                    radius: width*0.5

                    Layout.row: 0
                    Layout.column: 0
                    Layout.alignment:  Qt.AlignVCenter
                    Layout.leftMargin: 2
                }

                Text {
                    text: serverModel.get(index).name
                    elide: Label.ElideRight
                    font.family: fontFamily
                    font.pixelSize: 18

                    Layout.row: 0
                    Layout.column: 1
                    Layout.fillWidth: true
                    Layout.alignment:  Qt.AlignVCenter
                    Layout.leftMargin: 8
                }

                Text {
                    text: serverModel.get(index).address
                    elide: Label.ElideRight
                    font.family: fontFamily
                    font.pixelSize: 16
                    color: "#646A79"

                    Layout.row: 1
                    Layout.column: 1
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment:  Qt.AlignVCenter
                    Layout.leftMargin: 7
                    Layout.minimumWidth: 30
                }

                Rectangle {
                    width: Layout.maximumWidth
                    implicitHeight: authorName.implicitHeight+6
                    color: selected? "white" : "#E0EBFF"
                    radius: 6

                    Layout.row: 0
                    Layout.column: 2
                    Layout.topMargin: 4
                    Layout.fillWidth: true
                    Layout.maximumWidth: authorName.implicitWidth+authorIcon.implicitWidth+16
                    Layout.minimumWidth: 30

                    Image {
                        id: authorIcon
                        source: "images/personIcon64.png"
                        sourceSize: Qt.size(14, 14)

                        anchors.left: parent.left
                        anchors.leftMargin: 7
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Label{
                        id: authorName;
                        text: serverModel.get(index).author
                        elide: Label.ElideRight
                        font.pixelSize: 14
                        font.family: fontFamily;
                        color: "#337cff";

                        anchors.left: authorIcon.right
                        anchors.leftMargin: 4
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: serverView.currentIndex = index
            }
        }
    }

    Component {
        id: headerComponent
        Label{
            anchors.left: parent.left
            anchors.right: parent.right

            height: 46
            text: "Обнаруженные"
            font.pixelSize: 18
            font.family: fontFamily
            color: "#646A79"
            elide: Label.ElideRight
            horizontalAlignment: Qt.AlignLeft
            verticalAlignment: Qt.AlignVCenter
        }
    }

    ListView {
        id: serverView
        anchors.fill: parent
        anchors.leftMargin: 20
        model: serverModel
        delegate: servDelegate
        spacing: 9

        header: headerComponent

        highlight: Rectangle {
            color: "#E0EBFF"
            radius: 10
        }
    }

    MouseArea {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        width: resizeAreaSize
        hoverEnabled: true
        cursorShape: containsMouse ? Qt.SizeHorCursor : Qt.ArrowCursor

        onPressed: {
            window.startSystemResize(Qt.RightEdge);
        }
    }

    MouseArea {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        width: resizeAreaSize
        hoverEnabled: true
        cursorShape: containsMouse ? Qt.SizeHorCursor : Qt.ArrowCursor

        onPressed: {
            window.startSystemResize(Qt.LeftEdge);
        }
    }

    MouseArea {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        height: resizeAreaSize
        hoverEnabled: true

        property int eagle: Qt.BottomEdge
        onPressed: {
            window.startSystemResize(eagle);
        }
        onPositionChanged: (mouse) =>{
            var cursor = Qt.ArrowCursor
            eagle = Qt.BottomEdge
            if(containsMouse){
                if(mouse.x < resizeAreaSize) {
                   cursor = Qt.SizeBDiagCursor
                   eagle = eagle | Qt.LeftEdge
                }
                else if(mouse.x > width - resizeAreaSize){
                    cursor = Qt.SizeFDiagCursor
                    eagle = eagle | Qt.RightEdge
                }
                else cursor = Qt.SizeVerCursor
            }
            cursorShape = cursor
        }
    }
}
