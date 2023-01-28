require('zen-mode').setup({
    window = {
        width = 120,
        options = {
            number = true,
            relativenumber = true,
        }
    }
})

vim.keymap.set('n', '<leader>zen', function()
    require('zen-mode').toggle()
    vim.wo.wrap = false
    ColorMyPencils('tokyonight-night')
end)
