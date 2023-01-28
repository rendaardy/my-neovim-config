require('mason').setup()

local mason_lspconfig = require('mason-lspconfig')
local lspconfig = require('lspconfig')
local luasnip = require('luasnip')
local cmp = require('cmp')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

cmp.setup({
    enabled = function()
        local context = require('cmp.config.context')
        if vim.api.nvim_get_mode().mode == 'c' then
            return true
        else
            return not context.in_treesitter_capture('comment')
                and not context.in_syntax_group('Comment')
        end
    end,
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' })
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    }),
    formatting = {
        format = function(entry, vim_item)
            if vim.tbl_contains({ 'path' }, entry.source.name) then
                local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
                if icon then
                    vim_item.kind = icon
                    vim_item.kind_hl_group = hl_group
                    return vim_item
                end
            end
            return require('lspkind').cmp_format({ with_text = false })(entry, vim_item)
        end
    }
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local on_attach = function(client, buffer)
	local opts = { buffer = buffer, remap = false }

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', '<leader>ws', vim.lsp.buf.workspace_symbol, opts)
	vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '[d', vim.diagnostic.goto_next, opts)
	vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, opts)
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
	vim.keymap.set('n', '<leader>rr', vim.lsp.buf.references, opts)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
	vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
end

mason_lspconfig.setup({
    ensure_installed = {
        'tsserver',
        'denols',
        'sumneko_lua',
        'rust_analyzer',
    }
})

mason_lspconfig.setup_handlers({
    function(server_name)
        if server_name == 'tsserver' then
            lspconfig[server_name].setup({
                on_attach = on_attach,
                capabilities = capabilities,
                single_file_support = false,
                root_dir = lspconfig.util.root_pattern('package.json'),
                settings = {
                    javascript = {
                        inlayHints = {
                            includeInlayEnumMemberValueHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayVariableTypeHints = true,
                        },
                    },
                    typescript = {
                        inlayHints = {
                            includeInlayEnumMemberValueHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayVariableTypeHints = true,
                        },
                    },
                },
            })
        elseif server_name == 'denols' then
            lspconfig[server_name].setup({
                on_attach = on_attach,
                capabilities = capabilities,
                single_file_support = false,
                root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),
            })
        elseif server_name == 'rust_analyzer' then
            lspconfig[server_name].setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    ['rust-analyzer'] = {
                        checkOnSave = {
                            command = 'clippy'
                        },
                        cachePriming = {
                            numThreads = 1
                        }
                    }
                }
            })
        elseif server_name == 'sumneko_lua' then
            lspconfig[server_name].setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    }
                }
            })
        elseif server_name == 'html' then
            lspconfig[server_name].setup({
                on_attach = on_attach,
                capabilities = capabilities,
                filetypes = {'html'},
            })
        elseif server_name == 'cssls' then
            lspconfig[server_name].setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
        elseif server_name == 'jsonls' then
            lspconfig[server_name].setup({
                on_attach = on_attach,
                capabilities = capabilities,
                commands = {
                    Format = {
                        function()
                            vim.lsp.buf_range_formatting({}, {0,0}, {vim.fn.line('$'),0})
                        end
                    }
                },
            })
        else
            lspconfig[server_name].setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
        end
    end,
})

vim.diagnostic.config({
    virtual_text = true,
})

-- deno specific
vim.g.markdown_fenced_languages = { 'ts=typescript' }
