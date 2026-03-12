-- Center the command line popup
---@type LazySpec
return {
  "folke/noice.nvim",
  opts = {
    cmdline = {
      view = "cmdline_popup",
    },
  },
}
