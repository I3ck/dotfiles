vim.cmd("colorscheme retrobox")

vim.cmd("set number")
vim.cmd("set autoindent")

-- Set space to be <leader> key
vim.cmd("nnoremap <SPACE> <Nop>")
vim.cmd("let mapleader=\" \"")


local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>p', builtin.find_files, {})
vim.keymap.set('n', '<leader>f', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
