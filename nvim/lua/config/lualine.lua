local M = {}

function M.setup()
    require("lualine").setup({
        options = {
            ignore_focus = {"NvimTree", "Trouble"}
        }
    })
end

return M
