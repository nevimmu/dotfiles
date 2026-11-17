pragma Singleton
import QtQuick
import Quickshell

// Which bar widget the expanded panel belongs to.
//  hovered: widget under the cursor (panel shows its hover content)
//  pinned:  widget that was clicked (panel shows its full content, stays until dismissed)
Singleton {
	id: root

	property var hovered: null
	property var pinned: null
	property bool panelHover: false

	readonly property var active: pinned ?? hovered

	function enter(widget) {
		closeTimer.stop();
		hovered = widget;
	}
	function leave() {
		closeTimer.restart();
	}

	onPanelHoverChanged: panelHover ? closeTimer.stop() : closeTimer.restart()

	Timer {
		id: closeTimer
		interval: 250
		onTriggered: if (!root.panelHover) root.hovered = null
	}
}
