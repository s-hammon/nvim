local M = {}

M.setup = function()
  local group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true })

  require("nvim-treesitter").setup({
    ensure_installed = {
      "bash",
      "c",
      "css",
      "diff",
      "dockerfile",
      "go",
      "gomod",
      "gosum",
      "html",
      "javascript",
      "jinja",
      "json",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "sql",
      "toml",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(event)
      local bufnr = event.buf
      local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
      if not ok or not parser then
        return
      end
      pcall(vim.treesitter.start)
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "TSUpdate",
    callback = function()
      local parsers = require("nvim-treesitter.parsers")

      parsers.cram = {
        tier = 0,
        install_info = {
          path = "~/git/tree-sitter-cram",
          files = { "src/parser.c" },
        },
      }

      parsers.reason = {
        tier = 0,
        install_info = {
          url = "https://github.com/reasonml-editor/tree-sitter-reason",
          files = { "src/parser.c", "src/scanner.c" },
          branch = "master",
        },
      }

      parsers.blade = {
        tier = 0,
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = { "src/parsers.c" },
          branch = "main",
        },
        filetype = "blade",
      }
    end,
  })
end

return M
