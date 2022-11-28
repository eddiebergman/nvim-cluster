local M = {}

function plugins(use)
    use 'wbthomason/packer.nvim'

    -- https://github.com/topics/neovim-colorscheme?o=desc&s=stars
    use 'folke/tokyonight.nvim'


    -- Just press x three times on the start of each comment to uncomment each of these
    -- Plugins can have dependancies (`requires`) and `config` which is a file loaded that
    -- for the plugin.
    -- use {
    --     'nvim-telescope/telescope.nvim',
    --      requires = { 'nvim-lua/plenary.nvim', { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' } },
    --      config = function() require('config/telescope').setup(true) end
    -- }
 
    -- use {
    --     'kyazdani42/nvim-tree.lua',
    --     requires = "kyazdani42/nvim-web-devicons",
    --     config = function() require("config/nvim-tree").setup(true) end
    -- }
end

function M.setup(active)
    if not active then
        return
    end
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