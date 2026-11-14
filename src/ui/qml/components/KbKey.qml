import QtQuick

Rectangle {
    property string lbl: ""
    property int w: 44
    signal activated()
    width: w; height: 42; radius: 5
    color: ma.pressed ? Theme.accent : Theme.surfaceAlt
    border.color: Theme.border; border.width: 1
    Text {
        anchors.centerIn: parent
        text: parent.lbl
        color: ma.pressed ? Theme.window : Theme.text
        font.pixelSize: parent.lbl.length > 3 ? 11 : 15
        font.bold: true
    }
    MouseArea {
        id: ma
        anchors.fill: parent
        onReleased: if (containsMouse) parent.activated()
    }
}
