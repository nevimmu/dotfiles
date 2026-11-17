import QtQuick
import QtQuick.Layouts
import "../theme"
import "../services"
import "../components"

ColumnLayout {
	spacing: 12

	Text {
		text: "System"
		color: Theme.iris
		font.family: Theme.font
		font.pixelSize: 16
		font.bold: true
	}

	StatBar {
		Layout.fillWidth: true
		icon: Icons.chip
		label: "CPU"
		valueText: Math.round(Stats.cpu * 100) + "%" + (Stats.cpuTemp > 0 ? "  " + Math.round(Stats.cpuTemp) + "°C" : "")
		fraction: Stats.cpu
		accent: Theme.iris
	}
	StatBar {
		Layout.fillWidth: true
		icon: Icons.memory
		label: "Memory"
		valueText: Stats.gib(Stats.memUsed) + " / " + Stats.gib(Stats.memTotal) + " GiB"
		fraction: Stats.mem
		accent: Theme.foam
	}
	StatBar {
		Layout.fillWidth: true
		visible: Stats.hasGpu
		icon: Icons.gpu
		label: "GPU"
		valueText: Math.round(Stats.gpuUtil * 100) + "%  " + Math.round(Stats.gpuTemp) + "°C"
		fraction: Stats.gpuUtil
		accent: Theme.pine
	}
	StatBar {
		Layout.fillWidth: true
		visible: Stats.hasGpu
		icon: Icons.memory
		label: "VRAM"
		valueText: Stats.gib(Stats.gpuMemUsed) + " / " + Stats.gib(Stats.gpuMemTotal) + " GiB"
		fraction: Stats.gpuMemUsed / Stats.gpuMemTotal
		accent: Theme.pine
	}
	StatBar {
		Layout.fillWidth: true
		icon: Icons.disk
		label: "Disk /"
		valueText: Stats.gib(Stats.diskUsed) + " / " + Stats.gib(Stats.diskTotal) + " GiB"
		fraction: Stats.disk
		accent: Theme.gold
	}
}
