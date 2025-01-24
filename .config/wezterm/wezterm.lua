local wezterm = require("wezterm")

-- https://github.com/wez/wezterm/discussions/4858
local scheme = "Catppuccin Mocha"
local scheme_def = wezterm.color.get_builtin_schemes()[scheme]

local bg_h, bg_s, bg_l, bg_a = wezterm.color.parse(scheme_def.background):hsla()
local bg = wezterm.color.from_hsla(bg_h, bg_s, bg_l, 0)

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- https://github.com/catppuccin/wezterm
config.color_scheme = scheme

-- change config now
config.default_domain = "WSL:Ubuntu"
config.use_fancy_tab_bar = false
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_buttons = {}
config.enable_scroll_bar = false
config.hide_tab_bar_if_only_one_tab = false
--config.window_background_opacity = 0.95

config.window_frame = {
    border_left_width = 0,
    border_right_width = 0,
    border_bottom_height = 0,
    border_top_height = 0,
}

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

config.colors = {
    tab_bar = {
        background = bg,
    },
}

config.background = {
    {
        source = {
            File = "C:\\Users\\leandro.bravo\\Pictures\\wezterm.jpg",
        },
        hsb = dimmer,
        opacity = 1,
    },
    {
        source = {
            Color = scheme_def.background,
        },
        width = "100%",
        height = "100%",
        opacity = 0.95,
    },
}

return config
