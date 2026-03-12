-- Customize Mason

---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "gopls",
        "ruff",
        "stylua",
        "debugpy",
        "tree-sitter-cli",
      },
    },
  },
}
