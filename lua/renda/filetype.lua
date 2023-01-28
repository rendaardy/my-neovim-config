vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
    pattern = '*.ejs',
    command = 'set filetype=html',
})

-- vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
--     pattern = '*.edge',
--     command = 'set filetype=html',
-- })
