-- This time around, we'll focus on two plugins to navigate around a lot easier
-- using the `:commands` are frustrating and meh
-- The two plugins we'll install are
--
--    Telescope: A Fuzzy picker with a lot of built in lists to pick from
--      - https://github.com/nvim-telescope/telescope.nvim
--
--    NvimTree: A typical ide tree
--      - https://github.com/nvim-tree/nvim-tree.lua 
--
-- For hopefully the last time, navigate to `e: nvim/lua/plugins.lua`
-- {{{ Settings
-- Choose your fighter...
vim.g.mapleader = ","

vim.cmd("colo tokyonight-storm")

vim.cmd([[filetype plugin indent on]])

vim.o.termguicolors = true
vim.o.backspace = "indent,eol,start"
vim.o.breakindent = true
vim.o.completeopt = "menuone,noselect,menu"
vim.o.concealcursor = ""
vim.o.conceallevel = 2
vim.o.cursorline = true
vim.o.cursorlineopt = "both"
vim.o.expandtab = true
vim.o.fillchars = "fold: ,foldclose: ,foldopen: ,foldsep: ,diff: ,eob: "
vim.o.fixendofline = false
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.formatoptions = "lnjqr"
vim.o.guicursor = ""
vim.o.ignorecase = true
vim.o.inccommand = "split"
vim.o.laststatus = 3
vim.o.linebreak = true
vim.o.mouse = "a"
vim.o.number = true
vim.o.relativenumber = false
vim.o.scrolloff = 10
vim.o.shiftwidth = 0
vim.o.showmode = false
vim.o.signcolumn = "yes:2"
vim.o.smartcase = true
vim.o.spelloptions = "noplainbuffer"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.switchbuf = "useopen"
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.textwidth = 120
vim.o.undodir = vim.fn.expand("~/.cache/nvim/undodir")
vim.o.undofile = true
vim.o.viewoptions = "cursor,folds,slash,unix"
vim.o.wrap = false
vim.o.foldmarker="{{{,}}}"
vim.o.foldmethod="expr"
vim.o.foldexpr="nvim_treesitter#foldexpr()" -- We'll see this later
vim.cmd([[ set foldopen-=block ]])
vim.cmd([[ set foldcolumn=0 ]])  -- Not sure why this doesn't work with `vim.o`
-- }}}
-- {{{ Autocommands
-- Just going to assume you know what autocommands are
-- All you need to know is that it highlights when you're in insert mode
vim.api.nvim_create_augroup("InsertCursor", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter",
    { group = "InsertCursor", command = "hi CursorLine gui=bold,underline", }
)
vim.api.nvim_create_autocmd("InsertLeave",
    { group = "InsertCursor", command = "hi CursorLine gui=NONE", }
)
-- }}}
-- {{{ Keymaps
function setkey(opts)
    key = opts.key 
    cmd = opts.cmd
    mode = opts.mode or "n"
    extra = opts.opts or { noremap = true }
    vim.api.nvim_set_keymap(mode, key, cmd, extra)
end

-- Quick help
setkey({ key="<leader>h", cmd=":vert bo help " })

-- Move to start/end of line
setkey({ key="H", cmd="^" })
setkey({ key="L", cmd="$" })

-- Move up and down a block at a time
setkey("nnoremap <A-k> {")
setkey("nnoremap <A-j> }")

-- Toggle fold
setkey("nnoremap <space> za")

-- Close current buffer
setkey({ key="Q", cmd=":bp<bar>sp<bar>bn<bar>bd<CR>", opts={ noremap = true, silent=true }}) 

-- Cycle buffers
setkey({ key="<Tab>", cmd=":bnext<cr>" })
setkey({ key="<S-Tab>", cmd=":bnext<cr>" })

-- Toggle search highlight
setkey({ key="<leader><space>", cmd=":set hlsearch!<CR>" })

-- Makes search use magic-mode `<leader>h /magic`
setkey({ key="/", cmd="/\\v" })

-- This makes `jk` while in insert/visual/terminal mode act as escape,
-- much easier than reaching for esc, try it out!
setkey({ mode="i", key="jk", cmd="<esc>" })
setkey({ mode="v", key="jk", cmd="<esc>" })
setkey({ mode="t", key="jk", cmd="<c-\\><c-n>" })

-- Just because we sometimes want to toggle these around
setkey({ key="<leader>fmm", cmd=":set foldmethod=marker<CR>" } )
setkey({ key="<leader>fmi", cmd=":set foldmethod=indent<CR>" } )
setkey({ key="<leader>fme", cmd=":set foldmethod=expr<CR>" } )

-- [e]dit [v]imrc
setkey({ key="<leader>ev", cmd=":e $MYVIMRC<CR>" })

-- Only if you're feeling spicy, all hotkeys through the tutorial
-- won't use them
-- setkey({ key="<left>", cmd="<nop>" })
-- setkey({ key="<right>", cmd="<nop>" })
-- setkey({ key="<up>", cmd="<nop>" })
-- setkey({ key="<down>", cmd="<nop>" })
-- }}}
-- {{{ Modules
local plugins = require("plugins").setup(true)
-- }}}
