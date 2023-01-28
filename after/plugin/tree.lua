vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('nvim-tree').setup({
    hijack_cursor = false
})

vim.keymap.set('n', '<leader>tr', '<cmd>NvimTreeToggle<cr>')
