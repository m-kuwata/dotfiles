-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

----------------------------------------------------
-- general
----------------------------------------------------
-- コンフィグ自動反映（Ctrl+Shift+R）
config.automatically_reload_config = true
-- デフォルトシェル
config.default_domain = 'WSL:Ubuntu-24.04'

----------------------------------------------------
-- Tab
----------------------------------------------------
-- タイトルバーを非表示
config.window_decorations = "RESIZE"

-- タブバーの表示
config.show_tabs_in_tab_bar = true

-- タブが一つの時は非表示
-- config.hide_tab_bar_if_only_one_tab = true

-- タブの追加ボタンを非表示
-- config.show_new_tab_button_in_tab_bar = false.

-- nightlyのみ使用可能
-- タブの閉じるボタンを非表示
-- config.show_close_tab_button_in_tabs = false

-- タブを下に表示（デフォルトでは上にある）
config.tab_bar_at_bottom = true

----------------------------------------------------
-- font
----------------------------------------------------
-- フォントファミリー
config.font = wezterm.font("HackGen35 Console NF")

-- フォントサイズ
config.font_size = 14.0

----------------------------------------------------
-- keybinds
----------------------------------------------------


return config