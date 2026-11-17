import QtQuick
import Quickshell
import "bar"

ShellRoot {
	Variants {
		model: Quickshell.screens.filter(s => s.name === "DP-1")

		Scope {
			required property var modelData

			Bar { screen: modelData }
			Toasts { screen: modelData }
		}
	}
}
