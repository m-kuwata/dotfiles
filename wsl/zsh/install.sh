#!/usr/bin/env bash

set -e

echo "🔥 Starting dotfiles install..."

# -------------------------
# Homebrew install
# -------------------------
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "🍺 Running brew bundle..."
brew bundle --file=~/dotfiles/wsl/Brewfile

# -------------------------
# Symlinks
# -------------------------
echo "🔗 Creating symlinks..."

ln -sf ~/dotfiles/wsl/zsh/.zshrc ~/.zshrc
mkdir -p ~/.config
ln -sf ~/dotfiles/wsl/starship/starship.toml ~/.config/starship.toml

echo "🎉 Done! Restart your terminal!"