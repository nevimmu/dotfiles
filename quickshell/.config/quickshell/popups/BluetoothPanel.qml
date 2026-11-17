import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import "../theme"
import "../components"

ColumnLayout {
	id: root
	spacing: 8

	readonly property var adapter: Bluetooth.defaultAdapter
	readonly property var all: adapter?.devices.values ?? []
	readonly property var paired: all.filter(d => d.paired)
	// Discovered but not paired yet (only meaningful while scanning)
	readonly property var nearby: all.filter(d => !d.paired && d.name !== "" && d.name !== d.address)

	function deviceIcon(d) {
		switch (d.icon) {
		case "input-gaming": return Icons.gamepad;
		case "input-mouse": return Icons.mouse;
		case "input-keyboard": return Icons.keyboard;
		case "phone": return Icons.phone;
		case "audio-headphones":
		case "audio-headset": return Icons.headphones;
		case "audio-card": return Icons.speaker;
		default: return d.connected ? Icons.btConnected : Icons.bluetooth;
		}
	}
	function batteryText(d) {
		if (!d.batteryAvailable) return "";
		const b = d.battery <= 1 ? d.battery * 100 : d.battery;
		return " - " + Math.round(b) + "%";
	}

	RowLayout {
		Layout.fillWidth: true
		Text {
			Layout.fillWidth: true
			text: "Bluetooth"
			color: Theme.iris
			font.family: Theme.font
			font.pixelSize: 16
			font.bold: true
		}
		Toggle {
			visible: root.adapter !== null
			checked: root.adapter?.enabled ?? false
			onToggled: root.adapter.enabled = !root.adapter.enabled
		}
	}

	Text {
		visible: root.adapter === null
		text: "No Bluetooth adapter found"
		color: Theme.subtle
		font.family: Theme.font
		font.pixelSize: 13
	}
	Text {
		visible: root.adapter !== null && !root.adapter.enabled
		text: "Bluetooth is turned off"
		color: Theme.subtle
		font.family: Theme.font
		font.pixelSize: 13
	}

	ColumnLayout {
		visible: root.adapter?.enabled ?? false
		Layout.fillWidth: true
		spacing: 8

		Text {
			visible: root.paired.length === 0
			text: "No paired devices"
			color: Theme.subtle
			font.family: Theme.font
			font.pixelSize: 13
		}

		Repeater {
			model: root.paired

			RowButton {
				required property var modelData
				Layout.fillWidth: true
				icon: root.deviceIcon(modelData)
				text: modelData.name
				subtext: (modelData.connected ? "Connected" : "Paired") + root.batteryText(modelData)
				active: modelData.connected
				onClicked: modelData.connected ? modelData.disconnect() : modelData.connect()
			}
		}

		Text {
			visible: root.adapter?.discovering && root.nearby.length > 0
			text: "Nearby"
			color: Theme.gold
			font.family: Theme.font
			font.pixelSize: 12
			font.bold: true
		}
		Repeater {
			model: root.adapter?.discovering ? root.nearby : []

			RowButton {
				required property var modelData
				Layout.fillWidth: true
				icon: Icons.bluetooth
				text: modelData.name
				subtext: modelData.pairing ? "Pairing..." : "Click to pair"
				onClicked: modelData.pair()
			}
		}

		RowButton {
			Layout.fillWidth: true
			implicitHeight: 38
			icon: Icons.search
			text: root.adapter?.discovering ? "Stop scanning" : "Scan for devices"
			active: root.adapter?.discovering ?? false
			onClicked: {
				root.adapter.discovering = !root.adapter.discovering;
				if (root.adapter.discovering)
					scanTimeout.restart();
			}
		}
	}

	RowButton {
		Layout.fillWidth: true
		implicitHeight: 38
		icon: Icons.bluetooth
		text: "Open Blueman"
		onClicked: Quickshell.execDetached(["blueman-manager"])
	}

	// BlueZ scans until told to stop; don't leave it running
	Timer {
		id: scanTimeout
		interval: 30000
		onTriggered: if (root.adapter) root.adapter.discovering = false
	}
}
