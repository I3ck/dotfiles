vim.cmd("colorscheme habamax")

vim.cmd("set number")
vim.cmd("set autoindent")
vim.cmd("set splitright")
vim.cmd("set splitbelow")
vim.cmd("set expandtab")
vim.cmd("set smartindent")
vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")

-- Always reserve space for column to avoid movement
vim.opt.signcolumn = "yes"

-- Single key window traversal
vim.keymap.set('n', '<c-j>', '<c-w><c-j>', {noremap = true})
vim.keymap.set('n', '<c-k>', '<c-w><c-k>', {noremap = true})
vim.keymap.set('n', '<c-l>', '<c-w><c-l>', {noremap = true})
vim.keymap.set('n', '<c-h>', '<c-w><c-h>', {noremap = true})
vim.keymap.set('n', '<c-s>', ':vs<cr>', {noremap = true})

vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

vim.lsp.enable('rust_analyzer')
vim.lsp.config('rust_analyzer', {
    settings = {
        ["rust-analyzer"] = {
            rustfmt = {
                extraArgs = { "+nightly", },
            },
        }
    }
})

vim.lsp.enable('elixirls')
vim.lsp.config('elixirls', {
    cmd = { "elixir-ls" };
})

vim.lsp.enable('hls')
vim.lsp.config('hls', {
    filetypes = { 'haskell', 'lhaskell', 'cabal' },
    settings = {
      haskell = {
        completionSnippetsOn = true,
        formattingProvider = 'stylish-haskell',
        cabalFormattingProvider = 'cabalfmt',
      },
   },
})

require('gitsigns').setup()

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<c-p>', builtin.find_files, {})
vim.keymap.set('n', '<c-f>', builtin.live_grep, {})
vim.keymap.set('n', '<c-b>', builtin.buffers, {})
vim.keymap.set('n', '<c-d>', builtin.diagnostics, {})

-- Prevent vim.lsp.completion autotrigger from selecting the first item
vim.opt.completeopt = { "menuone", "noselect", "popup" }

-- LSP rebinds
vim.keymap.set('n', '<space>k', vim.diagnostic.open_float, {})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method('textDocument/implementation') then
      -- Create a keymap for vim.lsp.buf.implementation ...
    end
    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    if client:supports_method('textDocument/completion') then
      -- Trigger autocomplete via most chars (NOT space [32])
      local chars = {}; for i = 33, 126 do table.insert(chars, string.char(i)) end
      client.server_capabilities.completionProvider.triggerCharacters = chars
      vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
    end
    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', {clear=false}),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})
