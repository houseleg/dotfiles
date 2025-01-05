local wezterm = require 'wezterm'

wezterm.on('window-config-reloaded', function(window)
    local seen = wezterm.GLOBAL.seen_windows or {}
    local id = tostring(window:window_id())
    local is_new_window = not seen[id]
    seen[id] = true
    wezterm.GLOBAL.seen_windows = seen
    if is_new_window then
        window:toggle_fullscreen()
    end
end)
