---@type LazySpec
return {
  "lewis6991/gitsigns.nvim",
  opts = function(_, opts)
    local original_on_attach = opts.on_attach
    opts.on_attach = function(bufnr)
      if original_on_attach then original_on_attach(bufnr) end
      -- Remove gitsigns' <Leader>gd so diffview.nvim's mapping takes effect
      pcall(vim.keymap.del, "n", "<Leader>gd", { buffer = bufnr })
    end
  end,
}
