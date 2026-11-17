import QtQuick
import QtQuick.Layouts
import Quickshell
import "../theme"
import "../services"

ColumnLayout {
	spacing: -7

	SystemClock {
		id: clock
		precision: SystemClock.Seconds
	}

	// Running timer indicator (only takes space while a timer is active)
	Text {
		visible: Countdown.active
		Layout.alignment: Qt.AlignHCenter
		text: Countdown.mode === "done" ? Icons.bell : Countdown.fmt(Countdown.remaining)
		color: Countdown.mode === "done" ? Theme.love : (Countdown.mode === "paused" ? Theme.gold : Theme.foam)
		font.family: Theme.font
		font.pixelSize: 12
		font.bold: true
		leftPadding: 2
		rightPadding: 2
	}

	Repeater {
		model: ["HH", "mm", "ss"]

		Text {
			required property string modelData
			Layout.alignment: Qt.AlignHCenter
			text: Qt.formatTime(clock.date, modelData)
			color: Theme.iris
			font.family: Theme.font
			font.pixelSize: 25
			font.weight: Font.Black
			font.italic: true
			// Italic Black glyphs overhang their advance box; pad it and snap to whole pixels
			leftPadding: 3
			rightPadding: 3
			renderType: Text.NativeRendering
		}
	}
}
