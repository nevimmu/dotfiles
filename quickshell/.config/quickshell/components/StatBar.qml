import QtQuick
import QtQuick.Layouts
import "../theme"

// One stat: icon, label, value text and a fill bar. Turns red when nearly full.
ColumnLayout {
	id: root

	property string icon: ""
	property string label: ""
	property string valueText: ""
	property real fraction: 0
	property color accent: Theme.iris

	spacing: 4
	implicitWidth: 260

	RowLayout {
		Layout.fillWidth: true
		spacing: 8
		Text {
			text: root.icon
			color: root.accent
			font.family: Theme.font
			font.pixelSize: 18
		}
		Text {
			Layout.fillWidth: true
			text: root.label
			color: Theme.text
			font.family: Theme.font
			font.pixelSize: 14
		}
		Text {
			text: root.valueText
			color: Theme.subtle
			font.family: Theme.font
			font.pixelSize: 13
		}
	}
	Rectangle {
		Layout.fillWidth: true
		implicitHeight: 6
		radius: 3
		color: Theme.highlightMed
		Rectangle {
			width: parent.width * Math.max(0, Math.min(1, root.fraction))
			height: parent.height
			radius: 3
			color: root.fraction > 0.85 ? Theme.love : root.accent
			Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
		}
	}
}
