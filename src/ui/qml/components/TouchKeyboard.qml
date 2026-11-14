import QtQuick
import QtQuick.Layouts

Item {
    id: kb
    visible: false
    z: 200
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom

    property bool shifted: false
    property bool numMode: false
    property var focusedItem: null   // last known writable text field

    // Walk up the parent chain to check if item is inside the keyboard
    function isInsideKb(item) {
        var p = item
        while (p !== null && p !== undefined) {
            if (p === kb) return true
            p = p.parent
        }
        return false
    }

    Connections {
        target: kb.Window.window
        enabled: kb.Window.window !== null
        function onActiveFocusItemChanged() {
            var item = kb.Window.window ? kb.Window.window.activeFocusItem : null
            // If focus moved to something inside the keyboard itself, ignore —
            // the text field will get focus back after typeChar.
            if (item !== null && kb.isInsideKb(item)) return
            var ok = item !== null
                  && typeof item.text !== "undefined"
                  && item.readOnly !== true
            if (ok) kb.focusedItem = item
            else    kb.focusedItem = null
            kb.visible = ok
        }
    }

    function typeChar(ch) {
        var item = kb.focusedItem
        if (!item || typeof item.text === "undefined") return
        if (ch === "BK") {
            var p = item.cursorPosition
            if (p > 0) {
                item.text = item.text.slice(0, p - 1) + item.text.slice(p)
                item.cursorPosition = p - 1
            }
        } else if (ch === "OK") {
            kb.visible = false
            kb.focusedItem = null
            return
        } else {
            var c = (kb.shifted && ch.length === 1 && ch >= "a" && ch <= "z")
                    ? ch.toUpperCase() : ch
            var pos = item.cursorPosition
            item.text = item.text.slice(0, pos) + c + item.text.slice(pos)
            item.cursorPosition = pos + c.length
            if (kb.shifted && ch.length === 1 && ch >= "a" && ch <= "z")
                kb.shifted = false
        }
        // Restore focus to the text field after every keystroke
        Qt.callLater(function() { if (kb.focusedItem) kb.focusedItem.forceActiveFocus() })
    }

    Rectangle {
        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
        height: col.implicitHeight + 12
        color: "#e0101820"; border.color: Theme.border; border.width: 1

        ColumnLayout {
            id: col
            anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: 4 }
            spacing: 3

            Item {
                Layout.fillWidth: true; height: 28
                Text {
                    anchors.right: parent.right; anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    text: "✕  CLOSE"; color: Theme.textMuted; font.pixelSize: 11
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: { kb.visible = false; kb.focusedItem = null }
                }
            }

            Repeater {
                model: kb.numMode ? kb.numRows : kb.alphaRows
                RowLayout {
                    required property var modelData
                    Layout.fillWidth: true; spacing: 3
                    Item { Layout.fillWidth: true }
                    Repeater {
                        model: modelData
                        KbKey {
                            required property string modelData
                            lbl: (kb.shifted && modelData.length === 1
                                  && modelData >= "a" && modelData <= "z")
                                 ? modelData.toUpperCase() : modelData
                            onActivated: kb.typeChar(modelData)
                        }
                    }
                    Item { Layout.fillWidth: true }
                }
            }

            RowLayout {
                Layout.fillWidth: true; spacing: 3
                Item { Layout.fillWidth: true }
                KbKey { lbl: kb.shifted ? "SH▲" : "SHF"; w: 52
                        onActivated: kb.shifted = !kb.shifted }
                KbKey { lbl: kb.numMode ? "ABC" : "123"; w: 52
                        onActivated: kb.numMode = !kb.numMode }
                KbKey { lbl: "SPACE"; w: 160; onActivated: kb.typeChar(" ") }
                KbKey { lbl: "BK"; w: 52; onActivated: kb.typeChar("BK") }
                KbKey { lbl: "OK"; w: 52; onActivated: kb.typeChar("OK") }
                Item { Layout.fillWidth: true }
            }
        }
    }

    property var alphaRows: [
        ["q","w","e","r","t","y","u","i","o","p"],
        ["a","s","d","f","g","h","j","k","l"],
        ["z","x","c","v","b","n","m"]
    ]
    property var numRows: [
        ["1","2","3","4","5","6","7","8","9","0"],
        ["-","/",":",";","(",")",".","@","\""],
        ["$","&","!","?","#","%","+","=","_"]
    ]
}
