local wezterm = require 'wezterm'

local event = {
    increaseOpacity = 'increase-opacity',
    decreaseOpacity = 'decrease-opacity',
    toggleOpacity = 'toggle-opacity',
}

wezterm.on(event.increaseOpacity, function(window)
    local config = window:get_config_overrides() or {}
    local current_opacity = config.window_background_opacity or 1.0

    if current_opacity < 1.0 then
        config.window_background_opacity = current_opacity + 0.1
    end

    window:set_config_overrides(config)
end)

wezterm.on(event.decreaseOpacity, function(window)
    local config = window:get_config_overrides() or {}
    local current_opacity = config.window_background_opacity or 1.0

    if current_opacity > 0.1 then
        config.window_background_opacity = current_opacity - 0.1
    end

    window:set_config_overrides(config)
end)

wezterm.on(event.toggleOpacity, function(window)
    local config = window:get_config_overrides() or {}
    local current_opacity = config.window_background_opacity or 1.0

    if current_opacity == 1.0 then
        config.window_background_opacity = 0.5
    else
        config.window_background_opacity = nil
    end

    window:set_config_overrides(config)
end)

return event
