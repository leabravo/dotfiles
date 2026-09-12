-- Configuración global de diagnósticos (máxima limpieza en pantalla)
vim.diagnostic.config({
  virtual_text = false, -- No llena el final de la línea con texto de error
  underline = true,     -- Subraya el error sutilmente
  signs = true,         -- Muestra el ícono en la columna lateral
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
    focusable = false,
  },
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    -- Completado automático
    vim.lsp.completion.enable(true, client.id, bufnr, {
      autotrigger = true,
      convert = function(item)
        return { abbr = item.label:gsub('%b()', '') }
      end,
    })

    -- Activar Inlay Hints si el servidor lo soporta
    if client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- Mapeos universales de LSP y Diagnósticos
    local opts = { buffer = bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

    -- Alternar Inlay Hints bajo demanda
    vim.keymap.set('n', '<leader>th', function()
      local current = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
      vim.lsp.inlay_hint.enable(not current, { bufnr = bufnr })
    end, { buffer = bufnr, desc = "Toggle Inlay Hints" })
  end,
})

vim.lsp.enable('lua_ls')
vim.lsp.enable('zk_lsp')
vim.lsp.enable('clangd')
vim.lsp.enable('basedpyright')
vim.lsp.enable('gopls')

