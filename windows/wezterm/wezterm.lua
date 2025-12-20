-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

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
-- 閉じる時の確認ダイアログを出さない
config.window_close_confirmation = "NeverPrompt"

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
-- UI
----------------------------------------------------
wezterm.on("update-status", function(window, pane)
  if window:leader_is_active() then
    -- Leader押下中（Which-Key風）
    window:set_right_status(
      wezterm.format({
        { Foreground = { Color = "#f5c2e7" } },
        { Text = " ⌨ LEADER " },
        { Foreground = { Color = "#a6e3a1" } },
        { Text = " | Split: |  - " },
        { Foreground = { Color = "#89b4fa" } },
        { Text = " | Move: h j k l " },
      })
    )
  else
    -- 通常時
    window:set_right_status(" ")
  end
end)

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
config.leader = { key = "a", mods = "CTRL" }

config.keys = {
  { key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal },
  { key = "-", mods = "LEADER",        action = act.SplitVertical },
  { key = "h", mods = "LEADER",        action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = "LEADER",        action = act.ActivatePaneDirection("Right") },
  { key = "j", mods = "LEADER",        action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER",        action = act.ActivatePaneDirection("Up") },
}

return config