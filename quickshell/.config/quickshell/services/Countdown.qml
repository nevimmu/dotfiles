pragma Singleton
import QtQuick
import Quickshell

// Countdown timer + stopwatch. Both keep running while the panel is closed.
Singleton {
    id: root

    // ---- countdown ----
    property string mode: "idle" // idle | running | paused | done
    property int total: 300      // seconds
    property real remaining: 300 // seconds
    property double endAt: 0
    readonly property bool active: mode !== "idle"

    function setTotal(sec) {
        if (mode !== "idle" && mode !== "done")
            return;
        total = Math.max(60, Math.min(99 * 3600, sec));
        remaining = total;
        mode = "idle";
    }
    function start() {
        if (mode === "idle" || mode === "done")
            remaining = total;
        endAt = Date.now() + remaining * 1000;
        mode = "running";
    }
    function pause() {
        if (mode !== "running")
            return;
        remaining = Math.max(0, (endAt - Date.now()) / 1000);
        mode = "paused";
    }
    function reset() {
        mode = "idle";
        remaining = total;
    }

    function fmt(sec) {
        const s = Math.ceil(sec);
        const h = Math.floor(s / 3600);
        const m = Math.floor((s % 3600) / 60);
        const r = s % 60;
        const p = n => (n < 10 ? "0" : "") + n;
        return (h > 0 ? h + ":" + p(m) : p(m)) + ":" + p(r);
    }

    Timer {
        interval: 200
        repeat: true
        running: root.mode === "running"
        onTriggered: {
            root.remaining = Math.max(0, (root.endAt - Date.now()) / 1000);
            if (root.remaining <= 0) {
                root.mode = "done";
                Quickshell.execDetached(["notify-send", "-a", "Timer", "-u", "critical", "Timer finished", root.fmt(root.total) + " elapsed"]);
                Quickshell.execDetached(["sh", "-c", "paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga 2>/dev/null"]);
            }
        }
    }

    // ---- stopwatch ----
    property bool swRunning: false
    property double swElapsed: 0 // ms
    property double _swStart: 0
    function swToggle() {
        if (swRunning) {
            swElapsed += Date.now() - _swStart;
            swRunning = false;
        } else {
            _swStart = Date.now();
            swRunning = true;
        }
    }
    function swReset() {
        swRunning = false;
        swElapsed = 0;
    }
    property double swNow: 0
    readonly property double swTotal: swElapsed + (swRunning ? swNow - _swStart : 0)
    Timer {
        interval: 50
        repeat: true
        running: root.swRunning
        onTriggered: root.swNow = Date.now()
    }
    function swFmt(ms) {
        const t = Math.floor(ms / 10);
        const cs = t % 100;
        const s = Math.floor(t / 100) % 60;
        const m = Math.floor(t / 6000);
        const p = n => (n < 10 ? "0" : "") + n;
        return p(m) + ":" + p(s) + "." + p(cs);
    }
}
