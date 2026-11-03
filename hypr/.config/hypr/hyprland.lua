-- Hyprland Lua Configuration
-- Migrated from hyprland.conf

------------------
---- MONITORS ----
------------------

-- monitor=,preferred,auto,auto
hl.monitor({
	output   = "",
	mode     = "preferred",
	position = "auto",
	scale    = "auto",
})

-- monitor=DP-1, 2560x1440@169.83, 0x0, 1
hl.monitor({
	output        = "DP-1",
	mode          = "2560x1440@169.83",
	position      = "0x0",
	scale         = "1",
	-- cm            = "hdr",
	-- sdrbrightness = 1.4,
  -- sdrsaturation = 0.5,
	-- bitdepth     = 10,
	-- sdr_max_luminance = 400,
	-- sdr_min_luminance = 0.0005,
})

-- monitor=HDMI-A-1, 1920x1080@60.00, 2560x-140, 1, transform, 3
hl.monitor({
	output    = "HDMI-A-1",
	mode      = "1920x1080@60.00",
	position  = "2560x-140",
	scale     = "1",
	transform = 3,
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "nautilus"
local menu        = "rofi -show drun"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function () 
	hl.exec_cmd("dunst")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("waybar")
	hl.exec_cmd("jams")
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("wl-clip-persist --clipboard both")
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")

	-- Workspaces autostart
	hl.exec_cmd("zen-browser", { workspace = 1})
	hl.exec_cmd("spotify-launcher", { workspace = 10})
	hl.exec_cmd("discord", { workspace = 10})
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRSHOT_DIR", os.getenv("HOME") .. "/Pictures/Screenshots")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	general = {
		gaps_in  = 2,
		gaps_out = 10,
		border_size = 2,

		col = {
			active_border   = "rgb(C4A7E7)",
			inactive_border = "rgb(6E6A86)",
		},

		resize_on_border = false,
		allow_tearing    = false,
		layout           = "dwindle",
	},

	decoration = {
		rounding       = 10,
		rounding_power = 2,
		active_opacity   = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled      = true,
			range        = 4,
			render_power = 3,
			color        = "rgba(23213699)",
		},

		blur = {
			enabled   = true,
			size      = 4,
			passes    = 2,
			vibrancy  = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
		force_split = 2,
	},

	master = {
		new_status = "master",
	},

	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo   = true,
		swallow_regex           = "^kitty$",
	},
})

-- Curves
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

hl.curve("spring_menu",      { type = "spring", mass = 1,   stiffness = 80, dampening = 14 })
hl.curve("spring_workspace", { type = "spring", mass = 1.2, stiffness = 30, dampening = 10 })
hl.curve("spring_special",   { type = "spring", mass = 1,   stiffness = 30, dampening = 8  }) 

hl.curve("spring_window",    { type = "spring", mass = 1,   stiffness = 30, dampening = 8  })
hl.curve("spring_open",      { type = "spring", mass = 1,   stiffness = 30, dampening = 8  })

hl.curve("md3_decel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("md3_accel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })

-- Animations
hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

-- Window animations
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })


-- Workspace animations
hl.animation({ leaf = "workspaces",       enabled = true, speed = 1.94, bezier = "almostLinear", style = "slidevert" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 1.30, bezier = "almostLinear", style = "fade" })


---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout    = "fr",
		kb_options   = "caps:swapescape",
		repeat_delay = 150,
		repeat_rate  = 70,
		follow_mouse = 1,
		sensitivity  = 0,

		touchpad = {
			natural_scroll = false,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace"
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- Basic binds
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd(terminal .. " yazi"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal .. " btop"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(terminal .. " lazydocker"))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("wallpaper-maid"))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("wlogout"))

-- Projects
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/projects.sh"))

-- Focus
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Move
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- Tab / Workspace Switch
hl.bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))

-- Clipboard
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))

-- Screenshot
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region"))

-- Minimize
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + S", hl.dsp.window.move({ workspace = "+0" }))
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))

-- Workspaces
local ws_keys = {
	[1] = "ampersand",
	[2] = "eacute",
	[3] = "quotedbl",
	[4] = "apostrophe",
	[5] = "parenleft",
	[6] = "minus",
	[7] = "egrave",
	[8] = "underscore",
	[9] = "ccedilla",
	[10] = "agrave",
}

for i = 1, 10 do
	local key = ws_keys[i]
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
	hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.window.move({ workspace = i, silent = true }))
end

-- Special Workspace
hl.bind(mainMod .. " + N", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.window.move({ workspace = "special:scratchpad" }))

-- Mouse
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Workspace assignments
hl.workspace_rule({ workspace = 1, monitor = "DP-1", default = true })
hl.workspace_rule({ workspace = 2, monitor = "DP-1" })
hl.workspace_rule({ workspace = 3, monitor = "DP-1" })
hl.workspace_rule({ workspace = 4, monitor = "DP-1" })
hl.workspace_rule({ workspace = 5, monitor = "DP-1" })
hl.workspace_rule({ workspace = 6, monitor = "DP-1" })
hl.workspace_rule({ workspace = 7, monitor = "DP-1" })
hl.workspace_rule({ workspace = 8, monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = 9, monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = 10, monitor = "HDMI-A-1", default = true })

hl.workspace_rule({ workspace = "special:scratchpad", on_created_empty = "kitty" })

-- Window Rules
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },
	move = "20 monitor_h-120",
	float = true,
})

hl.window_rule({
	name = "Games",
	match = { title = "^(Steam|Sign in to Steam|Heroic Games Launcher)$" },
	workspace = "5 silent",
	center = true,
})

hl.window_rule({
	name = "Sidescreen",
	match = { class = "^(discord|Spotify)$" },
	workspace = 10,
	float = false,
})

hl.window_rule({
	name = "PIP",
	match = { title = "Picture-in-Picture" },
	workspace = 10,
	float = true,
	size = { 1056, 944 },
	move = { 12, 12 },
})

-- Layer Rules
hl.layer_rule({
	name = "blur-rofi",
	match = { namespace = "rofi" },
	blur = true,
})

hl.layer_rule({
	name = "blur-waybar",
	match = { namespace = "waybar" },
	blur = true,
})
