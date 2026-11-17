import QtQuick
import QtQuick.Layouts
import "../theme"
import "../services"

ColumnLayout {
	id: root
	spacing: 12

	component Label: Text {
		color: Theme.text
		font.family: Theme.font
		font.pixelSize: 13
	}

	// ---- current ----
	RowLayout {
		Layout.fillWidth: true
		spacing: 14

		Text {
			text: Weather.icon(Weather.code, Weather.isDay)
			color: Weather.configured ? Weather.color(Weather.code, Weather.isDay) : Theme.muted
			font.family: Theme.font
			font.pixelSize: 48
		}
		ColumnLayout {
			Layout.fillWidth: true
			spacing: 0
			Label {
				text: Weather.configured ? Weather.city : "Weather"
				color: Theme.iris
				font.pixelSize: 16
				font.bold: true
			}
			Label {
				text: !Weather.configured ? "Set a city in config.json" : (Weather.ready ? Weather.describe(Weather.code) : (Weather.failed ? "Could not load weather" : "Loading..."))
				color: Theme.subtle
			}
		}
		Label {
			visible: Weather.ready
			text: Math.round(Weather.temp) + Weather.unit
			font.pixelSize: 30
			font.bold: true
		}
	}

	Label {
		visible: !Weather.ready
		text: Weather.failed ? "Check the city name and your connection; retrying every 15 minutes." : ""
		color: Theme.subtle
		font.pixelSize: 12
	}

	ColumnLayout {
		visible: Weather.ready
		Layout.fillWidth: true
		spacing: 12

		// feels like / humidity / wind
		RowLayout {
			Layout.fillWidth: true
			Repeater {
				model: [
					{ label: "Feels like", value: Math.round(Weather.feels) + Weather.unit },
					{ label: "Humidity", value: Math.round(Weather.humidity) + "%" },
					{ label: "Wind", value: Math.round(Weather.wind) + " " + Weather.windUnit }
				]
				Rectangle {
					required property var modelData
					Layout.fillWidth: true
					implicitHeight: 48
					radius: 10
					color: Theme.surface
					ColumnLayout {
						anchors.centerIn: parent
						spacing: 0
						Label {
							Layout.alignment: Qt.AlignHCenter
							text: modelData.value
							font.bold: true
						}
						Label {
							Layout.alignment: Qt.AlignHCenter
							text: modelData.label
							color: Theme.subtle
							font.pixelSize: 11
						}
					}
				}
			}
		}

		// next hours
		RowLayout {
			Layout.fillWidth: true
			spacing: 4
			Repeater {
				model: Weather.hourly
				ColumnLayout {
					required property var modelData
					Layout.fillWidth: true
					spacing: 2
					Label {
						Layout.alignment: Qt.AlignHCenter
						text: modelData.label
						color: Theme.subtle
						font.pixelSize: 12
					}
					Text {
						Layout.alignment: Qt.AlignHCenter
						text: Weather.icon(modelData.code, modelData.isDay)
						color: Weather.color(modelData.code, modelData.isDay)
						font.family: Theme.font
						font.pixelSize: 22
					}
					Label {
						Layout.alignment: Qt.AlignHCenter
						text: Math.round(modelData.temp) + "°"
					}
				}
			}
		}

		Rectangle {
			Layout.fillWidth: true
			implicitHeight: 1
			color: Theme.highlightMed
		}

		// next days
		Repeater {
			model: Weather.daily
			RowLayout {
				required property var modelData
				Layout.fillWidth: true
				spacing: 10
				Label {
					Layout.preferredWidth: 52
					text: modelData.label
					font.bold: modelData.label === "Today"
				}
				Text {
					text: Weather.icon(modelData.code, true)
					color: Weather.color(modelData.code, true)
					font.family: Theme.font
					font.pixelSize: 20
				}
				Label {
					Layout.fillWidth: true
					text: Weather.describe(modelData.code)
					color: Theme.subtle
					elide: Text.ElideRight
				}
				Label {
					text: Math.round(modelData.min) + "°"
					color: Theme.foam
				}
				Label {
					Layout.preferredWidth: 30
					horizontalAlignment: Text.AlignRight
					text: Math.round(modelData.max) + "°"
					color: Theme.rose
					font.bold: true
				}
			}
		}
	}

	// sets the panel's natural width
	Item { Layout.preferredWidth: 320 }
}
