import QtQuick
import QtQuick.Layouts
import "../theme"

// Clickable list row: icon, label, optional sub-label, check mark when active.
Rectangle {
	id: root

	property string icon: ""
	property string text: ""
	property string subtext: ""
	property bool active: false
	property bool dimmed: false
	signal clicked

	implicitWidth: 260
	implicitHeight: 44
	radius: 10
	color: area.containsMouse ? Theme.highlightMed : (active ? Theme.overlay : Theme.surface)
	border.width: active ? 1 : 0
	border.color: Theme.iris
	opacity: dimmed ? 0.55 : 1
	Behavior on color { ColorAnimation { duration: 100 } }

	RowLayout {
		anchors.fill: parent
		anchors.leftMargin: 12
		anchors.rightMargin: 12
		spacing: 10

		Text {
			text: root.icon
			color: root.active ? Theme.iris : Theme.text
			font.family: Theme.font
			font.pixelSize: 20
		}
		ColumnLayout {
			Layout.fillWidth: true
			spacing: 0
			Text {
				Layout.fillWidth: true
				text: root.text
				elide: Text.ElideRight
				color: Theme.text
				font.family: Theme.font
				font.pixelSize: 14
				font.bold: root.active
			}
			Text {
				visible: root.subtext !== ""
				Layout.fillWidth: true
				text: root.subtext
				elide: Text.ElideRight
				color: Theme.subtle
				font.family: Theme.font
				font.pixelSize: 11
			}
		}
		Text {
			visible: root.active
			text: Icons.check
			color: Theme.iris
			font.family: Theme.font
			font.pixelSize: 16
		}
	}

	MouseArea {
		id: area
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: root.clicked()
	}
}
