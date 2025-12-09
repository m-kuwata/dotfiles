# PowerShell

$DotfilesDir = "$HOME\dotfiles"
$Target = "$HOME\.wezterm.lua"
$Source = "$DotfilesDir\windows\wezterm\wezterm.lua"

Write-Host "🚀 WezTerm の設定リンク作成するよ〜！"

# 既存ファイルがあれば削除
if (Test-Path $Target) {
    Write-Host "🗑 既存の .wezterm.lua を削除するね"
    Remove-Item $Target -Force
}

# ディレクトリを確実に作る
$WezConfigDir = Split-Path $Target
if (-not (Test-Path $WezConfigDir)) {
    Write-Host "📁 Config ディレクトリ作成中..."
    New-Item -ItemType Directory -Force -Path $WezConfigDir | Out-Null
}

# シンボリックリンク作成
Write-Host "🔗 シンボリックリンク作成！"
New-Item -ItemType SymbolicLink -Path $Target -Target $Source | Out-Null

Write-Host "✨ セットアップ完了！ WezTerm の設定を dotfiles に寄せたよ〜！"
