#!/usr/bin/env bash

set -e

echo "🔥 Starting dotfiles install..."


# -------------------------
# System packages (WSL)
# -------------------------
echo "🛠 Installing system build tools..."
sudo apt update
sudo apt install -y \
  build-essential \
  clang \
  cmake \
  pkg-config \
  wget \
  imagemagick \
  ghostscript \
  python3

npm install -g @mermaid-js/mermaid-cli

# -------------------------
# win32yank
# -------------------------
if ! command -v win32yank.exe >/dev/null; then
  mkdir -p ~/.local/bin
  cd ~/.local/bin 
  wget https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip
  unzip ./win32yank-x64.zip
  chmod +x ~/.local/bin/win32yank.exe
  cd ~ 
fi

# -------------------------
# Homebrew install
# -------------------------
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Installing Homebrew..."
  git clone https://github.com/Homebrew/brew /home/linuxbrew/.linuxbrew
fi

echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "🍺 Running brew bundle..."
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle --file=~/dotfiles/wsl/Brewfile --verbose

# -------------------------
# Symlinks
# -------------------------
echo "🔗 Creating symlinks..."

ln -sf ~/dotfiles/wsl/zsh/.zshrc ~/.zshrc
mkdir -p ~/.config
ln -sf ~/dotfiles/wsl/starship/starship.toml ~/.config/starship.toml

echo "🎉 Done! Restart your terminal!"
