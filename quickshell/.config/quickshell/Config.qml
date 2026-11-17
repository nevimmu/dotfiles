pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// User settings, read from config.json next to shell.qml (never written by the shell).
// Nothing personal is hardcoded here: every default is blank, and the widgets hide or show a hint
// for blank values. If config.json doesn't exist, it is created once from config.json.template.
// Edit the file and save: it reloads live, no restart needed.
Singleton {
	id: root

	property alias weather: adapter.weather
	property alias audio: adapter.audio

	FileView {
		id: file
		path: Quickshell.shellPath("config.json")
		watchChanges: true
		onFileChanged: reload()
		onLoadFailed: error => {
			if (error === FileViewError.FileNotFound)
				seed.running = true;
		}

		JsonAdapter {
			id: adapter

			property JsonObject weather: JsonObject {
				property string city: ""
				property string country: ""
				property string units: "celsius"
			}
			property JsonObject audio: JsonObject {
				property string speakerSink: ""
				property string headsetSink: ""
				property string earbudsMac: ""
				property string earbudsName: ""
			}
		}
	}

	// First run: copy the template (never overwrites an existing file)
	Process {
		id: seed
		command: ["cp", "-n", Quickshell.shellPath("config.json.template"), Quickshell.shellPath("config.json")]
		onExited: code => {
			if (code === 0)
				file.reload();
		}
	}
}
