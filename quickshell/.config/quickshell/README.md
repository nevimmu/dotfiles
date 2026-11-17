# Quickshell vertical shell

A vertical, floating [Quickshell](https://quickshell.org) bar for Hyprland in the Rose Pine Moon palette
(CartographCF Nerd Font). Hovering an icon expands the bar into a connected panel. It has workspaces,
audio output switching, Bluetooth, tray, weather, system stats, notifications and a calendar/timer.

## Requirements

- Quickshell 0.3 or newer and Hyprland
- CartographCF Nerd Font installed
- PipeWire (`wpctl`/`pactl`), BlueZ (`bluetoothctl`), `curl`
- Optional: [JAMS](#jams) for the auto-mute controls, `blueman-manager` for the "Open Blueman" button,
  `notify-send` and `paplay` for the timer alarm

## Setup

1. Make your config. Copy the template (the shell also does this for you the first time it starts):

   ```bash
   cp config.json.template config.json
   ```

2. Fill in `config.json` (see [Finding the values](#finding-the-values)). The file is read live: save it and the
   shell updates, no restart needed. `config.json` is git-ignored, so your personal values stay out of the repo.
3. Run it:

   ```bash
   quickshell -p ~/.config/quickshell
   ```

   To start it with Hyprland (Lua config): `hl.exec_cmd("quickshell")`.

Blank values never break anything: an unconfigured output button is hidden in the audio panel, and the weather panel
asks you to set a city.

## config.json

| Key | What it is |
|---|---|
| `weather.city` | City name, e.g. `Paris`. Looked up with Open-Meteo's geocoding, no API key needed. |
| `weather.country` | Optional two-letter country code (`FR`, `US`...) to pick the right city when names clash. |
| `weather.units` | `celsius` or `fahrenheit` (fahrenheit also switches wind to mph). |
| `audio.speakerSink` | PipeWire name of your speakers output (the "Speakers" button). |
| `audio.headsetSink` | PipeWire name of your headset output (the "Headset" button). |
| `audio.earbudsMac` | Bluetooth MAC address of your earbuds (the "Earbuds" button). |
| `audio.earbudsName` | Label shown for the earbuds. If blank, the device's own Bluetooth name is used. |

Leave a value as `""` to turn that item off.

## Finding the values

### Audio outputs (`speakerSink`, `headsetSink`)

List the names of all your outputs (the second column is the one you need):

```bash
pactl list short sinks | cut -f2
```

Example output:

```text
alsa_output.usb-Some_Audio_Interface-00.HiFi__Line__sink
alsa_output.usb-Some_USB_DAC-00.analog-stereo
```

To tell which is which, switch your default output to the one you want to name, then run:

```bash
pactl get-default-sink
```

`wpctl status -n` shows the same names in the "Sinks" section, with a `*` next to the current default.
Paste the full name, exactly as printed, into `speakerSink` or `headsetSink`.

### Bluetooth earbuds (`earbudsMac`, `earbudsName`)

Pair the earbuds first (with `bluetoothctl` or Blueman), then list paired devices:

```bash
bluetoothctl devices
```

```text
Device AA:BB:CC:DD:EE:FF My Earbuds
```

The first value is `earbudsMac`; the rest is the name you can use for `earbudsName`. To see only what is
connected right now: `bluetoothctl devices Connected`.

The earbuds' audio output only exists while they are connected (it appears as
`bluez_output.AA_BB_CC_DD_EE_FF.1`), so the shell finds it by MAC address and you never need to copy that name.
Clicking the Earbuds button while they are off connects them and switches over once they are up.

### Weather

Just set `city` (and ideally `country`). If the panel says it could not load weather, check the spelling of the
city and your connection.

## JAMS

If JAMS (auto-mute) is installed and running, the audio panel gets an "Auto-mute" switch and a
"Pause all players" button. They use `jams --toggle`, `jams --pause-all` and `jams --status`, and are dimmed with
"JAMS not running" when JAMS is not running.
