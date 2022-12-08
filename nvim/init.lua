-- {{{ Settings
-- Choose your fighter...
vim.g.mapleader = ","

-- This is automatically generated, this should not be set to the virtual
-- env and instead to a specifically set up environment for nvim to run in
-- It's also crucial to the installer that this is on line 8, lol
vim.g.python3_host_prog = '/home/bergmane/nvim/.nvim-python-venv/bin/python'

vim.cmd([[
    try
        colo tokyonight-storm
    catch
	    colo default
]])

if vim.env.VIRTUAL_ENV == nil and vim.env.CONDA_PYTHON_EXE then
    vim.env.VIRTUAL_ENV = vim.env.CONDA_PYTHON_EXE
end

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
vim.o.signcolumn = "yes:1"
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.autoindent = true
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
vim.o.foldmarker = "{{{,}}}"
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 99
vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldenable = false
vim.o.showtabline = 0
vim.cmd([[ set foldopen-=block ]])
vim.cmd([[ set foldcolumn=0 ]]) -- Not sure why this doesn't work with `vim.o`

local setsign = require("util").setsign
setsign({ name = 'DiagnosticSignError', sign = '' })
setsign({ name = 'DiagnosticSignWarn', sign = '' })
setsign({ name = 'DiagnosticSignHint', sign = '' })
setsign({ name = 'DiagnosticSignInfo', sign = '' })

-- }}}
-- {{{ Misc
-- Needs to go before any plugins are loaded Unfortunatly
vim.cmd([[ highlight Folded gui=italic guibg=NONE ]])
-- }}}
-- {{{ Modules
require("plugins").setup() -- Keep this first
require("lsp").setup()
-- }}}
-- {{{ Keymaps
local setkey = require("util").setkey
local command = require("util").command

-- Quick help
setkey({ key = "<leader>h", cmd = ":Telescope help_tags<cr>" })

-- Move to start/end of line
setkey({ key = "H", cmd = "^" })
setkey({ key = "L", cmd = "$" })

-- Move up and down a block at a time
setkey({ key = "<A-k>", cmd = "{" })
setkey({ key = "<A-j>", cmd = "}" })

-- Smart selection <A-l>, <A-h>
-- Unfortunatly this has to be done in `config/treesitter`

-- Toggle fold
setkey({ key = "<space>", cmd = "za" })

-- Close current buffer
setkey({ key = "Q", cmd = ":bp<bar>sp<bar>bn<bar>bd<CR>", opts = { noremap = true, silent = true } })

-- Cycle buffers
setkey({ key = "<Tab>", cmd = ":bnext<cr>" })
setkey({ key = "<S-Tab>", cmd = ":bnext<cr>" })

-- Toggle search highlight
setkey({ key = "<leader><space>", cmd = ":set hlsearch!<CR>" })

-- Makes search use magic-mode `<leader>h /magic`
setkey({ key = "/", cmd = "/\\v" })

-- This makes `jk` while in insert/visual/terminal mode act as escape,
-- much easier than reaching for esc, try it out!
setkey({ mode = "i", key = "jk", cmd = "<esc>" })
setkey({ mode = "v", key = "jk", cmd = "<esc>" })
setkey({ mode = "t", key = "jk", cmd = "<c-\\><c-n>" })

-- Just because we sometimes want to toggle these around
setkey({ key = "<leader>fmm", cmd = ":set foldmethod=marker<CR>" })
setkey({ key = "<leader>fmi", cmd = ":set foldmethod=indent<CR>" })
setkey({ key = "<leader>fme", cmd = ":set foldmethod=expr<CR>" })

-- Only if you're feeling spicy
-- setkey({ key="<left>", cmd="<nop>" })
-- setkey({ key="<right>", cmd="<nop>" })
-- setkey({ key="<up>", cmd="<nop>" })
-- setkey({ key="<down>", cmd="<nop>" })

-- Toggle file explorer, I use Ctrl+h because it's a window that pops out of the left
command({ key = "<C-h>", name = "ToggleTree", cmd = "NvimTreeToggle", })

-- [e]dit [v]imrc
command({ key = "<leader>ev", name = "VIMRC", cmd = "e $MYVIMRC" })

-- Find Things
-- Find an open buffer (This hotkey just comes from pycharm)
command({ key = "<C-e>", name = "FindBuffer", cmd = "Telescope buffers", })
-- Find a file with fuzzy find (Ctrl+P was a vanilla vim plugin, the hotkey stuck)
command({ key = "<C-p>", name = "FindFile", cmd = "Telescope find_files", })
-- [s]earch [s]tring
command({ key = "<leader>ss", name = "FindString", cmd = "Telescope live_grep", })
-- Find a command
command({ key = "<C-f>", name = "FindCommand", cmd = "Telescope commands" } )



-- Diagnostics
-- Jump to next
command({ key = "<c-space>", name = "NextDiagnostic", cmd = "lua vim.diagnostic.goto_next()" })
-- [s]how [e]rror on current line
command({ key = "se", name = "LineErrors", cmd = "lua vim.diagnostic.open_float()", })
-- Ctrl + [D]iagnostics
command({ key = "<C-d>", name = "DiagnosticsList", cmd = "TroubleToggle", })

-- Language smarts
-- Ctrl + [F]ormat
command({ key = "<C-f>", name = "Format", cmd = "lua vim.lsp.buf.format()" })
-- [r]ename (only on current buffer)
command({ key = "<leader>r", name = "Rename", cmd = "lua vim.lsp.buf.rename()", })
-- [s]how [d]efinition
command({ key = "sd", name = "Definition", cmd = "lua vim.lsp.buf.hover()", })
-- [g]o [d]efinition
command({ key = "gd", name = "GoDefinition", cmd = "Telescope lsp_definitions", })
-- Alt + Enter (CodeActions is not as good as pycharm right now)
command({ key = "<A-cr>", name = "CodeActions", cmd = "lua vim.lsp.buf.code_action()", })
-- Find a symbol (may consider `lsp_document_symbols`)
command({ key = "<leader>S", name = "SearchSymbolDoc", cmd = "Telescope lsp_workspace_symbols", })

-- Git
command({ key = "<leader>gs", name = "GitStatus", cmd = "vertical bo Git" })
command({ key = "<leader>gl", name = "GitLog", cmd = "vsp | GcLog" })
command({ key = "<leader>gc", name = "GitCommit", cmd = "Git commit" })
command({ key = "<leader>gp", name = "GitPush", cmd = "Git push" })
command({ key = "ga", name = "GitAddHunk", cmd = "Gitsigns stage_hunk" })
command({ key = "gr", name = "GitResetHunk", cmd = "Gitsigns reset_hunk" })
command({ key = "gu", name = "GitUndoHunk", cmd = "Gitsigns undo_stage_hunk" })
command({ key = "gp", name = "GitPreviewHunk", cmd = "Gitsigns preview_hunk" })
command({ key = "gA", name = "GitAddFile", cmd = "Gitsigns stage_buffer" })

-- See who commited what!
command({ key = "<leader>tb", name = "ToggleBlameGit", cmd = "Gitsigns toggle_current_line_blame" })
command({ key = "<leader>td", name = "ToggleDeletedGit", cmd = "Gitsigns toggle_deleted" })
command({ key = "<leader>tl", name = "ToggleLineGit", cmd = "Gitsigns toggle_linehl" })
-- command({ key = "gR", name = "GitResetFile", cmd = "Gitsigns reset_buffer" }) -- careful
command({ key = "gA", name = "GitAddFile", cmd = "Gitsigns stage_buffer" })
command({ key = "gA", name = "GitAddFile", cmd = "Gitsigns stage_buffer" })
command({ key = "gA", name = "GitAddFile", cmd = "Gitsigns stage_buffer" })

-- }}}
-- {{{ Autocommands
-- Just going to assume you know what autocommands are
-- All you need to know is that it highlights when you're in insert mode
vim.api.nvim_create_augroup("UserCommands", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter",
    { group = "UserCommands", command = "hi CursorLine gui=bold", }
)
vim.api.nvim_create_autocmd("InsertLeave",
    { group = "UserCommands", command = "hi CursorLine gui=NONE", }
)
-- }}}
--
-- vim:foldmethod=marker
