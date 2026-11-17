import QtQuick
import QtQuick.Layouts
import "../theme"
import "../components"

// Calendar and timer behind two tabs.
ColumnLayout {
	id: root
	spacing: 12

	property int tab: 0

	RowLayout {
		Layout.alignment: Qt.AlignHCenter
		spacing: 6
		PillButton { icon: Icons.calendar; text: "Calendar"; selected: root.tab === 0; onClicked: root.tab = 0 }
		PillButton { icon: Icons.timer; text: "Timer"; selected: root.tab === 1; onClicked: root.tab = 1 }
	}

	Loader {
		Layout.alignment: Qt.AlignHCenter
		sourceComponent: root.tab === 0 ? calendar : timer
	}

	Component { id: calendar; ClockPopup {} }
	Component { id: timer; TimerPane {} }
}
