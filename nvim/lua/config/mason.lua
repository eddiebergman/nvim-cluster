local M = {}

function M.setup()
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = {
            "sumneko_lua",
            "pyright",
        }
    })
end

return M
