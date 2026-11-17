pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../"
import "../theme"

// Open-Meteo weather. The city (and optional country code) in config.json is resolved to coordinates with
// Open-Meteo's geocoding API. Refreshes every 15 minutes.
Singleton {
    id: root

    property bool ready: false
    property bool failed: false
    property string city: Config.weather.city
    property real lat: 0
    property real lon: 0
    readonly property bool configured: Config.weather.city !== ""

    property real temp: 0
    property real feels: 0
    property real humidity: 0
    property real wind: 0
    property int code: 0
    property bool isDay: true
    property var hourly: []  // [{label, temp, code, isDay}]
    property var daily: []   // [{label, min, max, code}]

    readonly property string unit: Config.weather.units === "fahrenheit" ? "°F" : "°C"
    readonly property string windUnit: Config.weather.units === "fahrenheit" ? "mph" : "km/h"

    function g(cp) { return Icons.g(cp); }
    function icon(code, day) {
        if (code === 0 || code === 1) return day ? g(0xF0599) : g(0xF0594);
        if (code === 2) return day ? g(0xF0595) : g(0xF0F31);
        if (code === 3) return g(0xF0590);
        if (code === 45 || code === 48) return g(0xF0591);
        if (code >= 51 && code <= 57) return g(0xF0597);
        if (code === 66 || code === 67) return g(0xF067F);
        if (code >= 61 && code <= 65) return code >= 65 ? g(0xF0596) : g(0xF0597);
        if (code === 77 || (code >= 71 && code <= 75) || code === 85 || code === 86) return g(0xF0598);
        if (code >= 80 && code <= 82) return code === 82 ? g(0xF0596) : g(0xF0597);
        if (code === 96 || code === 99) return g(0xF067E);
        if (code === 95) return g(0xF0593);
        return g(0xF0590);
    }
    function describe(code) {
        const t = {
            0: "Clear sky", 1: "Mainly clear", 2: "Partly cloudy", 3: "Overcast",
            45: "Fog", 48: "Rime fog",
            51: "Light drizzle", 53: "Drizzle", 55: "Heavy drizzle", 56: "Freezing drizzle", 57: "Freezing drizzle",
            61: "Light rain", 63: "Rain", 65: "Heavy rain", 66: "Freezing rain", 67: "Freezing rain",
            71: "Light snow", 73: "Snow", 75: "Heavy snow", 77: "Snow grains",
            80: "Light showers", 81: "Showers", 82: "Violent showers", 85: "Snow showers", 86: "Heavy snow showers",
            95: "Thunderstorm", 96: "Thunderstorm, hail", 99: "Thunderstorm, heavy hail"
        };
        return t[code] ?? "Unknown";
    }
    function color(code, day) {
        if (code === 0 || code === 1) return day ? Theme.gold : Theme.iris;
        if (code >= 95) return Theme.love;
        if (code >= 51) return Theme.foam;
        return Theme.subtle;
    }

    // ---- fetching ----
    readonly property string configKey: Config.weather.city + "|" + Config.weather.country + "|" + Config.weather.units
    onConfigKeyChanged: debounce.restart()

    function refresh() {
        if (!configured) {
            ready = false;
            failed = false;
            return;
        }
        if (geocode.running || forecast.running)
            return;
        const c = Config.weather;
        const cc = c.country ? "&countryCode=" + encodeURIComponent(c.country) : "";
        geocode.command = ["curl", "-sf", "--max-time", "15",
            "https://geocoding-api.open-meteo.com/v1/search?count=1&name=" + encodeURIComponent(c.city) + cc];
        geocode.running = true;
    }
    function fetchForecast() {
        const fahr = Config.weather.units === "fahrenheit";
        forecast.command = ["curl", "-sf", "--max-time", "15",
            "https://api.open-meteo.com/v1/forecast?latitude=" + lat + "&longitude=" + lon
            + "&current=temperature_2m,apparent_temperature,relative_humidity_2m,weather_code,wind_speed_10m,is_day"
            + "&hourly=temperature_2m,weather_code,is_day&forecast_hours=12"
            + "&daily=weather_code,temperature_2m_max,temperature_2m_min&forecast_days=5"
            + "&timezone=auto" + (fahr ? "&temperature_unit=fahrenheit&wind_speed_unit=mph" : "")];
        forecast.running = true;
    }

    Timer { id: debounce; interval: 400; onTriggered: root.refresh() }
    Timer { interval: 15 * 60 * 1000; running: true; repeat: true; onTriggered: root.refresh() }
    Component.onCompleted: debounce.restart()

    Process {
        id: geocode
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const r = JSON.parse(text).results?.[0];
                    if (!r) {
                        root.failed = true; // unknown city
                        return;
                    }
                    root.lat = r.latitude;
                    root.lon = r.longitude;
                    root.city = r.name;
                } catch (e) {
                    root.failed = true; // network error / bad response
                    return;
                }
                root.fetchForecast();
            }
        }
    }

    Process {
        id: forecast
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const j = JSON.parse(text);
                    const c = j.current;
                    root.temp = c.temperature_2m;
                    root.feels = c.apparent_temperature;
                    root.humidity = c.relative_humidity_2m;
                    root.wind = c.wind_speed_10m;
                    root.code = c.weather_code;
                    root.isDay = c.is_day === 1;

                    const h = j.hourly;
                    const hours = [];
                    for (let i = 0; i < h.time.length; i += 2)
                        hours.push({ label: h.time[i].substring(11, 13) + "h", temp: h.temperature_2m[i], code: h.weather_code[i], isDay: h.is_day[i] === 1 });
                    root.hourly = hours;

                    const d = j.daily;
                    const days = [];
                    for (let i = 0; i < d.time.length; i++)
                        days.push({ label: i === 0 ? "Today" : Qt.formatDate(new Date(d.time[i] + "T12:00:00"), "ddd"), min: d.temperature_2m_min[i], max: d.temperature_2m_max[i], code: d.weather_code[i] });
                    root.daily = days;

                    root.ready = true;
                    root.failed = false;
                } catch (e) {
                    root.failed = true;
                }
            }
        }
    }
}
