return {
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = "<Up> ",
          Down = "<Down> ",
          Left = "<Left> ",
          Right = "<Right> ",
        },
      },
      spec = {
        { "<leader>s", icon = { icon = "🔍", color = "green" }, group = "[S]earch" },
        { "<leader>t", icon = { icon = "", color = "green" }, group = "[T]erminal" },
        { "<leader><space>", group = "More..." },
      },
    },
  }
}
