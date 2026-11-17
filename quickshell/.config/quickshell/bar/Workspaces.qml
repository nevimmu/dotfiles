import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "../theme"

ColumnLayout {
    spacing: -9

    Repeater {
        model: 5

        Text {
            id: ws
            required property int index
            readonly property int wsId: index + 1
            readonly property var hw: Hyprland.workspaces.values.find(w => w.id === wsId)
            readonly property bool active: Hyprland.focusedWorkspace?.id === wsId

            Layout.alignment: Qt.AlignHCenter
            // active: U+F111, occupied: U+F192, empty: U+F10C
            text: active ? "" : (hw ? "" : "")
            color: area.containsMouse ? Theme.iris : Theme.text
            font.family: Theme.font
            font.pixelSize: 28

            MouseArea {
                id: area
                anchors.fill: parent
                hoverEnabled: true
                onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + ws.wsId + " })")
            }
        }
    }
}
