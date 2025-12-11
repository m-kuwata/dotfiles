# PATH for Homebrew (Linuxbrew & mac both work)
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Starship
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"

# alias 読み込み
source ~/dotfiles/wsl/zsh/alias.zsh
