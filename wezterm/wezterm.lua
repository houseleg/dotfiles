local wezterm = require 'wezterm'
local util = require 'util'
local window = require 'window'
local tab = require 'tab'
local font = require 'font'
local keybind = require 'keybind'

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

return util.merge_tables(
    config,
    window,
    tab,
    font,
    keybind,
    {}
)
