return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", config = true },
      "mason-org/mason-lspconfig.nvim",
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      "b0o/SchemaStore.nvim",
      {
        "j-hui/fidget.nvim",
        opts = {
          notification = {
            window = {
              winblend = 0,
            },
          },
        },
      },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          local builtin = require("telescope.builtin")
          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Rename variable
          map("grn", vim.lsp.buf.rename, "[R]ename")
          -- Execute code action
          map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
          -- Find references
          map("grr", builtin.lsp_references, "[G]oto [R]eferences")
          -- Jump to implementation
          map("gri", builtin.lsp_implementations, "[G]oto [I]mplementation")
          -- Jump to definition
          map("grd", builtin.lsp_definitions, "[G]oto [D]efinition")
          -- Jump to type
          map("grt", builtin.lsp_type_definitions, "[G]oto [T]ype Definition")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method("textDocument/documentHighlight") then
            local hl = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = hl,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = hl,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              buffer = event.buf,
              callback = function()
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = hl, buffer = event.buf })
              end,
            })
          end

          if client and client:supports_method("textDocument/inlayHint") then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

      local servers = {
        bashls = {},
        gopls = {
          manual_install = true,
          settings = {
            gopls = {
              completeUnimported = true,
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = "Replace" },
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
              },
              diagnostics = {
                globals = { "vim" },
                disable = { "missing-fields" },
              },
              format = { enable = false },
            },
          },
        },
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                mccabe = { enabled = false },
                pylsp_mypy = { enabled = false },
                pylsp_black = { enabled = false },
                pylsp_isort = { enabled = false },
                pylint = { enabled = false },
                flake8 = { enabled = false },
                pydocstyle = { enabled = false },
              },
            },
          },
        },
        ruff = {},
        jsonls = {
          server_capabilities = {
            documentFormattingProvider = false,
          },
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemaStore = { enable = false, url = "" },
            },
          },
        },
        html = { filetypes = { "html" } },
        dockerls = {},
        clangd = {},
      }

      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
        handlers = {
          function(server)
            local config = servers[server] or {}
            config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
            require("lspconfig")[server].setup(config)
          end,
        },
      })

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", soruce = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        } or {},
        virtual_text = {
          source = "if_many",
          spacing = 2,
        },
      })
    end,
  },
}
