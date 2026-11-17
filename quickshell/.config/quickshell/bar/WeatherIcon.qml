import QtQuick
import "../theme"
import "../services"

Column {
	spacing: -2

	Text {
		anchors.horizontalCenter: parent.horizontalCenter
		text: Weather.icon(Weather.code, Weather.isDay)
		color: Weather.ready ? Weather.color(Weather.code, Weather.isDay) : Theme.muted
		font.family: Theme.font
		font.pixelSize: 24
	}
	Text {
		anchors.horizontalCenter: parent.horizontalCenter
		text: Weather.ready ? Math.round(Weather.temp) + "°" : "--"
		color: Theme.text
		font.family: Theme.font
		font.pixelSize: 13
		font.bold: true
	}
}
