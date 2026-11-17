pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire
import "../"

// Output devices: speakers, headset (wired USB DACs) and the Bluetooth earbuds, resolved from config.json.
Singleton {
    id: root

    readonly property var sinkNodes: Pipewire.nodes.values.filter(n => n.isSink && !n.isStream)
    // Volume/mute only exist on nodes that are tracked
    PwObjectTracker { objects: root.sinkNodes }

    readonly property var defaultSink: Pipewire.defaultAudioSink

    // A blank entry in config.json means "not configured": the matching button is hidden in the panel.
    readonly property bool speakerConfigured: Config.audio.speakerSink !== ""
    readonly property bool headsetConfigured: Config.audio.headsetSink !== ""
    readonly property bool earbudsConfigured: Config.audio.earbudsMac !== ""

    readonly property var speaker: speakerConfigured ? (sinkNodes.find(n => n.name === Config.audio.speakerSink) ?? null) : null
    readonly property var headset: headsetConfigured ? (sinkNodes.find(n => n.name === Config.audio.headsetSink) ?? null) : null
    readonly property var earbuds: {
        if (!earbudsConfigured) return null;
        const mac = Config.audio.earbudsMac.replace(/:/g, "_").toUpperCase();
        return sinkNodes.find(n => n.name.startsWith("bluez_output.") && n.name.toUpperCase().includes(mac)) ?? null;
    }
    readonly property var earbudsDevice: {
        if (!earbudsConfigured) return null;
        const devs = Bluetooth.defaultAdapter?.devices.values ?? [];
        return devs.find(d => d.address.toUpperCase() === Config.audio.earbudsMac.toUpperCase()) ?? null;
    }

    readonly property string kind: {
        if (!defaultSink) return "none";
        if (defaultSink === speaker) return "speaker";
        if (defaultSink === headset) return "headset";
        if (defaultSink === earbuds) return "earbuds";
        return "other";
    }
    readonly property real volume: defaultSink?.audio?.volume ?? 0
    readonly property bool muted: defaultSink?.audio?.muted ?? false

    function setDefault(node) {
        if (node)
            Pipewire.preferredDefaultAudioSink = node;
    }
    function setVolume(node, v) {
        if (node?.audio)
            node.audio.volume = Math.max(0, Math.min(1, v));
    }
    function toggleMute(node) {
        if (node?.audio)
            node.audio.muted = !node.audio.muted;
    }

    // Earbuds button: switch if they are connected, otherwise connect them and switch once the sink appears.
    property bool wantEarbuds: false
    function selectEarbuds() {
        if (earbuds) {
            setDefault(earbuds);
            return;
        }
        wantEarbuds = true;
        wantTimeout.restart();
        if (earbudsDevice && !earbudsDevice.connected)
            earbudsDevice.connect();
    }
    // Last wired output (speakers or headset) that was the default; the earbuds toggle returns to it.
    property var lastWired: null
    function trackWired() {
        if (defaultSink && (defaultSink === speaker || defaultSink === headset))
            lastWired = defaultSink;
    }
    onDefaultSinkChanged: trackWired()
    onSpeakerChanged: trackWired()
    onHeadsetChanged: trackWired()
    Component.onCompleted: trackWired()

    // Bar icon click:
    //  - earbuds connected: swap between the earbuds and the last speakers/headset output
    //  - otherwise: swap between speakers and headset
    function cycleOutput() {
        if (earbuds) {
            if (defaultSink === earbuds)
                setDefault(lastWired ?? speaker ?? headset);
            else
                setDefault(earbuds);
            return;
        }
        let target = defaultSink === speaker ? headset : speaker;
        if (!target)
            target = speaker ?? headset;
        setDefault(target);
    }

    onEarbudsChanged: {
        if (earbuds && wantEarbuds) {
            wantEarbuds = false;
            setDefault(earbuds);
        }
    }
    Timer {
        id: wantTimeout
        interval: 20000
        onTriggered: root.wantEarbuds = false
    }
}
