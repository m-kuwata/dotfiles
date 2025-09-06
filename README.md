# Dotfiles

Claude CodeのMCPサーバ設定を含む個人用dotfilesです。

## セットアップ

### 1. 環境変数の設定

```powershell
# PowerShellで実行
.\setup-env.ps1
```

または手動で：
```powershell
[System.Environment]::SetEnvironmentVariable('GITHUB_PERSONAL_ACCESS_TOKEN', 'your_token_here', 'User')
```

### 2. devcontainerでの使用

このdotfilesリポジトリには`.devcontainer/devcontainer.json`が含まれています。

- 環境変数は自動的にdevcontainer内に転送されます
- Claude Codeが自動的にインストールされます
- `.claude.json`設定がマウントされます

### 3. ファイル構成

- `.claude.json` - Claude Codeの設定（MCP含む）
- `.devcontainer/devcontainer.json` - devcontainer設定
- `setup-env.ps1` - 環境変数セットアップスクリプト
- `.gitignore` - 機密情報を除外