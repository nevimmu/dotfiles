import QtQuick
import "../theme"

Rectangle {
    id: root

    property string text: ""
    property string icon: ""
    property bool primary: false
    property bool selected: false
    signal clicked

    implicitWidth: label.implicitWidth + 24
    implicitHeight: 32
    radius: 16
    color: primary ? (area.containsMouse ? Qt.lighter(Theme.iris, 1.1) : Theme.iris)
                   : (selected ? Theme.highlightMed : (area.containsMouse ? Theme.highlightMed : Theme.surface))
    Behavior on color { ColorAnimation { duration: 100 } }

    Text {
        id: label
        anchors.centerIn: parent
        text: (root.icon !== "" ? root.icon + " " : "") + root.text
        color: root.primary ? Theme.base : Theme.text
        font.family: Theme.font
        font.pixelSize: 14
        font.bold: root.primary || root.selected
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
