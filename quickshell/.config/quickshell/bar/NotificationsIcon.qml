import QtQuick
import "../theme"
import "../services"

Column {
	spacing: -2

	Text {
		anchors.horizontalCenter: parent.horizontalCenter
		text: Notifs.dnd ? Icons.bellOff : (Notifs.count > 0 ? Icons.bellBadge : Icons.bell)
		color: Notifs.dnd ? Theme.gold : (Notifs.count > 0 ? Theme.rose : Theme.text)
		font.family: Theme.font
		font.pixelSize: 22
	}
	Text {
		visible: Notifs.count > 0
		anchors.horizontalCenter: parent.horizontalCenter
		text: Notifs.count > 99 ? "99+" : Notifs.count
		color: Theme.text
		font.family: Theme.font
		font.pixelSize: 12
		font.bold: true
	}
}
