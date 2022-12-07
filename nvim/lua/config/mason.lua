local M = {}

M.lsp_servers = {
    "bashls", -- bash
    "yamlls", -- yaml
    "taplo", -- toml
    "esbonio", -- rst docs
    "marksman", -- markdown
    "sumneko_lua", -- lua
    "pyright", -- python
    "jsonls", -- json
    "clangd", -- c/c++
}

function M.setup()
    require("mason").setup()
    require("mason-lspconfig").setup({ ensure_installed = M.lsp_servers })
end

return M
