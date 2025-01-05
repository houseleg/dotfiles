local wezterm = require 'wezterm'

return {
    font = wezterm.font_with_fallback({
        {
            family = 'FiraCode Nerd Font Propo',
            weight = 'Regular',
        }
    }),
}
