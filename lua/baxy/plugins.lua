-- This file can be loaded by calling `lua require('plugins')` from your init.vim
--            highlights["@variable"] ={fg="" Only required if you have packer configured as `opt`
vim.g.mapleader = " "
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath })
end

vim.opt.rtp:prepend(lazypath)

local ok, lazy = pcall(require, "lazy")
if not ok then return end
local opts = {}
lazy.setup({

    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("config.which-key")
        end
    },
    "b0o/SchemaStore.nvim",
    { "folke/neoconf.nvim",      cmd = "Neoconf" },
    "folke/neodev.nvim",
    "stevearc/aerial.nvim",
    "mfussenegger/nvim-jdtls",
    {
        'nvim-treesitter/nvim-treesitter',
        event = "BufEnter",
        config = function()
            require('config.treesitter')
        end
    },
    'nvim-treesitter/playground',
    'theprimeagen/harpoon',
    'mbbill/undotree',
    'tpope/vim-fugitive',
    'BurntSushi/ripgrep',
            -- LSP Support
            'neovim/nvim-lspconfig',             -- Required
            'williamboman/mason.nvim',           -- Optional
            'williamboman/mason-lspconfig.nvim', -- Optional

            -- Autocompletion
            "onsails/lspkind.nvim",
    {'hrsh7th/nvim-cmp',
        event = "BufRead",
        config = function()
            require("config.lsp-dap")
        end},
            'hrsh7th/cmp-nvim-lsp',     -- Required
            'hrsh7th/cmp-buffer',       -- Optional
            'hrsh7th/cmp-path',         -- Optional
            'saadparwaiz1/cmp_luasnip', -- Optional
            'hrsh7th/cmp-nvim-lua',     -- Optional
            'jose-elias-alvarez/null-ls.nvim',


            -- Snippets
            'L3MON4D3/LuaSnip',             -- Required
            'rafamadriz/friendly-snippets', -- Optional
            "hrsh7th/cmp-nvim-lsp-signature-help",
    "timonv/vim-cargo",
    {
        'rose-pine/neovim',
        config = function()
            require('config.colorscheme')
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        version = "*",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim" },
        lazy = true
    },
    'stevearc/aerial.nvim',
    { 'akinsho/bufferline.nvim', version = "*" },
    { 'akinsho/toggleterm.nvim', version = '*',  config = true },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        }
    },
    {
        'roobert/surround-ui.nvim',
        config = function()
            require('surround-ui').setup({ root_key = "S" })
        end
    },
    {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup({})
        end
    },
    { "nvim-telescope/telescope-ui-select.nvim",     event = "BufEnter" },
    { "lewis6991/gitsigns.nvim",                     config = true,     event = "BufEnter" },
    { "nvim-treesitter/nvim-treesitter-textobjects", event = "BufEnter" },

    {
        "karb94/neoscroll.nvim",
        event = "BufEnter",
        enabled = true
    },
    {
        "glepnir/lspsaga.nvim",
        branch = "main",
        event = "BufRead",
        config = function()
            require('lspsaga').setup({})
        end
    },
    'nvim-treesitter/nvim-treesitter-context',

    {
        'glepnir/dashboard-nvim',
        event = 'VimEnter',
        config = function()
            require('config.dashboard')
        end,
        lazy = false
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        lazy = true
    },
    {
        'ggandor/leap.nvim',
        config = function()
            require("config.leap")
        end,
        depedencies = { "tpope/vim-repeat" }
    },
    "ravenxrz/DAPInstall.nvim",
    "mfussenegger/nvim-dap-python",
    "Pocco81/dap-buddy.nvim",
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "leoluz/nvim-dap-go",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-telescope/telescope-dap.nvim"
        },
        event = "BufEnter",
        config = function()
            require("config.dap").setup()
        end
    },
    { "jbyuki/one-small-step-for-vimkind", module = "osv" },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufEnter",
        config = function()
            require("config.indentbl")
        end
    },
    'kdheepak/lazygit.nvim',
    {
        'simrat39/rust-tools.nvim',
    },
    {
        "simrat39/inlay-hints.nvim",
        config = function()
            require("config.inlay-hints")
        end
    },
    {
        "rust-lang/rust.vim",
        ft = "rust",
        init = function()
            vim.g.rustfmt_autosave = 1
        end
    },
    -- Lua
    {
        "olimorris/persisted.nvim",
        config = true
    },
}, opts)

vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
