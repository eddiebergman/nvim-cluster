local M = {}

function M.setup()
    local config = require("nvim-treesitter.configs")

    require("treesitter-context").setup({
        enable = true,
        mode = "topline",
        zindex = 1,
    })

    config.setup({
        ensure_installed = {
            "lua", "python", "query", "json", "rst", "markdown", "markdown_inline", "diff",
            "gitcommit", "gitignore", "help", "make", "bash", "regex", "toml", "vim", "yaml"
        },
        highlight = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = { init_selection = "<A-l>", node_incremental = "<A-l>", node_decremental = "<A-h>" }
        },
    })
end

return M
