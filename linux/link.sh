#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/dotfiles"

echo "🚀 dotfiles セットアップ開始するよ〜！"

# --- zsh ---
echo "🔗 Linking zsh..."

ln -snf $DOTFILES_DIR/linux/zsh/.zshenv $HOME/.zshenv
ln -snf $DOTFILES_DIR/linux/zsh/.zshrc $HOME/.zshrc

# --- starship ---
echo "🔗 Linking starship..."

mkdir -p $HOME/.config
ln -snf $DOTFILES_DIR/linux/starship/starship.toml $HOME/.config/starship.toml

# --- lazynvim ---
echo "🔗 Linking lazynvim..."
ln -snf $DOTFILES_DIR/linux/nvim $HOME/.config/nvim

echo "✨ セットアップ完了！！"
echo "🎉 zsh と starship と lazynvimの設定をいい感じにリンクしたよ！"
