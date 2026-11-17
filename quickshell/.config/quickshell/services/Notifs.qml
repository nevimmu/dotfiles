pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

// Notification daemon (replaces dunst).
//  - tracked notifications = history shown in the bar panel until dismissed
//  - toasts = recent ones shown as popups; Do Not Disturb hides them (critical ones still show)
Singleton {
	id: root

	property bool dnd: false
	property var toasts: []   // Notification objects currently shown as popups
	property var times: ({})  // id -> receive time (ms)
	property int tick: 0      // bumped every 30 s so relative times refresh

	readonly property var history: [...server.trackedNotifications.values].reverse()
	readonly property int count: server.trackedNotifications.values.length

	function removeToast(n) {
		toasts = toasts.filter(x => x !== n);
	}
	function dismissAll() {
		for (const n of [...server.trackedNotifications.values])
			n.dismiss();
		toasts = [];
	}
	function ago(id) {
		tick; // dependency
		const t = times[id];
		if (!t) return "";
		const m = Math.floor((Date.now() - t) / 60000);
		if (m < 1) return "now";
		if (m < 60) return m + "m";
		const h = Math.floor(m / 60);
		return h < 24 ? h + "h" : Math.floor(h / 24) + "d";
	}

	NotificationServer {
		id: server
		keepOnReload: false
		bodySupported: true
		bodyMarkupSupported: true
		actionsSupported: true
		imageSupported: true

		onNotification: n => {
			n.tracked = true;
			root.times = Object.assign({}, root.times, { [n.id]: Date.now() });
			n.closed.connect(() => root.removeToast(n));
			if (!root.dnd || n.urgency === NotificationUrgency.Critical)
				root.toasts = root.toasts.concat([n]).slice(-4);
		}
	}

	Timer {
		interval: 30000
		running: true
		repeat: true
		onTriggered: root.tick++
	}
}
