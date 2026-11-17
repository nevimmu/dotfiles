pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// CPU / RAM / disk / temperature (+ NVIDIA GPU when nvidia-smi exists), sampled every 3 s.
Singleton {
    id: root

    property real cpu: 0          // 0..1
    property real cpuTemp: 0      // °C (0 = unknown)
    property real memUsed: 0      // bytes
    property real memTotal: 1
    property real diskUsed: 0     // bytes, "/"
    property real diskTotal: 1
    property bool hasGpu: false
    property real gpuUtil: 0      // 0..1
    property real gpuTemp: 0
    property real gpuMemUsed: 0   // bytes
    property real gpuMemTotal: 1

    readonly property real mem: memUsed / memTotal
    readonly property real disk: diskUsed / diskTotal

    property real _prevTotal: 0
    property real _prevIdle: 0

    function gib(bytes) { return (bytes / 1073741824).toFixed(1); }

    readonly property string script: `
echo "CPU $(head -1 /proc/stat)"
echo "MEM $(grep -E '^(MemTotal|MemAvailable)' /proc/meminfo | awk '{printf "%s ", $2}')"
echo "DISK $(df -B1 --output=size,used / | tail -1)"
for h in /sys/class/hwmon/hwmon*; do
  case "$(cat $h/name 2>/dev/null)" in k10temp|coretemp) echo "TEMP $(cat $h/temp1_input)"; break;; esac
done
command -v nvidia-smi >/dev/null && echo "GPU $(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null | tr -d ' ')"
`

    function parse(text) {
        for (const line of text.split("\n")) {
            const i = line.indexOf(" ");
            if (i < 0) continue;
            const key = line.substring(0, i);
            const v = line.substring(i + 1).trim();
            if (key === "CPU") {
                const f = v.split(/\s+/).slice(1).map(Number);
                const idle = f[3] + (f[4] || 0);
                const total = f.reduce((a, b) => a + b, 0);
                if (_prevTotal > 0 && total > _prevTotal)
                    cpu = 1 - (idle - _prevIdle) / (total - _prevTotal);
                _prevTotal = total;
                _prevIdle = idle;
            } else if (key === "MEM") {
                const f = v.split(/\s+/).map(Number);
                memTotal = f[0] * 1024;
                memUsed = (f[0] - f[1]) * 1024;
            } else if (key === "DISK") {
                const f = v.split(/\s+/).map(Number);
                diskTotal = f[0];
                diskUsed = f[1];
            } else if (key === "TEMP") {
                cpuTemp = Number(v) / 1000;
            } else if (key === "GPU") {
                const f = v.split(",").map(Number);
                if (f.length >= 4 && !f.some(isNaN)) {
                    hasGpu = true;
                    gpuUtil = f[0] / 100;
                    gpuTemp = f[1];
                    gpuMemUsed = f[2] * 1048576;
                    gpuMemTotal = f[3] * 1048576;
                }
            }
        }
    }

    Process {
        id: proc
        command: ["sh", "-c", root.script]
        stdout: StdioCollector {
            onStreamFinished: root.parse(text)
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: if (!proc.running) proc.running = true
    }
}
