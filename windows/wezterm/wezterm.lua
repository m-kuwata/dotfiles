-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.automatically_reload_config = true

config.font = wezterm.font("HackGen35 Console NF")
config.font_size = 14.0

-- タブを下に表示（デフォルトでは上にある）
config.tab_bar_at_bottom = true

return config