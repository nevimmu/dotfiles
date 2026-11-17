import QtQuick
import QtQuick.Layouts
import "../"
import "../theme"
import "../services"
import "../components"

ColumnLayout {
    id: root
    spacing: 10

    readonly property var sink: Audio.defaultSink

    function volIcon(v, muted) {
        if (muted || v <= 0) return Icons.volMute;
        return v < 0.34 ? Icons.volLow : (v < 0.67 ? Icons.volMed : Icons.volHigh);
    }

    RowLayout {
        Layout.fillWidth: true
        Text {
            Layout.fillWidth: true
            text: "Audio output"
            color: Theme.iris
            font.family: Theme.font
            font.pixelSize: 16
            font.bold: true
        }
        Text {
            text: Audio.defaultSink?.description ?? "No output"
            color: Theme.subtle
            font.family: Theme.font
            font.pixelSize: 11
            elide: Text.ElideRight
            Layout.maximumWidth: 130
        }
    }

    Repeater {
        // Only the outputs configured in config.json are listed
        model: [
            { key: "speaker", label: "Speakers", icon: Icons.speaker, configured: Audio.speakerConfigured },
            { key: "headset", label: "Headset", icon: Icons.headphones, configured: Audio.headsetConfigured },
            { key: "earbuds", label: "Earbuds", icon: Icons.earbuds, configured: Audio.earbudsConfigured }
        ].filter(o => o.configured)

        RowButton {
            required property var modelData
            readonly property var node: Audio[modelData.key]

            Layout.fillWidth: true
            icon: modelData.key === "earbuds" && !node ? Icons.earbudsOff : modelData.icon
            text: modelData.key === "earbuds" ? (Config.audio.earbudsName || Audio.earbudsDevice?.name || modelData.label) : modelData.label
            subtext: node ? "" : (modelData.key === "earbuds" ? (Audio.wantEarbuds ? "Connecting..." : "Not connected - click to connect") : "Unavailable")
            active: Audio.kind === modelData.key
            dimmed: !node && modelData.key !== "earbuds"
            onClicked: modelData.key === "earbuds" ? Audio.selectEarbuds() : Audio.setDefault(node)
        }
    }

    // Volume slider: only for the earbuds (speakers/headset are volume-controlled on the DACs)
    RowLayout {
        visible: Audio.kind === "earbuds"
        Layout.fillWidth: true
        Layout.topMargin: 4
        spacing: 10

        Text {
            text: root.volIcon(Audio.volume, Audio.muted)
            color: Audio.muted ? Theme.love : Theme.text
            font.family: Theme.font
            font.pixelSize: 20
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Audio.toggleMute(root.sink)
            }
        }
        Slider {
            Layout.fillWidth: true
            value: Audio.volume
            accent: Audio.muted ? Theme.muted : Theme.iris
            onMoved: v => Audio.setVolume(root.sink, v)
        }
        Text {
            text: Math.round(Audio.volume * 100) + "%"
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: 13
            Layout.preferredWidth: 38
            horizontalAlignment: Text.AlignRight
        }
    }

    // ---- JAMS (auto-mute) ----
    // Poll `jams --status` only while this panel is the one showing
    Binding {
        target: Jams
        property: "watching"
        value: PopupState.active?.name === "audio"
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.topMargin: 4
        implicitHeight: 1
        color: Theme.highlightMed
    }

    Text {
        text: "JAMS"
        color: Theme.iris
        font.family: Theme.font
        font.pixelSize: 16
        font.bold: true
    }

    // Auto-mute switch
    Rectangle {
        Layout.fillWidth: true
        implicitWidth: 260
        implicitHeight: 44
        radius: 10
        color: Theme.surface
        opacity: Jams.running ? 1 : 0.55

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 10

            Text {
                text: Jams.enabled ? Icons.music : Icons.musicOff
                color: Jams.running && Jams.enabled ? Theme.iris : Theme.subtle
                font.family: Theme.font
                font.pixelSize: 20
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0
                Text {
                    text: "Auto-mute"
                    color: Theme.text
                    font.family: Theme.font
                    font.pixelSize: 14
                }
                Text {
                    visible: text !== ""
                    text: !Jams.running ? "JAMS not running" : (Jams.pausedByJams ? "Paused by JAMS" : "")
                    color: Jams.running ? Theme.gold : Theme.subtle
                    font.family: Theme.font
                    font.pixelSize: 11
                }
            }
            Toggle {
                checked: Jams.running && Jams.enabled
                onToggled: Jams.toggle()
            }
        }
    }

    RowButton {
        Layout.fillWidth: true
        implicitHeight: 40
        icon: Icons.pause
        text: "Pause all players"
        dimmed: !Jams.running
        onClicked: Jams.pauseAll()
    }
}
