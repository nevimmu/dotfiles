import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.DBusMenu
import Quickshell.Widgets
import "../theme"
import "../services"

// Icon grid of tray items. Right click (or a menu-only item) shows its menu in this same panel.
ColumnLayout {
	id: root
	spacing: 8

	property var menuItem: null // tray item whose menu is open (null = icon grid)
	property var stack: []      // entered submenu entries
	readonly property var currentMenu: stack.length ? stack[stack.length - 1] : (menuItem?.menu ?? null)
	property string hoverTitle: ""

	function closePanel() {
		PopupState.pinned = null;
		PopupState.hovered = null;
	}
	function reset() {
		menuItem = null;
		stack = [];
	}

	// Start from the grid whenever the panel closes
	Connections {
		target: PopupState
		function onActiveChanged() { if (PopupState.active === null) root.reset(); }
	}

	// ---- header ----
	RowLayout {
		Layout.fillWidth: true
		spacing: 8

		Text {
			visible: root.menuItem !== null
			text: Icons.chevronLeft
			color: Theme.subtle
			font.family: Theme.font
			font.pixelSize: 20
			MouseArea {
				anchors.fill: parent
				anchors.margins: -6
				cursorShape: Qt.PointingHandCursor
				onClicked: {
					if (root.stack.length)
						root.stack = root.stack.slice(0, -1);
					else
						root.menuItem = null;
				}
			}
		}
		Text {
			Layout.fillWidth: true
			text: root.menuItem ? (root.menuItem.title || root.menuItem.id) : "Tray"
			elide: Text.ElideRight
			color: Theme.iris
			font.family: Theme.font
			font.pixelSize: 16
			font.bold: true
		}
	}

	// ---- icon grid ----
	ColumnLayout {
		visible: root.menuItem === null
		Layout.fillWidth: true
		spacing: 8

		Text {
			visible: SystemTray.items.values.length === 0
			text: "No tray icons"
			color: Theme.subtle
			font.family: Theme.font
			font.pixelSize: 13
		}

		GridLayout {
			columns: 5
			rowSpacing: 4
			columnSpacing: 4

			Repeater {
				model: SystemTray.items

				Rectangle {
					id: cell
					required property var modelData

					Layout.preferredWidth: 46
					Layout.preferredHeight: 46
					radius: 10
					color: area.containsMouse ? Theme.highlightMed : Theme.surface

					IconImage {
						anchors.centerIn: parent
						implicitSize: 26
						source: cell.modelData.icon
					}

					MouseArea {
						id: area
						anchors.fill: parent
						hoverEnabled: true
						cursorShape: Qt.PointingHandCursor
						acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
						onEntered: root.hoverTitle = cell.modelData.tooltipTitle || cell.modelData.title || cell.modelData.id
						onExited: root.hoverTitle = ""
						onClicked: mouse => {
							const it = cell.modelData;
							if (mouse.button === Qt.RightButton || (mouse.button === Qt.LeftButton && it.onlyMenu)) {
								if (it.hasMenu)
									root.menuItem = it;
							} else if (mouse.button === Qt.MiddleButton) {
								it.secondaryActivate();
							} else {
								it.activate();
								root.closePanel();
							}
						}
						onWheel: wheel => cell.modelData.scroll(wheel.angleDelta.y, false)
					}
				}
			}
		}

		Text {
			Layout.fillWidth: true
			Layout.maximumWidth: 5 * 46 + 16
			text: root.hoverTitle !== "" ? root.hoverTitle : " "
			elide: Text.ElideRight
			color: Theme.subtle
			font.family: Theme.font
			font.pixelSize: 12
		}
	}

	// ---- menu ----
	QsMenuOpener {
		id: opener
		menu: root.currentMenu
	}

	ListView {
		id: list
		visible: root.menuItem !== null
		Layout.fillWidth: true
		Layout.preferredWidth: 240
		implicitHeight: Math.min(contentHeight, 340)
		clip: true
		spacing: 2
		model: opener.children

		delegate: Item {
			id: entry
			required property var modelData
			width: ListView.view.width
			height: modelData.isSeparator ? 9 : 34

			Rectangle {
				visible: entry.modelData.isSeparator
				anchors.verticalCenter: parent.verticalCenter
				width: parent.width
				height: 1
				color: Theme.highlightMed
			}

			Rectangle {
				visible: !entry.modelData.isSeparator
				anchors.fill: parent
				radius: 8
				color: rowArea.containsMouse && entry.modelData.enabled ? Theme.highlightMed : "transparent"
				opacity: entry.modelData.enabled ? 1 : 0.45

				RowLayout {
					anchors.fill: parent
					anchors.leftMargin: 8
					anchors.rightMargin: 8
					spacing: 8

					// check / radio mark
					Text {
						Layout.preferredWidth: 16
						text: entry.modelData.buttonType !== QsMenuButtonType.None && entry.modelData.checkState === Qt.Checked ? Icons.check : ""
						color: Theme.iris
						font.family: Theme.font
						font.pixelSize: 14
					}
					IconImage {
						visible: entry.modelData.icon !== ""
						implicitSize: 16
						source: entry.modelData.icon
					}
					Text {
						Layout.fillWidth: true
						text: entry.modelData.text
						elide: Text.ElideRight
						color: Theme.text
						font.family: Theme.font
						font.pixelSize: 14
					}
					Text {
						visible: entry.modelData.hasChildren
						text: Icons.chevronRight
						color: Theme.subtle
						font.family: Theme.font
						font.pixelSize: 16
					}
				}

				MouseArea {
					id: rowArea
					anchors.fill: parent
					hoverEnabled: true
					enabled: entry.modelData.enabled
					cursorShape: Qt.PointingHandCursor
					onClicked: {
						if (entry.modelData.hasChildren) {
							root.stack = root.stack.concat([entry.modelData]);
						} else {
							entry.modelData.triggered();
							root.closePanel();
						}
					}
				}
			}
		}
	}
}
