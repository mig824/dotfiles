---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      local fortune = vim.fn.exepath("fortune") ~= "" and "fortune" or "/usr/games/fortune"
      local cowsay = vim.fn.exepath("cowsay") ~= "" and "cowsay" or "/usr/games/cowsay"
      local cmd = fortune .. " -s 2>/dev/null | " .. cowsay .. " -f $(" .. cowsay .. " -l | tail -n+2 | tr ' ' '\\n' | shuf -n1) 2>/dev/null"
      local header = vim.fn.system(cmd) or ""
      header = header:gsub("%s+$", "")

      opts.dashboard = {
        preset = {
          header = header,
        },
      }
    end,
  },
}
