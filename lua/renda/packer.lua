local ensure_installed = function ()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_installed()

local packer = require('packer')

packer.init({
    max_jobs = 4,
})

return packer.startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.0',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
	  'rose-pine/neovim',
	  as = 'rose-pine',
  }
  use 'folke/tokyonight.nvim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/playground'
  use 'nvim-lua/plenary.nvim'
  use 'ThePrimeagen/harpoon'
  use 'mbbill/undotree'
  use 'tpope/vim-fugitive'
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'j-hui/fidget.nvim'
  use 'folke/zen-mode.nvim'
  use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons'}
  use 'lukas-reineke/indent-blankline.nvim'
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use {
      'numToStr/Comment.nvim',
      config = function()
          require('Comment').setup()
      end
  }
  use 'nvim-tree/nvim-web-devicons'
  use 'nvim-tree/nvim-tree.lua'
  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
      require("toggleterm").setup()
  end}
  use 'lewis6991/gitsigns.nvim'
  use 'moll/vim-bbye'
  use 'ellisonleao/glow.nvim'
  use {
      "tversteeg/registers.nvim",
      config = function()
          require("registers").setup()
      end,
  }
  use 'NvChad/nvim-colorizer.lua'
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'
  use 'folke/trouble.nvim'
  use 'rest-nvim/rest.nvim'
  use 'mattn/emmet-vim'
  use 'onsails/lspkind.nvim'
  use 'watzon/vim-edge-template'
  use 'wakatime/vim-wakatime'
  use 'mhartington/formatter.nvim'
  use 'nkrkv/nvim-treesitter-rescript'

  if packer_bootstrap then
    packer.sync()
  end
end)
