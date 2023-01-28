require('renda.packer')
require('renda.set')
require('renda.remap')
require('renda.filetype')

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function ()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*'
})
