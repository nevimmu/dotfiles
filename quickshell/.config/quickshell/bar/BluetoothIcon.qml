import QtQuick
import Quickshell.Bluetooth
import "../theme"

Text {
	readonly property var adapter: Bluetooth.defaultAdapter
	readonly property bool on: adapter?.enabled ?? false
	readonly property bool connected: (adapter?.devices.values ?? []).some(d => d.connected)

	text: !on ? Icons.btOff : (connected ? Icons.btConnected : Icons.bluetooth)
	color: !on ? Theme.muted : (connected ? Theme.foam : Theme.text)
	font.family: Theme.font
	font.pixelSize: 22
}
