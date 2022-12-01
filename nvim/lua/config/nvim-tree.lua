local M = {}

-- https://github.com/nvim-tree/nvim-tree.lua
-- This plugin is for the tree-view which I have mapped to <C-h> since it bumps
-- out from the left
-- Try it out
--
--  <C-h> - Expand tree
--  j / k to move up and down
--  l to expand node or open if file
--  h to collapse section
--  L to open but stay in tree
--  H to collapse all
--  a add a file (end it with a / to/make/a/directory/)
--  https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#h-j-k-l-style-navigation-and-editing

-- If configuring this again, check out their dispatcher and follow what they
-- do to figure it out
local util = require("util")
local lib = require("nvim-tree.lib")
local view = require("nvim-tree.view")


local function edit_or_open()
    -- open as vsplit on current node
    local action = "edit"
    local node = lib.get_node_at_cursor()

    -- Just copy what's done normally with vsplit
    if node.link_to and not node.nodes then
        require('nvim-tree.actions.node.open-file').fn(action, node.link_to)
        view.close() -- Close the tree if file was opened

    elseif node.nodes ~= nil then
        lib.expand_or_collapse(node)

    else
        require('nvim-tree.actions.node.open-file').fn(action, node.absolute_path)
        view.close() -- Close the tree if file was opened
    end

end

local function vsplit_preview()
    -- open as vsplit on current node
    local action = "vsplit"
    local node = lib.get_node_at_cursor()

    -- Just copy what's done normally with vsplit
    if node.link_to and not node.nodes then
        require('nvim-tree.actions.node.open-file').fn(action, node.link_to)

    elseif node.nodes ~= nil then
        lib.expand_or_collapse(node)

    else
        require('nvim-tree.actions.node.open-file').fn(action, node.absolute_path)

    end

    -- Finally refocus on tree if it was lost
    view.focus()
end

--
-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
local config = {
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = false,
    ignore_ft_on_setup = {},
    open_on_tab = false,
    hijack_cursor = true,
    sync_root_with_cwd = true,
    diagnostics = {
        enable = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        }
    },
    update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {}
    },
    system_open = {
        cmd  = nil,
        args = {}
    },
    filters = {
        dotfiles = false,
        custom = {}
    },
    git = {
        enable = true,
        ignore = true,
        timeout = 500,
    },
    renderer = {
        highlight_opened_files = "name",
        icons = {
            show = {
                git = false,
                folder = true,
                folder_arrow = false,
                file = true,
            },
            glyphs = {
                folder = {
                    default = "",
                    open = "",
                }
            }
        }
    },
    view = {
        width = 30,
        hide_root_folder = true,
        side = 'left',
        mappings = {
            custom_only = false,
            list = {
                { key = "l", action = "edit", action_cb = edit_or_open },
                { key = "L", action = "vsplit_preview", action_cb = vsplit_preview },
                { key = "h", action = "close_node" },
                { key = "H", action = "collapse_all" },
                { key = "t", action = "toggle_git_ignored" }
            }
        },
        number = false,
        relativenumber = false,
        signcolumn = "yes"
    },
    trash = {
        cmd = "trash",
        require_confirm = true
    },
    actions = {
        open_file = {
            quit_on_open = false,
            window_picker = { enable = false, }
        }
    }
}

local toggle_tree = {
    name = "ToggleTree",
    cmd = "NvimTreeToggle",
    key = "<C-h>",
}

function M.setup(active)
    if not active then
        return
    end
    require('nvim-tree').setup(config)
    util.command(toggle_tree)

    vim.cmd([[
        autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
    ]])

end

return M

