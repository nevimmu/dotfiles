import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import "../theme"
import "../services"
import "../components"

ColumnLayout {
    id: root
    spacing: 10

    RowLayout {
        Layout.fillWidth: true
        spacing: 10
        Text {
            Layout.fillWidth: true
            text: "Notifications"
            color: Theme.iris
            font.family: Theme.font
            font.pixelSize: 16
            font.bold: true
        }
        PillButton {
            visible: Notifs.count > 0
            icon: Icons.clearAll
            text: "Clear"
            onClicked: Notifs.dismissAll()
        }
    }

    // Do Not Disturb
    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 44
        radius: 10
        color: Theme.surface
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 10
            Text {
                text: Notifs.dnd ? Icons.bellOff : Icons.bell
                color: Notifs.dnd ? Theme.gold : Theme.text
                font.family: Theme.font
                font.pixelSize: 20
            }
            Text {
                Layout.fillWidth: true
                text: "Do not disturb"
                color: Theme.text
                font.family: Theme.font
                font.pixelSize: 14
            }
            Toggle {
                checked: Notifs.dnd
                onToggled: Notifs.dnd = !Notifs.dnd
            }
        }
    }

    Text {
        visible: Notifs.count === 0
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: 6
        Layout.bottomMargin: 6
        text: "No notifications"
        color: Theme.subtle
        font.family: Theme.font
        font.pixelSize: 13
    }

    ListView {
        visible: Notifs.count > 0
        Layout.fillWidth: true
        implicitHeight: Math.min(contentHeight, 340)
        clip: true
        spacing: 6
        model: Notifs.history

        delegate: Rectangle {
            id: item
            required property var modelData
            width: ListView.view.width
            implicitHeight: body.implicitHeight + 20
            height: implicitHeight
            radius: 10
            color: Theme.surface
            border.width: modelData.urgency === NotificationUrgency.Critical ? 1 : 0
            border.color: Theme.love

            RowLayout {
                id: body
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    margins: 10
                }
                spacing: 10

                IconImage {
                    Layout.alignment: Qt.AlignTop
                    implicitSize: 32
                    visible: source !== ""
                    source: item.modelData.image !== "" ? item.modelData.image
                          : (item.modelData.appIcon !== "" ? Quickshell.iconPath(item.modelData.appIcon, true) : "")
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 1
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            Layout.fillWidth: true
                            text: item.modelData.appName
                            elide: Text.ElideRight
                            color: Theme.subtle
                            font.family: Theme.font
                            font.pixelSize: 11
                        }
                        Text {
                            text: Notifs.ago(item.modelData.id)
                            color: Theme.subtle
                            font.family: Theme.font
                            font.pixelSize: 11
                        }
                    }
                    Text {
                        Layout.fillWidth: true
                        text: item.modelData.summary
                        elide: Text.ElideRight
                        color: Theme.text
                        font.family: Theme.font
                        font.pixelSize: 14
                        font.bold: true
                    }
                    Text {
                        visible: text !== ""
                        Layout.fillWidth: true
                        text: item.modelData.body
                        textFormat: Text.StyledText
                        wrapMode: Text.Wrap
                        maximumLineCount: 3
                        elide: Text.ElideRight
                        color: Theme.text
                        font.family: Theme.font
                        font.pixelSize: 12
                    }
                }
                Text {
                    Layout.alignment: Qt.AlignTop
                    text: Icons.close
                    color: closeArea.containsMouse ? Theme.love : Theme.subtle
                    font.family: Theme.font
                    font.pixelSize: 16
                    MouseArea {
                        id: closeArea
                        anchors.fill: parent
                        anchors.margins: -4
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: item.modelData.dismiss()
                    }
                }
            }
        }
    }

    Item { Layout.preferredWidth: 330 }
}
