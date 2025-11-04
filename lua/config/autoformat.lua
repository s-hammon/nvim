local setup = function()
  local conform = require("conform")
  conform.setup({
    formatters_by_ft = {
      lua = { "stylua" },
      go = { "gofmt" },
      python = { "ruff" },
    },
  })

  conform.formatters.injected = {
    options = {
      ignore_errors = false,
      lang_to_formatters = {
        sql = { "sleek" },
      },
    },
  }

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("custom-conform", { clear = true }),
    callback = function(event)
      require("conform").format({
        bufnr = event.buf,
        lsp_fallback = true,
        quiet = true,
      })

      if vim.bo.filetype == "go" then
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }

        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
        for cid, res in pairs(result or {}) do
          for _, r in pairs(res.result or {}) do
            if r.edit then
              local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
              vim.lsp.util.apply_workspace_edit(r.edit, enc)
            end
          end
        end
      end
    end,
  })
end

setup()

return { setup = setup }
