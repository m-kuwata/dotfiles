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

echo "✨ セットアップ完了！！"
echo "🎉 zsh と starship の設定をいい感じにリンクしたよ！"