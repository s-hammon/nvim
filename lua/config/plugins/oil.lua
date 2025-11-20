return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      CustomOilBar = function()
        local path = vim.fn.expand("%")
        path = path:gsub("oil://", "")

        return "  " .. vim.fn.fnamemodify(path, ":.")
      end

      local oil = require("oil")

      oil.setup({
        columns = { "icons" },
        keymaps = {
          ["<C-h>"] = false,
          ["<C-l>"] = false,
          ["<C-k>"] = false,
          ["<C-j>"] = false,
          ["<A-h>"] = "actions.select_vsplit",
          ["<S-h>"] = "actions.toggle_hidden",
        },
        win_options = {
          winbar = "%{v:lua.CustomOilBar()}",
        },
        view_options = {
          show_hidden = true,
          is_always_hidden = function(name, _)
            local folder_skip = { "dev-tools.locks", "_build" }
            return vim.tbl_contains(folder_skip, name)
          end,
        },
      })

      -- Open parent directory in current window
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      -- Open parent directory in floating window
      vim.keymap.set("n", "<space>-", oil.toggle_float, { desc = "Open parent dir (floating window)" })
    end,
  },
}
