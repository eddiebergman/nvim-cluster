local M = {}

local function plugins(use)
    use('wbthomason/packer.nvim')

    -- https://github.com/topics/neovim-colorscheme?o=desc&s=stars
    use('folke/tokyonight.nvim')

    -- Mason
    -- Easy setup of many language specific tools and LSP servers to give "smarts" to the editor
    use({
        "williamboman/mason.nvim",
        requires = { "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
        config = function() require("config/mason").setup() end
    })

    -- Telescope 
    -- The popup window that lets you select files
    use({
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
        },
        config = function() require('config/telescope').setup() end
    })
 
    -- Nvim tree
    -- The side tree view
    use({
        'kyazdani42/nvim-tree.lua',
        requires = "kyazdani42/nvim-web-devicons",
        config = function() require("config/nvim-tree").setup() end
    })

    -- Neodev
    -- Editor smartness when editing your nvim files
    use("folke/neodev.nvim")

    -- Trouble
    -- A nice diagnostics and sidepane that goes well with Telescope
    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
    })


    -- Bufferline
    -- Just a nice looking bufferline
    use("akinsho/bufferline.nvim")

    -- Lualine
    -- Just a nice looking tabline
    use("nvim-lualine/lualine.nvim")

    -- Gitsigns
    -- Nice git utilities for changes to a file
    use("lewis6991/gitsigns.nvim")

    -- Neogen
    -- Document generator
    use("danymat/neogen")

    -- Ident-Blankline
    -- Gives the indent lines
    use("lukas-reineke/indent-blankline.nvim")

    -- Null-ls
    -- Allows linters/checkers/tools to hook into neovims lsp system
    -- I.e. pylint, flake8, black ...
    use("jose-elias-alvarez/null-ls.nvim")

    -- Completion
    -- Suggestions as you type
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp", -- For LSP completions
            "hrsh7th/cmp-buffer", -- For buffer content completion
            "hrsh7th/cmp-path", -- For path completion
            "lukas-reineke/cmp-under-comparator",  -- Deprioritize double underscore in python
            "windwp/nvim-autopairs", -- Autopair brackets on function completion
            "hrsh7th/cmp-nvim-lsp-signature-help", -- Signature help as you fill in functions
        }
    })

    -- Treesitter
    -- Language aware syntax tree and associated plugins
    use({
        "nvim-treesitter/nvim-treesitter",
        requires = {
            "nvim-treesitter/nvim-treesitter-refactor",
            "RRethy/nvim-treesitter-textsubjects",
            "nvim-treesitter/nvim-treesitter-context",
            {
                "eddiebergman/nvim-treesitter-pyfold",
                ft = { "python" }
            },
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function() require("config/treesitter").setup() end,
        run = ":TSUpdate"
    })

    -- Luapad
    -- Lets you quickly try out some Lua
    use("rafcamlet/nvim-luapad")

    -- Git integration
    -- Must have
    use("tpope/vim-fugitive")

    -- Surround text
    -- `ys<motion><surround-symbol>`
    -- i.e. `ysiw"`  - YankSelect inside word " - will surround current word with ""
    use("tpope/vim-surround")

    -- Smarter repeats with `.`
    use("tpope/vim-repeat")

    -- Autoclose brackets
    use("townk/vim-autoclose")
end

function M.setup()
    M.ensure_installed()
    require("packer").startup(plugins)
end


function M.ensure_installed()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
      fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
      vim.cmd [[packadd packer.nvim]]
      return true
    end
    return false
end

function M.autocompile()
    -- Recompile the plugins file upon write
    vim.cmd([[
        augroup packer_user_config
          autocmd!
          autocmd BufWritePost plugins.lua source <afile> | PackerCompile
        augroup end
    ]])
end

return M
