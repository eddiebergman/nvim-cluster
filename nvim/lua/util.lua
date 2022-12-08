local M = {}

function M.setkey(opts)
    vim.validate({
        key = { opts.key, "string" },
        cmd = { opts.cmd, { "string", "function" } },
        mode = { opts.mode, { "string" }, true },
        opts = { opts.opts, { "table" }, true },
    })
    local key = opts.key
    local cmd = opts.cmd
    local mode = opts.mode or "n"
    local extra = opts.opts or { noremap = true }
    vim.api.nvim_set_keymap(mode, key, cmd, extra)
end

-- { name: str, cmd: str | func, key: str | {mode, key} }
function M.command(opts)
    vim.validate({
        name = { opts.name, "string" },
        cmd = { opts.cmd, { "string", "function" } },
        key = { opts.key, { "string", "table" }, true },
    })
    local cmd_opts = opts.opts or {}

    if opts.name:match("%W") and not opts.name:match("^%l") then
        error("Command name must be alphanumeric and start with Captial letter\n" .. vim.inspect(opts))
        return
    end

    vim.api.nvim_create_user_command(opts.name, opts.cmd, cmd_opts)

    if opts.key ~= nil then
        local action = "<cmd>" .. opts.name .. "<cr>"

        local mode = "n"
        local key = opts.key

        -- If key is a table then it includes the mode
        if type(key) == "table" then
            mode = key[1]
            key = key[2]
        end

        M.setkey({ mode = mode, key = key, cmd = action })
    end
end

function M.setsign(opts)
    vim.validate({
        name = { opts.name, "string" },
        sign = { opts.sign, "string" },
        hl = { opts.hl, "string", true }
    })
    vim.fn.sign_define(opts.name, {
        text = opts.sign,
        texthl = opts.hl or opts.name,
        numhl = ""
    })
end

function M.get_python_path(workspace)
    -- Use activated virtualenv.
    local util = require("lspconfig/util")
    local path = util.path

    if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
    end

    if vim.env.CONDA_PYTHON_EXE then
        return vim.env.CONDA_PYTHON_EXE
    end

    -- Find and use virtualenv in workspace directory.
    for _, pattern in ipairs({ "*", ".*" }) do
        local match = vim.fn.glob(path.join(workspace or vim.fn.getcwd(), pattern, "pyvenv.cfg"))
        if match ~= "" then
            return path.join(path.dirname(match), "bin", "python")
        end
    end

    -- Fallback to system Python.
    return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end
-- banana

return M
