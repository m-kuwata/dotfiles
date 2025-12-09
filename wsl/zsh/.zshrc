# PATH for Homebrew (Linuxbrew & mac both work)
if [ -d /home/linuxbrew/.linuxbrew/bin ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -d /opt/homebrew/bin ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Starship
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"

# alias 読み込み
source ~/dotfiles/zsh/alias.zsh
