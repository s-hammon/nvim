local M = {}

local augroup = vim.api.nvim_create_augroup("AutoFormat", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function(args)
    if vim.b[args.buf].disable_autoformat then
      return
    end

    vim.lsp.buf.format({
      bufnr = args.buf,
      async = false,
      filter = function(client)
        return client.name == "null-ls"
      end,
    })
  end,
})

return M
