local wezterm = require("wezterm")

local config = {}

-- config.font = wezterm.font("JetBrainsMono NF")
config.font = wezterm.font("FiraCode Nerd Font Mono")
config.harfbuzz_features = { "liga=1", "clig=1", "calt=1" }
config.font_size = 14

-- config.color_scheme = "Catppuccin Macchiato"
-- config.use_fancy_tab_bar = false

config.keys = {
	{ key = "k", mods = "CMD", action = wezterm.action.ClearScrollback("ScrollbackAndViewport") },

	-- Toggle fullscreen mode
	{ key = "M", mods = "CMD|SHIFT", action = wezterm.action.ToggleFullScreen },

	-- Search text
	-- { key = 'f', mods = 'CMD', action = wezterm.action.Search { CaseSensitiveString = "" }},
	-- { key = 'f', mods = 'CMD|SHIFT', action = wezterm.action.Search { CaseInSensitiveString = "" }},

	-- Cmd + D for horizontal split (same as iTerm)
	{ key = "d", mods = "CMD", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- Cmd + Shift + D for vertical split
	{ key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	-- Switch to the left pane
	{ key = "LeftArrow", mods = "CMD|SHIFT", action = wezterm.action.ActivatePaneDirection("Left") },
	-- Switch to the right pane
	{ key = "RightArrow", mods = "CMD|SHIFT", action = wezterm.action.ActivatePaneDirection("Right") },
	-- Switch to the pane above
	{ key = "UpArrow", mods = "CMD|SHIFT", action = wezterm.action.ActivatePaneDirection("Up") },
	-- Switch to the pane below
	{ key = "DownArrow", mods = "CMD|SHIFT", action = wezterm.action.ActivatePaneDirection("Down") },
	-- Resize pane to the left
	{ key = "LeftArrow", mods = "CMD|OPT", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
	-- Resize pane to the right
	{ key = "RightArrow", mods = "CMD|OPT", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
	-- Resize pane upwards
	{ key = "UpArrow", mods = "CMD|OPT", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
	-- Resize pane downwards
	{ key = "DownArrow", mods = "CMD|OPT", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
	-- Toggle the zoom state of the current pane
	{ key = "Enter", mods = "CMD|SHIFT", action = wezterm.action.TogglePaneZoomState },

	-- Cmd + Option + Left Arrow to switch to the previous tab
	{ key = "LeftArrow", mods = "CMD", action = wezterm.action.ActivateTabRelative(-1) },
	-- Cmd + Option + Right Arrow to switch to the next tab
	{ key = "RightArrow", mods = "CMD", action = wezterm.action.ActivateTabRelative(1) },
	-- Bind Cmd + Shift + A to open the tab navigator for quick tab switching
	{ key = "A", mods = "CMD|SHIFT", action = wezterm.action.ShowTabNavigator },
	-- Bind Cmd + Shift + P to open the command palette (launcher menu) for quick access to tabs, panes, and actions
	{ key = "P", mods = "CMD|SHIFT", action = wezterm.action.ShowLauncher },
}

config.color_scheme = "Tokyo Night"
-- config.color_scheme = "Night Owl (Gogh)"

config.hyperlink_rules = {
	-- Match standard URLs
	{
		regex = "\\b\\w+://(?:[\\w.-]+)\\.[a-z]{2,15}(?::\\d+)?(?:/[^\\s]*)?\\b",
		format = "$0",
	},
	-- Match email addresses
	{
		regex = "\\b[\\w._%+-]+@[\\w.-]+\\.[a-z]{2,15}\\b",
		format = "mailto:$0",
	},
	-- Match file:// URIs
	{
		regex = "\\bfile://\\S+\\b",
		format = "$0",
	},
}

return config
