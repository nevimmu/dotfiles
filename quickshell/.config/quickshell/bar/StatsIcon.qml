import QtQuick
import "../theme"
import "../services"

Column {
    spacing: -2

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: Icons.chip
        color: Stats.cpu > 0.85 ? Theme.love : Theme.foam
        font.family: Theme.font
        font.pixelSize: 22
    }
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: Math.round(Stats.cpu * 100) + "%"
        color: Theme.text
        font.family: Theme.font
        font.pixelSize: 12
        font.bold: true
    }
}
