-- The <leader> key to use
vim.g.mapleader = ","

-- Settings, see :help 'setting'
vim.cmd([[filetype plugin indent on]])
vim.o.backspace = "indent,eol,start"
vim.o.breakindent = true
vim.o.completeopt = "menuone,noselect,menu"
vim.o.concealcursor = ""
vim.o.conceallevel = 2
vim.o.cursorlineopt = "number"
vim.o.diffopt = "internal,filler,closeoff,algorithm:patience,linematch:60"
vim.o.expandtab = true
vim.o.fillchars = "fold: ,foldclose:,foldopen:,foldsep: ,diff: ,eob: "
vim.o.fixendofline = false
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
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
vim.o.signcolumn = "yes"
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
