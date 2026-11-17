import QtQuick
import "../theme"
import "../services"

Text {
    text: {
        switch (Audio.kind) {
        case "speaker": return Icons.speaker;
        case "earbuds": return Icons.earbuds;
        case "none": return Icons.volMute;
        default: return Icons.headphones;
        }
    }
    color: Audio.muted ? Theme.love : Theme.pine
    font.family: Theme.font
    font.pixelSize: 22
}
