#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "🚀 dotfiles セットアップ開始するよ〜！"

# --- zsh ---
echo "🔗 Linking zsh..."

ln -snf "$DOTFILES_DIR/linux/zsh/.zshenv" "$HOME/.zshenv"
ln -snf "$DOTFILES_DIR/linux/zsh/.zshrc" "$HOME/.zshrc"

# --- starship ---
echo "🔗 Linking starship..."

mkdir -p "$HOME/.config"
ln -snf "$DOTFILES_DIR/linux/starship/starship.toml" "$HOME/.config/starship.toml"

# --- lazynvim ---
echo "🔗 Linking lazynvim..."
ln -snf "$DOTFILES_DIR/linux/nvim" "$HOME/.config/nvim"

# --- navi ---
echo "🔗 Linking navi cheats..."
mkdir -p "$HOME/.local/share/navi"
ln -snf "$DOTFILES_DIR/linux/navi/cheats" "$HOME/.local/share/navi/cheats"

echo "✨ セットアップ完了！！"
echo "🎉 zsh と starship と lazynvimの設定をいい感じにリンクしたよ！"
