require('trouble').setup()

vim.keymap.set('n', '<leader>xx', '<cmd>TroubleToggle<CR>', { silent = true, noremap = true })
