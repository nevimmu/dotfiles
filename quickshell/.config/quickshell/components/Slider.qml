import QtQuick
import "../theme"

// Horizontal slider, value 0..1. Emits moved() while the user drags or scrolls.
Item {
    id: root

    property real value: 0
    property color accent: Theme.iris
    property real wheelStep: 0.05
    signal moved(real value)

    implicitWidth: 220
    implicitHeight: 22

    readonly property real clamped: Math.max(0, Math.min(1, value))

    Rectangle {
        id: track
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 6
        radius: 3
        color: Theme.highlightMed

        Rectangle {
            width: parent.width * root.clamped
            height: parent.height
            radius: 3
            color: root.accent
        }
    }

    Rectangle {
        x: (root.width - width) * root.clamped
        anchors.verticalCenter: parent.verticalCenter
        width: 14
        height: 14
        radius: 7
        color: Theme.text
        scale: area.pressed ? 1.2 : 1
        Behavior on scale { NumberAnimation { duration: 80 } }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        function update(mx) { root.moved(Math.max(0, Math.min(1, mx / width))); }
        onPressed: mouse => update(mouse.x)
        onPositionChanged: mouse => { if (pressed) update(mouse.x); }
        onWheel: wheel => root.moved(Math.max(0, Math.min(1, root.clamped + (wheel.angleDelta.y > 0 ? 1 : -1) * root.wheelStep)))
    }
}
