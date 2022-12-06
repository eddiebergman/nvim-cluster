local M = {}
local lspconfig = require("lspconfig")
local util = require("util")

local above_below_border = { "▔", "▔", "▔", " ", "▁", "▁", "▁", " " }

function M.setup()
    vim.diagnostic.config({
        virtual_text = { severity = vim.diagnostic.severity.ERROR },
        signs = { severity = { max = vim.diagnostic.severity.WARN } },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
            border = { "▔", "▔", "▔", " ", "▁", "▁", "▁", " " },
            source = "always",
            header = "",
            prefix = "",
        }
    })
    M.show_diagnostics_on_hover()
    M.enable_markdown_highlighting_in_lsp_hover()
    M.custom_signs()


    for _, lsp_setup in ipairs({ M.lua_lsp, M.bash_lsp }) do
        lsp_setup()
    end
end

function M.lua_lsp()
    require("neodev").setup()
    lspconfig.sumneko_lua.setup({})
end

function M.bash_lsp()
    lspconfig.bashls.setup({})
end

function M.show_diagnostics_on_hover()
    vim.api.nvim_create_autocmd(
        "CursorHold",
        { callback = function() vim.diagnostic.open_float() end }
    )
end

function M.enable_markdown_highlighting_in_lsp_hover()
    vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
        local f = vim.lsp.with(vim.lsp.handlers.hover, {
            border = above_below_border,
            stylize_markdown = false
        })
        local floating_bufnr, floating_winnr = f(err, result, ctx, config)
        vim.api.nvim_buf_set_option(floating_bufnr, "filetype", "markdown")
        return floating_bufnr, floating_winnr
    end

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, { border = above_below_border }
    )
end

function M.custom_signs()
    util.setsign({ name = 'DiagnosticSignError', sign = '' })
    util.setsign({ name = 'DiagnosticSignWarn', sign = '' })
    util.setsign({ name = 'DiagnosticSignHint', sign = '' })
    util.setsign({ name = 'DiagnosticSignInfo', sign = '' })
end

return M
