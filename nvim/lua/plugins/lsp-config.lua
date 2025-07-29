return {
  {
    "mason-org/mason.nvim",
    opts = {}
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "lua_ls", "ts_ls" },
    },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      local on_attach = function(client, bufnr)
        local buf_set_keymap = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

--        buf_set_keymap("n", "gd", vim.lsp.buf.definition, "[LSP] Go to definition")
--        buf_set_keymap("n", "gr", vim.lsp.buf.references, "[LSP] List references")
        buf_set_keymap("n", "K", vim.lsp.buf.hover, "[LSP] Hover documentation")
--        buf_set_keymap("n", "<C-k>", vim.lsp.buf.signature_help, "[LSP] Signature help")
        buf_set_keymap("n", "<leader>rn", vim.lsp.buf.rename, "[LSP] Rename symbol")
        buf_set_keymap("n", "<leader>ca", vim.lsp.buf.code_action, "[LSP] Code action")
        buf_set_keymap("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, "[LSP] Format file")
      end

      lspconfig.lua_ls.setup({
        on_attach = on_attach,
      })
       lspconfig.ts_ls.setup({
        on_attach = on_attach,
      })
    end
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
            }
          }
        }
      }
      require("telescope").load_extension("ui-select")
    end
  }
}
