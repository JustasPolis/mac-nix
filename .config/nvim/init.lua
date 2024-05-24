if vim.g.vscode then
  return
else
  require("lazy-nvim")
  require("keymaps")
  require("options")
  require("commands")
end
