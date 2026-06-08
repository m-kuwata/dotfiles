# Dotfiles

個人用dotfilesです。WSL2 + WezTermの環境をセットアップします。

## セットアップ

### Linux（WSL / Docker）

```bash
git clone https://github.com/m-kuwata/dotfiles ~/dotfiles
cd ~/dotfiles
make linux
```

Homebrew・各種CLIツール・シンボリックリンクが一括でセットアップされます。
DockerコンテナとWSL2の両方で動作します（WSL固有のツールは自動でスキップされます）。

### Windows（WezTerm設定）

WSLのターミナルから実行:

```bash
cd ~/dotfiles
make windows
```

> **注意: シンボリックリンク作成には以下のどちらかが必要です**
>
> - Windows の Developer Mode を有効化（設定 → システム → 開発者向け）← 推奨
> - または管理者権限の PowerShell から直接実行:
>   ```powershell
>   cd C:\Users\<ユーザー名>\dotfiles
>   .\windows\setup.ps1
>   ```

## ファイル構成

```
dotfiles/
├── Makefile               # make linux / make windows
├── linux/
│   ├── install.sh         # パッケージインストール（apt, brew等）
│   ├── link.sh            # シンボリックリンク作成
│   ├── Brewfile           # Homebrewパッケージ一覧
│   ├── zsh/
│   │   ├── .zshenv        # 環境変数
│   │   ├── .zshrc         # zsh設定
│   │   └── alias.zsh      # エイリアス
│   ├── starship/          # Starship設定
│   ├── nvim/              # Neovim設定（LazyVim）
│   └── navi/              # naviチートシート
└── windows/
    ├── setup.ps1          # WezTermシンボリックリンク作成
    └── wezterm/
        └── wezterm.lua    # WezTerm設定
```
