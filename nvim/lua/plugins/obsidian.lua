return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>of", function() Snacks.picker.files({ dirs = { "~/notes" } }) end, desc = "Find note" },
      { "<leader>os", function() Snacks.picker.grep({ dirs = { "~/notes" } }) end, desc = "Search notes" },
      { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Today's note" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
    },
    opts = {
      workspaces = {
        { name = "notes", path = "~/notes" },
      },
      -- Don't manage frontmatter — keeps notes clean for the Obsidian app on local
      disable_frontmatter = true,
      -- Let render-markdown.nvim handle all UI rendering
      ui = { enable = false },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
}
