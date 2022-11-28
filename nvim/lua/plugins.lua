-- This is where plugins can be loaded with packer
--
--      https://github.com/wbthomason/packer.nvim
--
-- Using `<leader>fmi` will fold on indent, might make it easier

-- It's worth noting that it's common in neovim setups to define a table (python dict)
-- called M and just add things on to it, returning it at the end of the file
-- Use `G` to have a look with `gg` or `<c-o>` to get back to the top
local M = {}

-- All plugins are going to be located here
-- For now, we are going to just install a theme, and edit our settings to use it 
-- Make sure you set `false` to true in `init.lua`, restart `nvim` and run
--    `:PackerSync`, don't forget about tab complete!
-- You can always run `:Packaer<tab>` and check out `:PackerStatus` to see your installed plugins
-- To remove one, just remove it from here and repeat the same steps

-- To progress, just run ":!git checkout t2"

function plugins(use)
    use 'wbthomason/packer.nvim'

    -- Themes
    -- https://github.com/topics/neovim-colorscheme?o=desc&s=stars
    use 'folke/tokyonight.nvim'
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
