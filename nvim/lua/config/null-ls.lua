local M = {}
local builtins = require("null-ls.builtins")
local diagnostics = builtins.diagnostics
local formatting = builtins.formatting
local helpers = require("null-ls.helpers")
local methods = require("null-ls.methods")
local util = require("util")

function M.find_local(language)
    if language == "python" then
        -- Will attempt to find your python env using VirtualEnv, Conda or virtual env patterns
        local python_env = util.python_env({ patterns = { "venv", ".venv", "env", ".env" } })
        if not python_env then
            return nil
        end

        local rootdir = util.lsp_root({
            ".git", "setup.py", "requirements.txt", "poetry.lock", "Pipfile", "Pipfile.lock",
            "pyproject.toml", "setup.cfg", "tox.ini", "mypy.ini", "pylintrc",
        })
        if rootdir == nil then
            return nil
        end
        return python_env.bindir:gsub(rootdir, "")
    end
end

local ruff_fix = helpers.make_builtin({
    name = "ruff",
    meta = {
        url = "https://github.com/charliermarsh/ruff/",
        description = "An extremely fast Python linter, written in Rust.",
    },
    method = methods.internal.FORMATTING,
    filetypes = { "python" },
    generator_opts = {
        command = "ruff",
        args = { "--fix", "-e", "-n", "--stdin-filename", "$FILENAME", "-" },
        to_stdin = true
    },
    factory = helpers.formatter_factory
})

function M.setup()
    local python = M.find_local("python")

    require("null-ls").setup({
        debug = true, -- :NullLsLog to get the log if deubg is on
        sources = {
            diagnostics.ruff.with({ prefer_local = python }), -- python linter
            ruff_fix.with({ prefer_local = python }), -- python formatting with ruff
            diagnostics.mypy.with({ prefer_local = python }), -- python type checking
            formatting.black.with({ prefer_local = python }), -- python formatter
            diagnostics.flake8.with({ -- Flake8 only if `.flake8` found
                prefer_local = python,
                condition = function(u) return u.root_has_file({ ".flake8" }) end,
            }),
            --diagnostics.pylint.with({ prefer_local = local_binary_dir}), -- Disabled, enable if you like
            --formatting.isort.with({ prefer_local = local_binary_dir}), -- Disabled, enable if you like
            --diagnostics.commitlint, -- If using commitizen
            diagnostics.actionlint, -- github action linter
            formatting.yamlfmt, -- yaml formatter
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
