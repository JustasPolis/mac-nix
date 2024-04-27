return {
  "JustasPolis/xcodebuild.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter",
    "mfussenegger/nvim-dap",
  },
  lazy = true,
  cmd = "XcodebuildSetup",
  config = function()
    require("xcodebuild").setup({})

    local xcodebuild = require("xcodebuild.integrations.dap")
    local codelldbPath = "/etc/codelldb"
    local lldbpath =
      "/Applications/Xcode-15.2.0.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB"
    xcodebuild.setup(codelldbPath, nil, lldbpath)

    vim.api.nvim_create_user_command("XcodeDebug", function()
      xcodebuild.build_and_debug()
    end, {})
  end,
}
