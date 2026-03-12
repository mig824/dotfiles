---@type LazySpec
return {
  {
    "sindrets/diffview.nvim",
    lazy = false,
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
        view = {
          default = { layout = "diff2_horizontal" },
          merge_tool = { layout = "diff3_mixed" },
        },
        keymaps = {
          view = {
            ["q"] = "<cmd>DiffviewClose<cr>",
          },
          file_panel = {
            ["q"] = "<cmd>DiffviewClose<cr>",
          },
        },
      })
    end,
  },
}
