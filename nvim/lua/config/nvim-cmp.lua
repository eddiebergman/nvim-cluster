local self = {}
local cmp = require('cmp')

local function completion(fallback)
    if cmp.visible() then
        cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
    else
        fallback()
    end
end

local kind_icons = {
    Text = "",
    Method = "m",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
}
local cmp_config = {
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end
    },
    mapping = {
        ['<C-e>'] = cmp.mapping.close(),
        ['<A-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
        ['<A-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
        ['<Tab>'] = cmp.mapping(completion),
        ['<CR>'] = cmp.mapping(completion),
    },
    experimental = { ghost_text = true, native_menu = false },
    formatting = {
        fields = { "abbr", "kind" },
        format = function(_, vim_item)
            local icon = kind_icons[vim_item.kind]
            vim_item.kind = string.format("%s %s", icon, vim_item.kind)
            vim_item.dup = 0 -- Remove duplicate entries
            return vim_item
        end,
    },
    sources = cmp.config.sources(
        {
            { name = 'nvim_lsp_signature_help' },
            { name = 'nvim_lsp' },
            { name = 'path' },
            { name = "luasnip" },
        },
        {
            {name = 'buffer' },
        }
    ),

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    sorting = {
        comparators = {
            require("cmp-under-comparator").under,
        }
    }
}

function self.setup()
    cmp.setup(cmp_config)

    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = 'buffer' } }
    })

    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
    })
end

return self
