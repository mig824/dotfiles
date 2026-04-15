-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    features = {
      codelens = true,
      inlay_hints = false,
      semantic_tokens = true,
    },
    formatting = {
      format_on_save = {
        enabled = true,
        allow_filetypes = {
          "go",
        },
      },
      timeout_ms = 1000,
    },
    servers = {},
    ---@diagnostic disable: missing-fields
    config = {},
    autocmds = {
      lsp_codelens_refresh = {
        cond = "textDocument/codeLens",
        {
          event = { "InsertLeave", "BufEnter" },
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
          end,
        },
      },
    },
    mappings = {
      n = {
        grr = {
          function() Snacks.picker.lsp_references() end,
          desc = "References (Snacks)",
          cond = "textDocument/references",
        },
        gri = {
          function() Snacks.picker.lsp_implementations() end,
          desc = "Implementations (Snacks)",
          cond = "textDocument/implementation",
        },
        gd = {
          function() Snacks.picker.lsp_definitions() end,
          desc = "Definitions (Snacks)",
          cond = "textDocument/definition",
        },
        gy = {
          function() Snacks.picker.lsp_type_definitions() end,
          desc = "Type Definitions (Snacks)",
          cond = "textDocument/typeDefinition",
        },
        gO = {
          function() Snacks.picker.lsp_symbols() end,
          desc = "Document Symbols (Snacks)",
          cond = "textDocument/documentSymbol",
        },
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },
  },
}
