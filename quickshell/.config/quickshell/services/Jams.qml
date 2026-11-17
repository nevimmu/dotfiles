pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Controls for JAMS (auto-mute) through its CLI: `jams --status | --toggle | --pause-all`.
// JAMS has no change events, so state is polled every 2 s, but only while `watching` is true
// (the audio panel sets it while it is showing).
Singleton {
	id: root

	property bool watching: false
	property bool running: false      // false when JAMS isn't running (CLI exits 1, no JSON)
	property bool enabled: false
	property bool pausedByJams: false

	function refresh() {
		if (!status.running)
			status.running = true;
	}
	function toggle() {
		if (!running) return;
		enabled = !enabled; // optimistic; the next status read confirms it
		toggleProc.running = true;
	}
	function pauseAll() {
		if (!running) return;
		pauseProc.running = true;
	}

	Process {
		id: status
		command: ["jams", "--status"]
		stdout: StdioCollector {
			onStreamFinished: {
				try {
					const j = JSON.parse(text);
					root.enabled = j.enabled === true;
					root.pausedByJams = j.paused_by_jams === true;
					root.running = true;
				} catch (e) {
					root.running = false;
					root.pausedByJams = false;
				}
			}
		}
	}
	Process {
		id: toggleProc
		command: ["jams", "--toggle"]
		onExited: root.refresh()
	}
	Process {
		id: pauseProc
		command: ["jams", "--pause-all"]
		onExited: root.refresh()
	}

	Timer {
		interval: 2000
		running: root.watching
		repeat: true
		triggeredOnStart: true
		onTriggered: root.refresh()
	}
}
