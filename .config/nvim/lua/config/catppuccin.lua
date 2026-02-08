catppuccin = require('catppuccin')

catppuccin.setup({
    flavor = "mocha",
    transparent_background = true,
    float = {
        transparent = true, -- enable transparent floating windows
        solid = false, -- use solid styling for floating windows, see |winborder|
    },
    auto_integrations = true,
})
