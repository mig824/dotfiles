-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "go",
      "python",
      "markdown",
      "rust",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.treesitter.language.register("python", "pyst")
      vim.treesitter.language.register("python", "starlark")
    end,
  },
}
