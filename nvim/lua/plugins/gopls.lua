-- gopls configuration, mirroring Cursor workspace settings.
-- directoryFilters restricts gopls to go/src/dropbox, excluding CGO and
-- heavy packages so it doesn't try to index the entire monorepo.

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    config = {
      gopls = {
        settings = {
          gopls = {
            ["formatting.local"] = "dropbox,godropbox",
            ["ui.diagnostic.staticcheck"] = false,
            ["ui.navigation.importShortcut"] = "Definition",
            ["ui.documentation.linksInHover"] = false,
            ["ui.codelenses"] = {
              generate = true,
              regenerate_cgo = true,
              tidy = false,
              upgrade_dependency = false,
            },
            directoryFilters = {
              "-",
              "-go",
              "+go/src/dropbox",
              "-go/src/dropbox/proto",
              "-go/src/dropbox/alki",
              -- CGO compiled packages
              "-go/src/dropbox/database/mysql",
              "-go/src/dropbox/mp",
              "-go/src/dropbox/search",
              "-go/src/dropbox/fast_rsync",
              "-go/src/dropbox/filesystem",
              "-go/src/dropbox/namespace_view",
              "-go/src/dropbox/traffic",
              "-go/src/dropbox/api_proxy",
              "-go/src/dropbox/util/store/rocksdb",
              "-go/src/dropbox/cputime",
              "-go/src/dropbox/dbxinit/group",
              "-go/src/dropbox/examples/rust_ffi",
              "-go/src/dropbox/ml_platform",
              "-go/src/dropbox/telescope",
              "-go/src/dropbox/coord",
            },
          },
        },
      },
    },
  },
}
