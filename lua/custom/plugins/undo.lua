return {
  "debugloop/telescope-undo.nvim",
  dependecies = {
    {
      "nvim-telescope/telescope.nvim",
      dependenciese = { "nvim-lua/plenary.nvim" },
    },
  },
  keys = {
    {
      "<leader>u",
      "<cmd>Telescope undo<cr>",
      desc = "undo history",
    },
  },
  opts = {
    extensions = {
      undo = {
        side_by_side = true,
        layout_strategy = "vertical",
        layout_config = {
          preview_height = 0.8,
        }
      },
    },
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("undo")
  end,
}
