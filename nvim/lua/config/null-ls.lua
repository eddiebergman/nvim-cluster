local M = {}
local builtins = require("null-ls.builtins")
local diagnostics = builtins.diagnostics
local formatting = builtins.formatting

-- banana

function M.setup()
    require("null-ls").setup({
        debug = true, -- :NullLsLog to get the log if deubg is on
        sources = {
            diagnostics.ruff, -- python linter
            diagnostics.mypy, -- python type checking
            diagnostics.actionlint, -- github action linter
            diagnostics.flake8.with({ -- Flake8 only if `.flake8` found
                condition = function(util) return util.root_has_file({ ".flake8" }) end
            }),
            --diagnostics.commitlint, -- If using commitizen
            --diagnostics.pylint, -- Disabled, enable if you like
            --formatting.isort, -- Disabled, enable if you like
            diagnostics.yamllint, -- yaml linter
            formatting.yamlfmt, -- yaml formatter
            formatting.black, -- python formatter
            formatting.clang_format, -- c/c++ formatter
            formatting.jq, -- json formatter
            formatting.shfmt, -- shell formatter
        },
        temp_dir = "/tmp",
        diagnostics_format = "[#{c}] #{m} (#{s})" -- [code] message (source)
    })

    -- This needs to run last
    -- It will try to autmatically install what it has access to
    require("mason-null-ls").setup({
        ensure_installed = nil,
        automatic_installation = true,
        automatic_setup = true
    })

end

return M
