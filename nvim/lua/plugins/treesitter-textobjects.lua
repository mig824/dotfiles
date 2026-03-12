---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "BufRead",
  config = function()
    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = { ["]m"] = "@function.outer", ["]a"] = "@parameter.outer" },
          goto_previous_start = { ["[m"] = "@function.outer", ["[a"] = "@parameter.outer" },
          goto_next_end = { ["]M"] = "@function.outer" },
          goto_previous_end = { ["[M"] = "@function.outer" },
        },
        swap = {
          enable = true,
          swap_next = { ["<Leader>a"] = "@parameter.inner" },
          swap_previous = { ["<Leader>A"] = "@parameter.inner" },
        },
      },
    })
  end,
}
