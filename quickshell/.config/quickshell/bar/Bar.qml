import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "../theme"
import "../popups"
import "../services"

// The bar and its expanding panel live in one window and are drawn as one shape.
PanelWindow {
	id: root

	readonly property int panelMax: 420
	readonly property real fillet: 14
	readonly property real padX: 22
	readonly property real padY: 14

	anchors {
		left: true
		top: true
		bottom: true
	}
	margins {
		left: Theme.margin
		top: Theme.margin
		bottom: Theme.margin
	}
	implicitWidth: Theme.barWidth + panelMax
	// Hyprland reserves (exclusiveZone + left margin), then adds gaps_out before tiled windows start.
	// Windows start at barWidth + margin + windowGap, i.e. Theme.windowGap px from the bar.
	exclusiveZone: Theme.barWidth + Theme.windowGap - Theme.hyprGapsOut
	color: "transparent"
	WlrLayershell.namespace: "qs-bar"

	// Only the bar and the visible panel receive input; the rest of the window is click-through.
	mask: Region {
		item: barBg
		Region { item: panelHit }
	}

	// ---- panel state ----
	property var shown: null // widget whose content is displayed (kept while closing)
	property real anchorY: 0
	readonly property bool open: PopupState.active !== null
	readonly property Component current: !shown ? null : (PopupState.pinned === shown || !shown.hoverContent ? shown.panelContent : shown.hoverContent)

	readonly property real targetW: loader.implicitWidth + 2 * padX
	readonly property real targetH: loader.implicitHeight + 2 * padY

	property real panelW: open ? targetW : 0
	Behavior on panelW {
		NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
	}
	property real panelH: targetH
	Behavior on panelH {
		enabled: root.panelW > 1
		NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
	}
	readonly property real wantedY: Math.max(fillet + 10, Math.min(height - panelH - fillet - 10, anchorY - panelH / 2))
	property real panelY: wantedY
	Behavior on panelY {
		enabled: root.panelW > 1
		NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
	}
	readonly property real fr: Math.min(fillet, panelW / 2)

	Connections {
		target: PopupState
		function onActiveChanged() {
			const a = PopupState.active;
			if (!a)
				return;
			root.shown = a;
			root.anchorY = root.contentItem.mapFromItem(a, 0, a.height / 2).y;
		}
	}

	HyprlandFocusGrab {
		windows: [root]
		active: PopupState.pinned !== null
		onCleared: PopupState.pinned = null
	}

	// ---- background: one flattened layer, opacity applied after compositing ----
	Item {
		anchors.fill: parent
		opacity: 0.93
		layer.enabled: true

		Rectangle {
			id: barBg
			width: Theme.barWidth
			height: parent.height
			radius: Theme.radius
			color: Theme.overlay
		}
		Rectangle {
			x: Theme.barWidth - 30
			y: root.panelY
			width: root.panelW + 30
			height: root.panelH
			radius: root.fillet
			color: Theme.overlay
			visible: root.panelW > 0.5
		}
		Fillet {
			x: Theme.barWidth - ov
			y: root.panelY - root.fr
			size: root.fr
			above: true
			color: Theme.overlay
		}
		Fillet {
			x: Theme.barWidth - ov
			y: root.panelY + root.panelH
			size: root.fr
			above: false
			color: Theme.overlay
		}
	}

	// Input region of the panel (including the fillets)
	Item {
		id: panelHit
		x: Theme.barWidth
		y: root.panelY - root.fr
		width: root.panelW
		height: root.panelH + 2 * root.fr
	}

	// ---- panel content ----
	Item {
		x: Theme.barWidth
		y: root.panelY
		width: root.panelW
		height: root.panelH
		clip: true
		opacity: Math.min(1, root.panelW / 80)

		HoverHandler {
			onHoveredChanged: PopupState.panelHover = hovered
		}

		Loader {
			id: loader
			x: root.padX
			y: root.padY
			sourceComponent: root.current
		}
	}

	// ---- bar content ----
	ColumnLayout {
		anchors {
			left: parent.left
			top: parent.top
			bottom: parent.bottom
			topMargin: 12
			bottomMargin: 12
		}
		width: Theme.barWidth
		spacing: 8

		Workspaces {
			Layout.alignment: Qt.AlignHCenter
		}

		// Empty gap: keeps the bottom group pinned to the bottom
		Item { Layout.fillHeight: true }

		// Drawer: notifications, weather, system, bluetooth, tray (hover the chevron)
		Drawer {
			Layout.alignment: Qt.AlignHCenter
		}

		BarWidget {
			Layout.alignment: Qt.AlignHCenter
			name: "audio"
			panelContent: AudioPanel {}
			onScrolled: delta => Audio.setVolume(Audio.defaultSink, Audio.volume + (delta > 0 ? 0.05 : -0.05))
			AudioIcon {}
		}

		BarWidget {
			Layout.alignment: Qt.AlignHCenter

			// No hoverContent: hovering shows the clock panel directly
			panelContent: ClockPanel {}

			Clock {}
		}
	}
}
