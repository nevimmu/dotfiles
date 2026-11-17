pragma Singleton
import QtQuick
import Quickshell

// Nerd Font (Material Design) glyphs, built from code points so the source stays plain ASCII.
Singleton {
	function g(cp) { return String.fromCodePoint(cp); }

	readonly property string speaker: g(0xF04C3)
	readonly property string headphones: g(0xF02CB)
	readonly property string chip: g(0xF061A)
	readonly property string memory: g(0xF035B)
	readonly property string disk: g(0xF02CA)
	readonly property string gpu: g(0xF08AE)
	readonly property string thermometer: g(0xF050F)
	readonly property string timer: g(0xF13AB)
	readonly property string play: g(0xF040A)
	readonly property string pause: g(0xF03E4)
	readonly property string restart: g(0xF0709)
	readonly property string calendar: g(0xF00ED)
	readonly property string bell: g(0xF009E)
	readonly property string bellOff: g(0xF009B)
	readonly property string bellBadge: g(0xF116B)
	readonly property string close: g(0xF0156)
	readonly property string clearAll: g(0xF05E9)
	readonly property string music: g(0xF075A)
	readonly property string musicOff: g(0xF075B)
	readonly property string chevronUp: g(0xF0143)
	readonly property string trayFull: g(0xF1296)
	readonly property string chevronRight: g(0xF0142)
	readonly property string chevronLeft: g(0xF0141)
	readonly property string earbuds: g(0xF184F)
	readonly property string earbudsOff: g(0xF1850)
	readonly property string bluetooth: g(0xF00AF)
	readonly property string btConnected: g(0xF00B1)
	readonly property string btOff: g(0xF00B2)
	readonly property string volHigh: g(0xF057E)
	readonly property string volMed: g(0xF0580)
	readonly property string volLow: g(0xF057F)
	readonly property string volMute: g(0xF0581)
	readonly property string search: g(0xF0349)
	readonly property string check: g(0xF012C)
	readonly property string gamepad: g(0xF0297)
	readonly property string mouse: g(0xF037D)
	readonly property string keyboard: g(0xF030C)
	readonly property string phone: g(0xF011C)
	readonly property string device: g(0xF0494)
}
