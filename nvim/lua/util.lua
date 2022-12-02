local M = {}

function M.setkey(opts)
    local key = opts.key
    local cmd = opts.cmd
    local mode = opts.mode or "n"
    local extra = opts.opts or { noremap = true }
    vim.api.nvim_set_keymap(mode, key, cmd, extra)
end

-- { name: str, cmd: str | func, key: str | {mode, key} }
function M.command(cmd)
    local opts = cmd.opts or {}

    if cmd.name:match("%W") and not cmd.name:match("^%l") then
        error("Command name must be alphanumeric and start with Captial letter\n"..vim.inspect(cmd))
        return
    end

    vim.api.nvim_create_user_command(cmd.name, cmd.cmd, opts)

    if cmd.key ~= nil then
        local action = "<cmd>"..cmd.name.."<cr>"

        local mode = "n"
        local key = cmd.key

        -- If key is a table then it includes the mode
        if type(key) == "table" then
            mode = key[1]
            key = key[2]
        end

        M.setkey({mode=mode, key=key, cmd=action})
    end
end


return M
