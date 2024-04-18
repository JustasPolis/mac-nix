return {
  "JustasPolis/swift.nvim",
  dev = true,
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  cmd = "Swift",
  lazy = false,
  config = function()
    require("swift").setup()
  end,
}
