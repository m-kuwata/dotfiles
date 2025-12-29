#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/dotfiles"

echo "🚀 dotfiles セットアップ開始するよ〜！"

# --- zsh ---
echo "🔗 Linking zsh..."

mkdir -p $HOME/.config/zsh
ln -snf $DOTFILES_DIR/wsl/zsh/.zshrc $HOME/.zshrc
ln -snf $DOTFILES_DIR/wsl/zsh/.zshenv $HOME/.zshenv

# --- starship ---
echo "🔗 Linking starship..."

mkdir -p $HOME/.config
ln -snf $DOTFILES_DIR/wsl/starship/starship.toml $HOME/.config/starship.toml

# --- lazynvim ---
echo "🔗 Linking lazynvim..."
ln -snf $DOTFILES_DIR/wsl/nvim $HOME/.config/nvim

echo "✨ セットアップ完了！！"
echo "🎉 zsh と starship と lazynvimの設定をいい感じにリンクしたよ！"
