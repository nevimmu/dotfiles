import QtQuick
import QtQuick.Layouts
import Quickshell
import "../theme"

// Month calendar. Scroll or use the arrows to change month; click the title to jump back to today.
ColumnLayout {
    id: root
    spacing: 10

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    property int offset: 0 // months from the current one
    readonly property date today: clock.date
    readonly property date shown: new Date(today.getFullYear(), today.getMonth() + offset, 1)
    // Monday-first index (0..6) of the 1st of the month
    readonly property int lead: (shown.getDay() + 6) % 7
    readonly property int daysInMonth: new Date(shown.getFullYear(), shown.getMonth() + 1, 0).getDate()

    component Label: Text {
        color: Theme.text
        font.family: Theme.font
        font.pixelSize: 14
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    RowLayout {
        Layout.fillWidth: true

        Label {
            text: ""
            color: Theme.subtle
            MouseArea { anchors.fill: parent; anchors.margins: -6; onClicked: root.offset-- }
        }
        Label {
            Layout.fillWidth: true
            text: Qt.formatDate(root.shown, "MMMM yyyy")
            font.bold: true
            font.pixelSize: 16
            color: Theme.iris
            MouseArea { anchors.fill: parent; onClicked: root.offset = 0 }
        }
        Label {
            text: ""
            color: Theme.subtle
            MouseArea { anchors.fill: parent; anchors.margins: -6; onClicked: root.offset++ }
        }
    }

    GridLayout {
        columns: 7
        rowSpacing: 2
        columnSpacing: 2

        Repeater {
            model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
            Label {
                required property string modelData
                Layout.preferredWidth: 32
                text: modelData
                font.bold: true
                color: Theme.gold
            }
        }

        Repeater {
            model: 42
            Item {
                id: cell
                required property int index
                readonly property int day: index - root.lead + 1
                readonly property bool inMonth: day >= 1 && day <= root.daysInMonth
                readonly property bool isToday: inMonth && root.offset === 0 && day === root.today.getDate()

                Layout.preferredWidth: 32
                Layout.preferredHeight: 28

                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: Theme.love
                    visible: cell.isToday
                }
                Label {
                    anchors.fill: parent
                    visible: cell.inMonth
                    text: cell.day
                    font.bold: cell.isToday
                    color: cell.isToday ? Theme.base : Theme.text
                }
            }
        }
    }

    WheelHandler {
        onWheel: event => root.offset += event.angleDelta.y > 0 ? -1 : 1
    }
}
