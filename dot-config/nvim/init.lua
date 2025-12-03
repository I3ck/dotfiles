vim.cmd("colorscheme retrobox")

vim.cmd("set number")
vim.cmd("set autoindent")
vim.cmd("set splitright")
vim.cmd("set splitbelow")

-- Single key window traversal
vim.keymap.set('n', '<C-J>', '<C-W><C-J>', {noremap = true})
vim.keymap.set('n', '<C-K>', '<C-W><C-K>', {noremap = true})
vim.keymap.set('n', '<C-L>', '<C-W><C-L>', {noremap = true})
vim.keymap.set('n', '<C-H>', '<C-W><C-H>', {noremap = true})
vim.keymap.set('n', '<C-S>', ':vs<cr>', {noremap = true})

vim.lsp.enable('rust_analyzer')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-P>', builtin.find_files, {})
vim.keymap.set('n', '<C-F>', builtin.live_grep, {})
vim.keymap.set('n', '<C-B>', builtin.buffers, {})
