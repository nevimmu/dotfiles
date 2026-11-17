import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Services.Notifications
import "../theme"
import "../services"

// Notification popups, top-right of the screen (same spot as dunst: 5px offset).
PanelWindow {
	id: root

	anchors {
		right: true
		top: true
	}
	margins {
		right: 5
		top: 5
	}
	implicitWidth: 360
	implicitHeight: Math.max(1, column.implicitHeight)
	visible: Notifs.toasts.length > 0
	color: "transparent"
	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Overlay
	WlrLayershell.namespace: "qs-toasts"
	mask: Region { item: column }

	ColumnLayout {
		id: column
		width: parent.width
		spacing: 8

		Repeater {
			model: Notifs.toasts

			Rectangle {
				id: toast
				required property var modelData
				readonly property bool critical: modelData.urgency === NotificationUrgency.Critical

				Layout.fillWidth: true
				implicitHeight: content.implicitHeight + 24
				radius: 14
				color: Qt.alpha(Theme.base, 0.96)
				border.width: 1
				border.color: critical ? Theme.love : Theme.highlightMed

				// slide in
				x: 24
				opacity: 0
				Component.onCompleted: { x = 0; opacity = 1; }
				Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
				Behavior on opacity { NumberAnimation { duration: 200 } }

				Timer {
					interval: toast.modelData.expireTimeout > 0 ? toast.modelData.expireTimeout * 1000 : 6000
					running: !toast.critical && !hover.hovered
					onTriggered: Notifs.removeToast(toast.modelData)
				}

				HoverHandler { id: hover }

				// click anywhere: hide the popup (it stays in the history)
				MouseArea {
					anchors.fill: parent
					onClicked: Notifs.removeToast(toast.modelData)
				}

				RowLayout {
					id: content
					anchors {
						left: parent.left
						right: parent.right
						top: parent.top
						margins: 12
					}
					spacing: 12

					IconImage {
						Layout.alignment: Qt.AlignTop
						implicitSize: 40
						visible: source !== ""
						source: toast.modelData.image !== "" ? toast.modelData.image
							  : (toast.modelData.appIcon !== "" ? Quickshell.iconPath(toast.modelData.appIcon, true) : "")
					}

					ColumnLayout {
						Layout.fillWidth: true
						spacing: 2

						Text {
							Layout.fillWidth: true
							text: toast.modelData.appName
							elide: Text.ElideRight
							color: Theme.subtle
							font.family: Theme.font
							font.pixelSize: 11
						}
						Text {
							Layout.fillWidth: true
							text: toast.modelData.summary
							wrapMode: Text.Wrap
							maximumLineCount: 2
							elide: Text.ElideRight
							color: Theme.text
							font.family: Theme.font
							font.pixelSize: 15
							font.bold: true
						}
						Text {
							visible: text !== ""
							Layout.fillWidth: true
							text: toast.modelData.body
							textFormat: Text.StyledText
							wrapMode: Text.Wrap
							maximumLineCount: 4
							elide: Text.ElideRight
							color: Theme.text
							font.family: Theme.font
							font.pixelSize: 13
						}

						Flow {
							visible: toast.modelData.actions.length > 0
							Layout.fillWidth: true
							Layout.topMargin: 6
							spacing: 6
							Repeater {
								model: toast.modelData.actions
								Rectangle {
									required property var modelData
									implicitWidth: actionText.implicitWidth + 20
									implicitHeight: 28
									radius: 14
									color: actionArea.containsMouse ? Theme.highlightMed : Theme.surface
									Text {
										id: actionText
										anchors.centerIn: parent
										text: parent.modelData.text
										color: Theme.text
										font.family: Theme.font
										font.pixelSize: 12
									}
									MouseArea {
										id: actionArea
										anchors.fill: parent
										hoverEnabled: true
										cursorShape: Qt.PointingHandCursor
										onClicked: {
											parent.modelData.invoke();
											Notifs.removeToast(toast.modelData);
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
