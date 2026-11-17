import QtQuick
import QtQuick.Layouts
import "../theme"
import "../services"
import "../components"

ColumnLayout {
    id: root
    spacing: 12

    property bool stopwatch: false

    // Timer / Stopwatch switch
    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 6
        PillButton { text: "Timer"; selected: !root.stopwatch; onClicked: root.stopwatch = false }
        PillButton { text: "Stopwatch"; selected: root.stopwatch; onClicked: root.stopwatch = true }
    }

    // ---- countdown ----
    ColumnLayout {
        visible: !root.stopwatch
        Layout.fillWidth: true
        spacing: 12

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: Countdown.mode === "done" ? "Done!" : Countdown.fmt(Countdown.mode === "idle" ? Countdown.total : Countdown.remaining)
            color: Countdown.mode === "done" ? Theme.love : (Countdown.mode === "paused" ? Theme.gold : Theme.text)
            font.family: Theme.font
            font.pixelSize: 44
            font.bold: true
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 6
            radius: 3
            color: Theme.highlightMed
            Rectangle {
                width: parent.width * (Countdown.mode === "idle" ? 1 : Countdown.remaining / Countdown.total)
                height: parent.height
                radius: 3
                color: Countdown.mode === "done" ? Theme.love : Theme.iris
            }
        }

        // presets + fine adjustment (only while not running)
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 6
            visible: Countdown.mode === "idle" || Countdown.mode === "done"
            Repeater {
                model: [5, 10, 25, 45]
                PillButton {
                    required property int modelData
                    text: modelData + "m"
                    selected: Countdown.total === modelData * 60
                    onClicked: Countdown.setTotal(modelData * 60)
                }
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 6
            visible: Countdown.mode === "idle" || Countdown.mode === "done"
            PillButton { text: "-5m"; onClicked: Countdown.setTotal(Countdown.total - 300) }
            PillButton { text: "-1m"; onClicked: Countdown.setTotal(Countdown.total - 60) }
            PillButton { text: "+1m"; onClicked: Countdown.setTotal(Countdown.total + 60) }
            PillButton { text: "+5m"; onClicked: Countdown.setTotal(Countdown.total + 300) }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 8
            PillButton {
                primary: true
                icon: Countdown.mode === "running" ? Icons.pause : Icons.play
                text: Countdown.mode === "running" ? "Pause" : (Countdown.mode === "paused" ? "Resume" : "Start")
                onClicked: Countdown.mode === "running" ? Countdown.pause() : Countdown.start()
            }
            PillButton {
                visible: Countdown.mode !== "idle"
                icon: Icons.restart
                text: "Reset"
                onClicked: Countdown.reset()
            }
        }
    }

    // ---- stopwatch ----
    ColumnLayout {
        visible: root.stopwatch
        Layout.fillWidth: true
        spacing: 12

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: Countdown.swFmt(Countdown.swTotal)
            color: Countdown.swRunning ? Theme.text : Theme.gold
            font.family: Theme.font
            font.pixelSize: 40
            font.bold: true
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 8
            PillButton {
                primary: true
                icon: Countdown.swRunning ? Icons.pause : Icons.play
                text: Countdown.swRunning ? "Pause" : (Countdown.swTotal > 0 ? "Resume" : "Start")
                onClicked: Countdown.swToggle()
            }
            PillButton {
                visible: Countdown.swTotal > 0
                icon: Icons.restart
                text: "Reset"
                onClicked: Countdown.swReset()
            }
        }
    }

    Item { Layout.preferredWidth: 250 }
}
