-- PATH fix for Neovim (WSL / Devcontainer friendly)
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.expand("~/.local/bin")

vim.opt.clipboard = "unnamedplus"

vim.g.clipboard = {
  name = "win32yank",
  copy = {
    ["+"] = "win32yank.exe -i --crlf",
    ["*"] = "win32yank.exe -i --crlf",
  },
  paste = {
    ["+"] = "win32yank.exe -o --lf",
    ["*"] = "win32yank.exe -o --lf",
  },
  cache_enabled = 0,
}

