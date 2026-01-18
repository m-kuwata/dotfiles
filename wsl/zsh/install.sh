#!/usr/bin/env bash

set -e

echo "🔥 Starting dotfiles install..."

if command -v sudo >/dev/null 2>&1; then
  SUDO=sudo
else
  SUDO=""
fi

is_wsl() {
  grep -qi microsoft /proc/version 2>/dev/null
}

is_docker() {
  [ -f /.dockerenv ] || grep -qa docker /proc/1/cgroup 2>/dev/null
}

# -------------------------
# System packages (WSL)
# -------------------------
echo "🛠 Installing system build tools..."
$SUDO apt update
$SUDO apt install -y \
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
# win32yank (WSL only)
# -------------------------
if is_wsl && ! is_docker; then
  if ! command -v win32yank.exe >/dev/null 2>&1; then
    echo "📋 Installing win32yank (WSL)..."
    mkdir -p ~/.local/bin
    (
      cd ~/.local/bin
      wget -q https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip
      unzip -o win32yank-x64.zip
      chmod +x win32yank.exe
    )
  fi
else
  echo "⏭ Skipping win32yank (not WSL or running in Docker)"
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
