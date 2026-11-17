pragma Singleton
import QtQuick
import Quickshell

Singleton {
    // Rose Pine Moon
    readonly property color base: "#232136"
    readonly property color surface: "#2a273f"
    readonly property color overlay: "#393552"
    readonly property color muted: "#6e6a86"
    readonly property color subtle: "#908caa"
    readonly property color text: "#e0def4"
    readonly property color love: "#eb6f92"
    readonly property color gold: "#f6c177"
    readonly property color rose: "#ea9a97"
    readonly property color pine: "#3e8fb0"
    readonly property color foam: "#9ccfd8"
    readonly property color iris: "#c4a7e7"
    readonly property color highlightMed: "#56526e"

    readonly property string font: "CartographCF Nerd Font"
    readonly property int fontSize: 16
    readonly property int radius: 10
    readonly property int barWidth: 50
    readonly property int margin: 10
    // Gap between the bar and tiled windows (matches gaps_in in hyprland.lua)
    readonly property int windowGap: 4
    // gaps_out from hyprland.lua: Hyprland adds it between the reserved area and windows
    readonly property int hyprGapsOut: 10
}
