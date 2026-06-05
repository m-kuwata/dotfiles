-- Pull in the wezterm API
local wezterm = require("wezterm")
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
config.default_domain = "WSL:Ubuntu-24.04"
-- WSLドメインの設定（default_cwdを指定しないとWindowsパスが渡されてエラーになる）
config.wsl_domains = {
	{
		name = "WSL:Ubuntu-24.04",
		distribution = "Ubuntu-24.04",
		default_cwd = "~",
	},
}
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
wezterm.on("update-right-status", function(window, pane)
	local workspace = window:active_workspace()

	if window:leader_is_active() then
		-- Leader押下中（Which-Key風）
		window:set_right_status(wezterm.format({
			{ Foreground = { Color = "#f5c2e7" } },
			{ Text = " ⌨ LEADER " },
			{ Foreground = { Color = "#a6e3a1" } },
			{ Text = " | Split: |  - " },
			{ Foreground = { Color = "#89b4fa" } },
			{ Text = " | Move: h j k l " },
			{ Foreground = { Color = "#fab387" } },
			{ Text = " | WS: s(切替) S(作成) $(rename) n/p(前後) " },
			{ Foreground = { Color = "#f9e2af" } },
			{ Text = " | ?(一覧) " },
			{ Foreground = { Color = "#cdd6f4" } },
			{ Text = " | " },
			{ Foreground = { Color = "#a6e3a1" } },
			{ Text = " " .. workspace .. " " },
		}))
	else
		-- 通常時：ワークスペース名のみ表示
		window:set_right_status(wezterm.format({
			{ Foreground = { Color = "#a6e3a1" } },
			{ Text = " " .. workspace .. " " },
		}))
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
-- helpers
----------------------------------------------------
local function to_wsl_path(path)
	-- /C:/path → /mnt/c/path
	local drive, rest = path:match("^/(%a):(/.*)$")
	if drive then return "/mnt/" .. drive:lower() .. rest end
	-- C:/path or C:\path → /mnt/c/path
	local drive2, rest2 = path:match("^(%a)[:\\/](.*)$")
	if drive2 then return "/mnt/" .. drive2:lower() .. "/" .. rest2:gsub("\\", "/") end
	return path
end

local function get_cwd(pane)
	local cwd_url = pane:get_current_working_dir()
	local path = cwd_url and cwd_url.file_path or wezterm.home_dir
	return to_wsl_path(path)
end


----------------------------------------------------
-- keybinds
----------------------------------------------------
config.leader = { key = "w", mods = "CTRL", timeout_milliseconds = 2000 }

config.keys = {
	-- ペイン分割
	{ key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal },
	{ key = "-", mods = "LEADER", action = act.SplitVertical },
	-- ペイン移動
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	-- ワークスペース切り替え（ファジー選択）
	{
		key = "s",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			local workspaces = {}
			for i, name in ipairs(wezterm.mux.get_workspace_names()) do
				table.insert(workspaces, {
					id = name,
					label = string.format("%d. %s", i, name),
				})
			end
			win:perform_action(
				act.InputSelector({
					action = wezterm.action_callback(function(_, _, id, label)
						if id and label then
							win:perform_action(act.SwitchToWorkspace({ name = id }), pane)
						end
					end),
					title = "Select workspace",
					choices = workspaces,
					fuzzy = true,
				}),
				pane
			)
		end),
	},
	-- ワークスペース作成
	{
		key = "S",
		mods = "LEADER|SHIFT",
		action = act.PromptInputLine({
			description = "(wezterm) Create new workspace:",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
				end
			end),
		}),
	},
	-- ワークスペース名変更
	{
		key = "$",
		mods = "LEADER|SHIFT",
		action = act.PromptInputLine({
			description = "(wezterm) Rename workspace:",
			action = wezterm.action_callback(function(win, pane, line)
				if line then
					wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
				end
			end),
		}),
	},
	-- ワークスペース前後切り替え
	{ key = "n", mods = "LEADER", action = act.SwitchWorkspaceRelative(1) },
	{ key = "p", mods = "LEADER", action = act.SwitchWorkspaceRelative(-1) },
	-- コマンドパレット（選択したコマンドを実行）
	{
		key = "?",
		mods = "LEADER|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			local commands = {
				{ id = "split_h",    label = "LEADER + |   ペインを左右に分割" },
				{ id = "split_v",    label = "LEADER + -   ペインを上下に分割" },
				{ id = "pane_left",  label = "LEADER + h   ペイン移動: 左" },
				{ id = "pane_down",  label = "LEADER + j   ペイン移動: 下" },
				{ id = "pane_up",    label = "LEADER + k   ペイン移動: 上" },
				{ id = "pane_right", label = "LEADER + l   ペイン移動: 右" },
				{ id = "ws_switch",  label = "LEADER + s   ワークスペース切り替え" },
				{ id = "ws_create",  label = "LEADER + S   ワークスペース作成" },
				{ id = "ws_rename",  label = "LEADER + $   ワークスペース名変更" },
				{ id = "ws_next",    label = "LEADER + n   次のワークスペース" },
				{ id = "ws_prev",    label = "LEADER + p   前のワークスペース" },
				{ id = "ws_dev",     label = "LEADER + d   開発用ワークスペース作成（4タブ）" },
				{ id = "ws_tmpl",    label = "LEADER + D   固定コマンドワークスペース起動" },
			}
			win:perform_action(act.InputSelector({
				title = "Command Palette  (LEADER = Ctrl+W)",
				choices = commands,
				fuzzy = true,
				action = wezterm.action_callback(function(win2, pane2, id, label)
					if not id or id == "" then return end
					if id == "split_h" then
						win2:perform_action(act.SplitHorizontal, pane2)
					elseif id == "split_v" then
						win2:perform_action(act.SplitVertical, pane2)
					elseif id == "pane_left" then
						win2:perform_action(act.ActivatePaneDirection("Left"), pane2)
					elseif id == "pane_down" then
						win2:perform_action(act.ActivatePaneDirection("Down"), pane2)
					elseif id == "pane_up" then
						win2:perform_action(act.ActivatePaneDirection("Up"), pane2)
					elseif id == "pane_right" then
						win2:perform_action(act.ActivatePaneDirection("Right"), pane2)
					elseif id == "ws_switch" then
						local workspaces = {}
						for i, name in ipairs(wezterm.mux.get_workspace_names()) do
							table.insert(workspaces, { id = name, label = string.format("%d. %s", i, name) })
						end
						win2:perform_action(act.InputSelector({
							title = "Select workspace",
							choices = workspaces,
							fuzzy = true,
							action = wezterm.action_callback(function(_, _, ws_id, ws_label)
								if ws_id and ws_label then
									win2:perform_action(act.SwitchToWorkspace({ name = ws_id }), pane2)
								end
							end),
						}), pane2)
					elseif id == "ws_create" then
						win2:perform_action(act.PromptInputLine({
							description = "(wezterm) Create new workspace:",
							action = wezterm.action_callback(function(w, p, line)
								if line then w:perform_action(act.SwitchToWorkspace({ name = line }), p) end
							end),
						}), pane2)
					elseif id == "ws_rename" then
						win2:perform_action(act.PromptInputLine({
							description = "(wezterm) Rename workspace:",
							action = wezterm.action_callback(function(_, _, line)
								if line then wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line) end
							end),
						}), pane2)
					elseif id == "ws_next" then
						win2:perform_action(act.SwitchWorkspaceRelative(1), pane2)
					elseif id == "ws_prev" then
						win2:perform_action(act.SwitchWorkspaceRelative(-1), pane2)
					elseif id == "ws_dev" then
						win2:perform_action(act.PromptInputLine({
							description = "(wezterm) Create dev workspace (4 tabs):",
							action = wezterm.action_callback(function(w, p, line)
								if line then
									local cwd_path = get_cwd(p)
									local cd = "cd '" .. cwd_path .. "'; "
									w:perform_action(act.SwitchToWorkspace({
										name = line,
										spawn = { args = { "zsh", "-c", cd .. "exec zsh" } },
									}), p)
									for i = 1, 3 do
										w:perform_action(act.SpawnCommandInNewTab({
											args = { "zsh", "-c", cd .. "exec zsh" },
										}), p)
									end
								end
							end),
						}), pane2)
					elseif id == "ws_tmpl" then
						local cwd = get_cwd(pane2)
						local cd = "cd '" .. cwd .. "'; "
						win2:perform_action(act.SwitchToWorkspace({
							name = "dev",
							spawn = { args = { "zsh", "-c", cd .. "ls -la; exec zsh" } },
						}), pane2)
						win2:perform_action(act.SpawnCommandInNewTab({ args = { "zsh", "-c", cd .. "git status; exec zsh" } }), pane2)
						win2:perform_action(act.SpawnCommandInNewTab({ args = { "zsh", "-c", cd .. "pwd; exec zsh" } }), pane2)
						win2:perform_action(act.SpawnCommandInNewTab({ args = { "zsh", "-c", cd .. "exec zsh" } }), pane2)
					end
				end),
			}), pane)
		end),
	},
	-- 固定コマンド付きワークスペース起動テンプレート
	-- カスタマイズ箇所:
	--   workspace_name : ワークスペース名
	--   cmd_N          : 各タブで実行するコマンド（"exec zsh"を末尾に付けるとコマンド後もシェルが残る）
	{
		key = "D",
		mods = "LEADER|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			local cwd = get_cwd(pane)
			local workspace_name = "dev" -- ★ワークスペース名
			-- cwd パラメータは WSL で誤変換されるため cd コマンドで移動する
			local cd = "cd '" .. cwd .. "'; "
			window:perform_action(act.SwitchToWorkspace({
				name = workspace_name,
				spawn = { args = { "zsh", "-c", cd .. "ls -la; exec zsh" } }, -- ★タブ1
			}), pane)
			window:perform_action(act.SpawnCommandInNewTab({
				args = { "zsh", "-c", cd .. "git status; exec zsh" }, -- ★タブ2
			}), pane)
			window:perform_action(act.SpawnCommandInNewTab({
				args = { "zsh", "-c", cd .. "pwd; exec zsh" }, -- ★タブ3
			}), pane)
			window:perform_action(act.SpawnCommandInNewTab({
				args = { "zsh", "-c", cd .. "exec zsh" }, -- ★タブ4
			}), pane)
		end),
	},
	-- 開発用ワークスペース作成（カレントディレクトリで4タブ）
	{
		key = "d",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "(wezterm) Create dev workspace (4 tabs):",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					local cwd_path = get_cwd(pane)
					local cd = "cd '" .. cwd_path .. "'; "
					window:perform_action(act.SwitchToWorkspace({
						name = line,
						spawn = { args = { "zsh", "-c", cd .. "exec zsh" } },
					}), pane)
					for i = 1, 3 do
						window:perform_action(act.SpawnCommandInNewTab({
							args = { "zsh", "-c", cd .. "exec zsh" },
						}), pane)
					end
				end
			end),
		}),
	},
}

-- マウス選択で自動コピー（左ボタン離したときにクリップボードへ）
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.CompleteSelectionOrOpenLinkAtMouseCursor("Clipboard"),
	},
}

return config
