local M = {}

M.setup = function()
  local group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true })

  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "bash",
      "c",
      "cmake",
      "css",
      "diff",
      "dockerfile",
      "gitignore",
      "go",
      "gomod",
      "gosum",
      "html",
      "javascript",
      "jinja",
      "json",
      "lua",
      "luadoc",
      "make",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "sql",
      "typescript",
      "toml",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<c-space>",
        node_incremental = "<c-space>",
        scope_incremental = "<c-s>",
        node_decremental = "<M-space>",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
    },
  })
end

return M
