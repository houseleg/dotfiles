local wezterm = require 'wezterm'

local icons = {
    zsh = wezterm.nerdfonts.cod_terminal,
}

local function tab_title(tab)
    local title = tab.active_pane.title
    local icon = icons[title] or wezterm.nerdfonts.cod_terminal
    local zoomed = tab.active_pane.is_zoomed
        and '  ' .. wezterm.nerdfonts.seti_code_search
        or ''
    return icon .. '  ' .. title .. zoomed
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    return {
        { Text = tab_title(tab) },
    }
end)
