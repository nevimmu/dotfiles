import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Services.Notifications
import "../theme"
import "../services"

// Notification popups, top-right of the screen (same spot and look as the old dunst setup):
//  - frame + title coloured by urgency (low = pine, normal = iris, critical = love)
//  - left click: run the default action + hide; middle click: hide all; right click: dismiss
//  - a thin bar at the bottom counts down the timeout (pauses while hovered)
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
	readonly property int maxToastWidth: 360
	implicitWidth: Math.max(1, column.implicitWidth)
	implicitHeight: Math.max(1, column.implicitHeight)
	visible: Notifs.toasts.length > 0
	color: "transparent"
	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Overlay
	WlrLayershell.namespace: "qs-toasts"
	mask: Region { item: column }

	ColumnLayout {
		id: column
		anchors.right: parent.right
		spacing: 4

		Repeater {
			model: Notifs.toasts

			Rectangle {
				id: toast
				required property var modelData
				readonly property bool critical: modelData.urgency === NotificationUrgency.Critical
				readonly property color accent: critical ? Theme.love
					: (modelData.urgency === NotificationUrgency.Low ? Theme.pine : Theme.iris)
				readonly property string fallbackIcon: critical ? "dialog-error"
					: (modelData.urgency === NotificationUrgency.Low ? "dialog-information" : "dialog-warning")
				readonly property int timeout: modelData.expireTimeout > 0 ? modelData.expireTimeout * 1000 : 6000

				// fit the content, up to maxToastWidth
				Layout.alignment: Qt.AlignRight
				implicitWidth: Math.min(root.maxToastWidth, content.implicitWidth + 24)
				implicitHeight: content.implicitHeight + 24 + (critical ? 0 : 6)
				radius: 10
				color: Qt.alpha(Theme.overlay, 0.93) // same colour and opacity as the bar background
				border.width: 2
				border.color: accent

				// slide in
				// (a transform, not x, so the layout's right alignment stays intact)
				transform: Translate {
					id: slide
					x: 24
					Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
				}
				opacity: 0
				Component.onCompleted: { slide.x = 0; opacity = 1; }
				Behavior on opacity { NumberAnimation { duration: 200 } }

				HoverHandler { id: hover }

				// click anywhere: left = default action + hide (stays in history),
				// middle = hide all popups, right = dismiss completely
				MouseArea {
					anchors.fill: parent
					acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
					onClicked: mouse => {
						if (mouse.button === Qt.MiddleButton) {
							Notifs.toasts = [];
						} else if (mouse.button === Qt.RightButton) {
							toast.modelData.dismiss();
						} else {
							if (toast.modelData.appName === "Timer")
								Countdown.stopAlarm();
							for (const a of toast.modelData.actions) {
								if (a.identifier === "default") {
									a.invoke();
									break;
								}
							}
							Notifs.removeToast(toast.modelData);
						}
					}
				}

				// 1 -> 0 over the timeout; hides the toast when it runs out
				property real progress: 1
				NumberAnimation {
					target: toast
					property: "progress"
					from: 1
					to: 0
					duration: toast.timeout
					running: !toast.critical
					paused: hover.hovered
					onFinished: Notifs.removeToast(toast.modelData)
				}

				// timeout progress bar (critical ones stay until clicked)
				Rectangle {
					visible: !toast.critical
					anchors {
						left: parent.left
						bottom: parent.bottom
						leftMargin: toast.radius
						bottomMargin: 5
					}
					height: 2
					radius: 1
					color: Qt.alpha(toast.accent, 0.6)
					width: (toast.width - 2 * toast.radius) * toast.progress
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
							  : (toast.modelData.appIcon !== "" ? Quickshell.iconPath(toast.modelData.appIcon, toast.fallbackIcon) : Quickshell.iconPath(toast.fallbackIcon, true))
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
							color: toast.accent
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
							visible: toast.modelData.actions.some(a => a.identifier !== "default")
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
									visible: modelData.identifier !== "default"
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
