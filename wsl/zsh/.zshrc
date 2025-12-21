# PATH for Homebrew (Linuxbrew & mac both work)
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Starship
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"

# navi (fzf UI)
if command -v navi >/dev/null 2>&1; then
  eval "$(navi widget zsh)"
fi

# fzf UI
export FZF_DEFAULT_OPTS="
  --height=60%
  --layout=reverse
  --border
  --cycle
  --info=inline
"

# 爆速ファイル検索 + エディタ起動
function fe() {
  local file
  file=$(fzf --preview 'bat --style=numbers --color=always {}')
  [[ -n $file ]] && vi "$file"
}

# プロジェクトのTODOを一覧表示
function todo() {
  rg -i "todo|fixme|hack" --type js --type ts --type tsx
}

# alias
source ~/dotfiles/wsl/zsh/alias.zsh
