import QtQuick
import QtQuick.Layouts
import "../theme"
import "../popups"
import "../services"

// Waybar-style drawer: a chevron that, on hover, slides the icons below it open (growing downward).
// Stays open while the cursor is on it or one of its panels is showing.
ColumnLayout {
	id: root
	spacing: 0

	readonly property bool childActive: {
		const a = PopupState.active;
		return a !== null && (a === wNotifs || a === wWeather || a === wStats || a === wBluetooth || a === wTray);
	}
	readonly property bool expanded: hover.hovered || childActive || holdTimer.running

	// small grace period so moving between icon and panel doesn't collapse it
	Timer { id: holdTimer; interval: 350 }
	HoverHandler {
		id: hover
		onHoveredChanged: if (!hovered) holdTimer.restart()
	}

	Text {
		Layout.alignment: Qt.AlignHCenter
		text: Icons.chevronUp
		color: root.expanded ? Theme.iris : Theme.text
		rotation: 180 * body.reveal
		font.family: Theme.font
		font.pixelSize: 22
	}

	Item {
		id: body
		Layout.alignment: Qt.AlignHCenter
		Layout.preferredWidth: items.implicitWidth
		Layout.preferredHeight: items.implicitHeight * reveal
		clip: true
		visible: reveal > 0.01

		property real reveal: root.expanded ? 1 : 0
		Behavior on reveal {
			NumberAnimation { duration: 280; easing.type: Easing.OutCubic }
		}

		ColumnLayout {
			id: items
			anchors.top: parent.top // grows downward from the chevron
			anchors.horizontalCenter: parent.horizontalCenter
			spacing: 8

			BarWidget {
				id: wNotifs
				Layout.alignment: Qt.AlignHCenter
				Layout.topMargin: 6
				panelContent: NotificationsPanel {}
				NotificationsIcon {}
			}
			BarWidget {
				id: wWeather
				Layout.alignment: Qt.AlignHCenter
				panelContent: WeatherPanel {}
				WeatherIcon {}
			}
			BarWidget {
				id: wStats
				Layout.alignment: Qt.AlignHCenter
				panelContent: StatsPanel {}
				StatsIcon {}
			}
			BarWidget {
				id: wBluetooth
				Layout.alignment: Qt.AlignHCenter
				panelContent: BluetoothPanel {}
				BluetoothIcon {}
			}
			BarWidget {
				id: wTray
				Layout.alignment: Qt.AlignHCenter
				panelContent: TrayPanel {}
				TrayIcon {}
			}
		}
	}
}
