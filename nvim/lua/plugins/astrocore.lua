-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 },
      autopairs = true,
      cmp = true,
      diagnostics = { virtual_text = true, virtual_lines = false },
      highlighturl = true,
      notifications = true,
    },
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    filetypes = {
      extension = {
        pyst = "pyst",
        star = "starlark",
        bzl = "starlark",
      },
      filename = {
        ["BUILD"] = "starlark",
        ["BUILD.in"] = "starlark",
      },
    },
    options = {
      opt = {
        relativenumber = true,
        number = true,
        spell = false,
        signcolumn = "yes",
        wrap = false,
        scrolloff = 12,
        clipboard = "unnamedplus",
        ignorecase = true,
        smartcase = true,
        cursorline = true,
      },
    },
    -- OSC 52 clipboard: only over SSH (devbox → Mac clipboard via Ghostty)
    autocmds = vim.env.SSH_TTY and {
      osc52_clipboard = {
        {
          event = "VimEnter",
          callback = function()
            vim.g.clipboard = {
              name = "OSC 52",
              copy = {
                ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
                ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
              },
              paste = {
                ["+"] = function() return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") } end,
                ["*"] = function() return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") } end,
              },
            }
          end,
        },
      },
    } or {},
    mappings = {
      n = {
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["<Leader>by"] = {
          function()
            local path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
            vim.fn.setreg("+", path)
            vim.notify("Copied: " .. path)
          end,
          desc = "Copy relative path",
        },
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },
        ["<Leader>gd"] = { "<cmd>DiffviewOpen<cr>", desc = "Diff working tree" },
        ["<Leader>gD"] = { "<cmd>DiffviewOpen HEAD~1<cr>", desc = "Diff last commit" },
        ["<Leader>gh"] = { "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
        ["<Leader>gH"] = { "<cmd>DiffviewFileHistory<cr>", desc = "Branch history" },

        -- Keep cursor centered on half-page jumps
        ["<C-d>"] = { "<C-d>zz", desc = "Half page down (centered)" },
        ["<C-u>"] = { "<C-u>zz", desc = "Half page up (centered)" },

        -- Keep cursor centered when cycling search results
        ["n"] = { "nzzzv", desc = "Next search result (centered)" },
        ["N"] = { "Nzzzv", desc = "Prev search result (centered)" },

        -- Join lines without moving cursor
        ["J"] = { "mzJ`z", desc = "Join lines (keep cursor)" },

        -- Clear search highlight with Esc
        ["<Esc>"] = { "<cmd>noh<cr><Esc>", desc = "Clear search highlight" },

        -- Select last pasted text
        ["gp"] = { "`[v`]", desc = "Select last pasted text" },
      },
      v = {
        -- Move selected lines up/down
        ["J"] = { ":m '>+1<CR>gv=gv", desc = "Move selection down" },
        ["K"] = { ":m '<-2<CR>gv=gv", desc = "Move selection up" },

        -- Stay in visual mode after indenting
        ["<"] = { "<gv", desc = "Indent left (keep selection)" },
        [">"] = { ">gv", desc = "Indent right (keep selection)" },
      },
    },
  },
}
