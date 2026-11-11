pragma Singleton
import QtQuick

// LNH OPSIQ EYE palette — orange and black.
QtObject {
    readonly property color window:         "#0d0d0d"
    readonly property color surface:        "#161616"
    readonly property color surfaceAlt:     "#1e1e1e"
    readonly property color border:         "#2a1500"
    readonly property color accent:         "#ff8000"
    readonly property color accentDim:      "#c45f00"
    readonly property color text:           "#f0f0f0"
    readonly property color textMuted:      "#888888"
    readonly property color paneBackground: "#000000"
    readonly property color danger:         "#e5484d"
    readonly property color online:         "#46a758"

    readonly property int radius:        6
    readonly property int spacing:       8
    readonly property int dragThreshold: 8
    readonly property int sidebarWidth:  240
    readonly property int navHeight:     48
}
