vim.cmd("colorscheme retrobox")

vim.cmd("set number")
vim.cmd("set autoindent")
vim.cmd("set splitright")
vim.cmd("set splitbelow")

-- Set space to be <leader> key
vim.cmd("nnoremap <space> <nop>")
vim.cmd("let mapleader=\" \"")

-- Single key window traversal
vim.keymap.set('n', '<leader>j', '<C-W><C-J>', {noremap = true})
vim.keymap.set('n', '<leader>k', '<C-W><C-K>', {noremap = true})
vim.keymap.set('n', '<leader>l', '<C-W><C-L>', {noremap = true})
vim.keymap.set('n', '<leader>h', '<C-W><C-H>', {noremap = true})
vim.keymap.set('n', '<leader>s', ':vs<cr>', {noremap = true})

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

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>p', builtin.find_files, {})
vim.keymap.set('n', '<leader>f', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>d', builtin.diagnostics, {})

-- Prevent vim.lsp.completion autotrigger from selecting the first item
vim.opt.completeopt = { "menuone", "noselect", "popup" }

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method('textDocument/implementation') then
      -- Create a keymap for vim.lsp.buf.implementation ...
    end
    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    if client:supports_method('textDocument/completion') then
      -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      -- client.server_capabilities.completionProvider.triggerCharacters = chars
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
