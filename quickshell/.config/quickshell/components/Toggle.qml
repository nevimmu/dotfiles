import QtQuick
import "../theme"

// Pill switch. Emits toggled(); the owner flips the underlying state.
Rectangle {
    id: root

    property bool checked: false
    signal toggled

    implicitWidth: 40
    implicitHeight: 22
    radius: 11
    color: checked ? Theme.iris : Theme.highlightMed
    Behavior on color { ColorAnimation { duration: 120 } }

    Rectangle {
        y: 3
        x: root.checked ? root.width - width - 3 : 3
        width: 16
        height: 16
        radius: 8
        color: root.checked ? Theme.base : Theme.text
        Behavior on x { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggled()
    }
}
