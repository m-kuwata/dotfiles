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

# alias
source ~/dotfiles/wsl/zsh/alias.zsh
