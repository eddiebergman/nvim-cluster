-- https://github.com/nvim-telescope/telescope.nvim
local M = {}
local telescope = require("telescope")
local util = require("util") -- This is in `lua/util` and just where I'll put utility things
local builtin = require("telescope.builtin")

-- Also type `:Telescope` and `<tab>` to autocomplete and see what else it can do
-- A particularly meta one is `:Telescope builtin` which lets you pick from all the
-- other pickers
local find_file = {
    name = "FindFile",
    cmd = "Telescope find_files",
    key = "<leader>ff",
}
local find_text = {
    name = "FindText",
    cmd = "Telescope live_grep",
    key = "<leader>ft"
}


-- There wont work right, now, I'll remind you once it works
local search_class = {
    name = "SearchClassDoc",
    cmd = function() builtin.lsp_document_symbols({ symbols = { "class" } }) end,
    key = "<leader>sc",
}
local search_func = {
    name = "SearchFuncDoc",
    cmd = function() builtin.lsp_document_symbols({ symbols = { "method", "function" } }) end,
    key = "<leader>sf"
}
local search_symbol = {
    name = "SearchSymbolDoc",
    cmd = "Telescope lsp_document_symbols",
    key = "<leader>ss"
}
local search_reference = {
    name = "SearchBuffer",
    cmd = "Telescope lsp_references",
    key = "<leader>sb"
}

local go_definition = {
    name = "GoDefinition",
    cmd = "Telescope lsp_definitions",
    key = "gd",
}


function M.setup()
    telescope.setup()

    for _, cmd in ipairs(
        {
            find_file, find_text,
            search_class, search_func, search_symbol, search_reference,
            go_definition
        }
    ) do
        util.command(cmd)
    end
end

return M
