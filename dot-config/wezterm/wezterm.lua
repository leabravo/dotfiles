local wezterm = require("wezterm")

-- https://github.com
-- https://github.com/wez/wezterm/discussions/4858
local scheme = "Catppuccin Mocha"
local scheme_def = wezterm.color.get_builtin_schemes()[scheme]

local bg_h, bg_s, bg_l, bg_a = wezterm.color.parse(scheme_def.background):hsla()
local at_h, at_s, at_l, at_a = wezterm.color.parse(scheme_def.tab_bar.inactive_tab.bg_color):hsla()
local bg = wezterm.color.from_hsla(bg_h, bg_s, bg_l, 0)
local at = wezterm.color.from_hsla(at_h, bg_s, bg_l, 0)

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.front_end = "WebGpu"
config.enable_wayland = true

-- https://github.com
config.color_scheme = scheme
config.font_size = 10.2

-- change config now
-- Check if running on Windows
local is_windows = wezterm.target_triple:find("windows") ~= nil

-- Shared configuration
config.adjust_window_size_when_changing_font_size = false
config.line_height = .99
config.cell_width = .89
config.use_resize_increments = false
config.window_decorations = "NONE"
config.enable_scroll_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.window_padding = {
    left = ".2cell",
    right = ".2cell",
    top = 0,
    bottom = 0,
}
config.window_content_alignment = {
  horizontal = 'Center',
  vertical = 'Center',
}

if is_windows then
    config.default_domain = "WSL:Ubuntu"
    config.integrated_title_buttons = { "Hide", "Maximize", "Close" }
    config.integrated_title_button_style = "Windows"
    config.use_fancy_tab_bar = true
    config.window_background_opacity = 1
    
    config.window_frame = {
        -- Using 'bg' variable from discussion 4858 for transparency
        active_titlebar_bg = bg,
        inactive_titlebar_bg = bg,
        border_left_width = 0,
        border_right_width = 0,
        border_bottom_height = 0,
        border_top_height = 0,
    }

    config.colors = {
        tab_bar = {
            background = bg,
            inactive_tab = {
                bg_color = bg,
                fg_color = "#808080",
            },
			 -- Esto quita el gris feo al pasar el ratón
            inactive_tab_hover = {
                bg_color = "rgba(255, 255, 255, 0)",
                fg_color = "#ffffff",
                italic = true,
            },
            new_tab = {
                bg_color = bg,
                fg_color = "#808080",
            },
            active_tab = {
                bg_color = "rgba(0, 0, 0, 0)",
                fg_color = "#cdd6f4",
            },
        },
    }
else
    config.integrated_title_buttons = {}
    config.use_fancy_tab_bar = false
    config.colors = {
        tab_bar = {
            background = bg,
        },
    }
end

config.background = {
    {
        source = {
            File = "C:\\Users\\bravotool\\Pictures\\wezterm.jpg",
        },
        opacity = 0.75,
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
