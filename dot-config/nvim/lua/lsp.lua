vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
    focusable = false,
  },
})

-- Show floating diagnostics on cursor hold
vim.api.nvim_create_autocmd('CursorHold', {
  desc = "Show diagnostics under cursor on hold",
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    -- Automatic LSP completion
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, bufnr, {
        autotrigger = true,
        convert = function(item)
          return { abbr = item.label:gsub('%b()', '') }
        end,
      })
    end

    -- Enable inlay hints if supported by language server
    if client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- Universal LSP mappings (following native conventions)
    local opts = { buffer = bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)

    -- Manual completion trigger with <C-Space>
    vim.keymap.set('i', '<C-Space>', function()
      vim.lsp.completion.get()
    end, { buffer = bufnr, desc = "Trigger LSP completion" })

    -- Toggle inlay hints on demand
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
