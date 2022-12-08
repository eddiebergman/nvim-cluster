-- {{{ Settings
-- Find the `Hi` below to start

-- This is automatically generated, this should not be set to the virtual
-- env and instead to a specifically set up environment for nvim to run in
-- It's also crucial to the installer that this is on line 8, lol
vim.g.python3_host_prog = '/home/bergmane/nvim/.nvim-python-venv/bin/python'


-- Hi,
-- I assume you know some basic vim. If you manage to leave this and can't find
-- your way back, type `:echo %` to check the file we're in
--
-- First you are used to `h`,`j`,`k`,`l` to navigate
-- I've also set `H` and `L` (shift-h, shift-l) to go to the start and end of line
-- Give it a go

-- Great we've got speedy left to right movement, for speedy up and down movement
-- you can use the keys `{` and `}` or i've also mapped <alt-j> and <alt-k>, it moves
-- a block at a time.

-- To also save your poor wrist from hitting `<esc>` to exit insert mode, i've mapped
-- `jk` to `<esc>` so you can enter insert mode (`i`) and get back to normal mode by
-- just rolling your fingers on `jk`. "red green bl"

-- I assume you know some basic but here's a dump of handy movement things to try
--  <Ctrl-o>        - jump back up the stack of places you've been
--  `gg` and `G`    - top and bottom of file
--  `.`             - repeat the last thing you did to modify some text
--  `/`             - search for a word in a buffer, try find "easter", press `n` to cycle through
--                      until you're back here. I've currently mapped `,<space>` to toggle search
--                      highlighting
--  `f<key>`        - motion to the next occurence of a <key>   |                 z
--  `df<key>`       - delete until the next occurence of a key. |     lallal      z
--  `w`             - Move one word forward
--  `dw`            - Delete until the end of the word          |         nice_lasldasdas
--  `diw`           - More helpfully, delete [i]nside [w]ord    | this is `barbeque` also nice
--  `di(`           - Similarly, delete inside brackets ()      | def func(i_dont_want_this_param)
--                      you can also use [], {}, "", ''         | [hi] "hi" 'hi' {hi}
--  `da(`           - Similar but also delete the surrounding   | [hi] "hi" 'hi' {hi}
--                      stuff
--  `o`             - Start a new line beneath this one
--  `O`             - Start a new line above this one

-- Sometimes, you get stuck with a file not wanting to close, you can usually just force
-- the matter with `:wq!`. If you try this out, open up neovim and press <ctrl-o> to get
-- back here

-- There's a lot of language smartness going on, if you werent aware
-- of <shift-j> then
-- try it out on the line above
-- and notice how the removes the `--` comment marker while joining lines

-- This list goes on but it's some handy things to know

-- (<ctrl-o> if you get lost) If you like folds, `zM` for fold all and `zR` to unfold all
-- I've also made `<space>` toggle the fold you're currently on/in

-- Neovim is configured with simple arcane lua instead of the complex arcane vimscript
-- this is how you set a variable, sort of, I've mapped `<ctrl-space>` to jump to the next
-- diagnostic in a file. Fix the first variable using the second as a reference then
-- delete them both (`dd` on the line)
hi = "hello"
local good = "sure"

-- This is a dictionary (lua calls em tables)
local mydict = { roses = "red", violets = "blue" }
mydict["neovim"] = "slick"
mydict["and so"] = "are you"

-- This is a list
local mylist = { "its", "actually", "a", "dictionary", "with", "indices", "as", "keys" }

-- Here's a function
local function myfunc(arg1, arg2)
    -- With a loop inside
    for key, value in pairs(mydict) do
        print(key .. value) -- Any joining a string with `..`
    end
end

-- Here's a cool feature, go up to the `print` above and press `<Alt-l>`
-- Press it again until the whole function is highlighted
-- Now press `<Alt-h>` to reduce the selection back down
-- Now highlight just the loop inside and press `d`
-- `u` to undo and try again if you like (`ctrl-r`, redo)

-- You'll see the little diagnostics icons in the `signcolumn`
-- If you want to see all of them for a file, press `<ctrl-d>`
-- where the `d` is for diagnostics (press again to toggle).
-- You can press `<enter>` (which is called <cr>) to jump
-- to the line of the diagnostic

-- Below is a bunch of settings and remebing them is a pain
-- You can type `:help <thing>` to get help or use a powerful
-- plugin called `Telescope` which I've mapped to `,h`
-- (h for help) to fuzzy find what you're looking for
-- Try typing `,htelescope`.
-- Use `:q` to exit that buffer if you git enter

vim.cmd([[filetype plugin indent on]])

-- Here's a bunch of options, feel free to ignore them or use
-- `,h` to figure out what they are
-- <Alt-j> pass these if you like
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

-- POI
-- At this point, I'll just walk through what's here in their semi random order
-- you can find each point of interest using `/POI`
-- These are the little diagnostic signs that pop up, feel free to the `sign`
local setsign = require("util").setsign
setsign({ name = 'DiagnosticSignError', sign = '' })
setsign({ name = 'DiagnosticSignWarn', sign = '' })
setsign({ name = 'DiagnosticSignHint', sign = '' })
setsign({ name = 'DiagnosticSignInfo', sign = '' })

-- POI
-- I've just chosen this one, we'll see in the `plugins` section
-- how you can install new ones
vim.cmd([[
    try
        colo tokyonight-storm
    catch
	    colo default
]])
-- }}}


-- {{{ Keymaps
local setkey = require("util").setkey
local command = require("util").command

-- POI
-- This is the key marked as `<leader>` in some keymaps below
-- Wherever i said to use `,` like in `,h`, this is actually mapped as `<leader>h`
-- Choose your fighter...
vim.g.mapleader = ","

-- Quick help
setkey({ key = "<leader>h", cmd = ":Telescope help_tags<cr>" })

-- easter island
-- Move to start/end of line
setkey({ key = "H", cmd = "^" })
setkey({ key = "L", cmd = "$" })

-- Move up and down a block at a time
setkey({ key = "<A-k>", cmd = "{" })
setkey({ key = "<A-j>", cmd = "}" })

-- Smart selection <A-l>, <A-h>

-- Toggle fold
setkey({ key = "<space>", cmd = "za" })

-- Cycle buffers
setkey({ key = "<Tab>", cmd = ":bnext<cr>" })
setkey({ key = "<S-Tab>", cmd = ":bnext<cr>" })

-- Find an open buffer (This hotkey just comes from pycharm)
-- Right now, it will probably only show you [No name] and init.lua
command({ key = "<C-e>", name = "FindBuffer", cmd = "Telescope buffers", })

-- Toggle search highlight
setkey({ key = "<leader><space>", cmd = ":set hlsearch!<CR>" })

-- This makes `jk` while in insert/visual/terminal mode act as escape,
-- much easier than reaching for esc, try it out!
setkey({ mode = "i", key = "jk", cmd = "<esc>" })
setkey({ mode = "v", key = "jk", cmd = "<esc>" })
setkey({ mode = "t", key = "jk", cmd = "<c-\\><c-n>" })

-- Just because we sometimes want to toggle these around
setkey({ key = "<leader>fmm", cmd = ":set foldmethod=marker<CR>" })
setkey({ key = "<leader>fmi", cmd = ":set foldmethod=indent<CR>" })
setkey({ key = "<leader>fme", cmd = ":set foldmethod=expr<CR>" })

-- Only if you're feeling spicy, disable arrow keys
-- setkey({ key="<left>", cmd="<nop>" })
-- setkey({ key="<right>", cmd="<nop>" })
-- setkey({ key="<up>", cmd="<nop>" })
-- setkey({ key="<down>", cmd="<nop>" })

-- POI
-- Toggle file explorer, I use Ctrl+h because it's a window that pops out of the left
-- Navigate using j,k to go up and down and l,h to go deeper or out
-- l on a file will just open the file
-- Go to ./nvim-cluster/nvim/lua/config/nvim-tree.lua
-- You can also search with `/nvim-tree`
command({ key = "<C-h>", name = "ToggleTree", cmd = "NvimTreeToggle", })

-- [e]dit [v]imrc
command({ key = "<leader>ev", name = "VIMRC", cmd = "e $MYVIMRC" })

-- Find Things
-- Find a file with fuzzy find (Ctrl+P was a vanilla vim plugin, the hotkey stuck)
command({ key = "<C-p>", name = "FindFile", cmd = "Telescope find_files", })

-- POI
-- This is bread and butter when you have to just find some string, try find all
-- the occurences of `banana`
-- When you have typed `banana` into the search bar, press `<C-l>`
-- [s]earch [s]tring
command({ key = "<leader>ss", name = "FindString", cmd = "Telescope live_grep", })
-- Use `<Ctrl-p>` to find `telescope.lua` and see how it's configured


-- POI
-- Find a command
-- You may have thought by know, how the hell should I remeber all this... dont.
-- Remember a keyword and use `<C-f>` to find a command and run it. If you use it
-- often enough, you'll always be able to find the keymap here.
-- Alternatively, if you find yourself writing a command a lot, feel free to make more
-- commands.
command({ key = "<C-f>", name = "FindCommand", cmd = "Telescope commands" })


-- Diagnostics
-- POI
-- Jump to next
command({ key = "<c-space>", name = "NextDiagnostic", cmd = "lua vim.diagnostic.goto_next()" })
-- [s]how [e]rror on current line
command({ key = "se", name = "LineErrors", cmd = "lua vim.diagnostic.open_float()", })
i_am_error = "rawr"
-- Ctrl + [D]iagnostics
command({ key = "<C-d>", name = "DiagnosticsList", cmd = "TroubleToggle workspace_diagnostics", })

-- Language smarts
-- Ctrl + [F]ormat
command({ key = "<leader>f", name = "Format", cmd = "lua vim.lsp.buf.format()" })
local all_over_the_place = {
    one =     "two",      three = "four"
}

-- [r]ename (only on current buffer)
command({ key = "<leader>r", name = "Rename", cmd = "lua vim.lsp.buf.rename()", })
local XX = "YY"
local ZZ = XX..XX

-- POI
-- [s]how [d]efinition
command({ key = "sd", name = "Definition", cmd = "lua vim.lsp.buf.hover()", })
-- [g]o [d]efinition
command({ key = "gd", name = "GoDefinition", cmd = "Telescope lsp_definitions", })
-- [s]how [r]eferences
command({ key = "sr", name = "ShowReferences", cmd = "Trouble lsp_references" })

--- Does nothing useful
--- @param a integer
--- @param b string
local function definition(a, b)
    return {number=a + a, string=b..b}
end
-- Hover over definition here and press `sd`, `sr`, and `gd`.
definition(3, "hi")

-- Alt + Enter (CodeActions is not as good as pycharm right now)
-- It'll be a while before pycharm level code actions get here
command({ key = "<A-cr>", name = "CodeActions", cmd = "lua vim.lsp.buf.code_action()", })

-- POI
-- Find a symbol (may consider `lsp_document_symbols`)
command({ key = "<leader>S", name = "SearchSymbolDoc", cmd = "Telescope lsp_workspace_symbols", })

-- POI
-- Git
-- I really like how simple but fleshed out git is here
-- Add a line somewhere, use `<leader>gs` and use the keys `a` to add a file
-- and `=` to expand the changes in that files. You can also expand and 
-- commit individual hunks instead of the entire file.
--
-- Once you've added something, press `<leader>gc``
--
-- This will open up a little buffer where you can type your commit message
-- There is syntax highlighting for conventional-commits
--
--              type(context): short message sort of
--
--              Longer description can go down here with whatever else
--              is needed
--
-- Finally you can use `<leader>gp` to push any staged changes
-- There are much more things it can do  `:help fugitive-maps`
-- I sometimes use `ce` to ammend a commit with something I forgot to stage
command({ key = "<leader>gs", name = "GitStatus", cmd = "vertical bo Git" })
command({ key = "<leader>gc", name = "GitCommit", cmd = "Git commit" })
command({ key = "<leader>gp", name = "GitPush", cmd = "Git push" })

-- A view of the log
command({ key = "<leader>gl", name = "GitLog", cmd = "vsp | GcLog" })

-- These here correspond to the bars on the left which show changes, additions
-- deletions.
-- Use `ga` to stage the current hunk your
-- hovering over, `gu` to undo the stage, `gp` to  preview and `gr` (dangerous)
-- will reset it. Yes this will sync with the git status window from befre
-- Here's a section to play around in,
-- 
--
--
command({ key = "ga", name = "GitAddHunk", cmd = "Gitsigns stage_hunk" })
command({ key = "gu", name = "GitUndoHunk", cmd = "Gitsigns undo_stage_hunk" })
command({ key = "gp", name = "GitPreviewHunk", cmd = "Gitsigns preview_hunk" })
command({ key = "gr", name = "GitResetHunk", cmd = "Gitsigns reset_hunk" })

-- Add the entire file
command({ key = "gA", name = "GitAddFile", cmd = "Gitsigns stage_buffer" })

-- See who commited what!
-- Delete a line and use `<leader>td` to toggle see what's been deleted, (`u` to undo)
command({ key = "<leader>td", name = "ToggleDeletedGit", cmd = "Gitsigns toggle_deleted" })

-- Try it out with some modifications in the buffer
command({ key = "<leader>tl", name = "ToggleLineGit", cmd = "Gitsigns toggle_linehl" })
-- command({ key = "gR", name = "GitResetFile", cmd = "Gitsigns reset_buffer" }) -- careful

-- }}}

-- {{{ Autocommands
-- All you need to know is that it toggles your current line to bold
-- when you're in insert mode
vim.api.nvim_create_augroup("UserCommands", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter",
    { group = "UserCommands", command = "hi CursorLine gui=bold", }
)
vim.api.nvim_create_autocmd("InsertLeave",
    { group = "UserCommands", command = "hi CursorLine gui=NONE", }
)
-- }}}

-- {{{ Modules
-- Go before plugins
if vim.env.VIRTUAL_ENV == nil and vim.env.CONDA_PYTHON_EXE then
    vim.env.VIRTUAL_ENV = vim.env.CONDA_PYTHON_EXE
end

-- POI
-- At this point, you're on you own
-- Feel free to explore what's here.
-- Most plugin configurations are in `nvim/lua/config`
-- You can search up and read about `Packer`, the plugin manager
-- if you want to add/delete more.
--
-- If you want to create your own nvim config setup and have it
-- on git, then you'll need everuthing under the `nvim` folder
-- which I smybolic linked to `$HOME/.config/nvim`. You may
-- want to read through the `install.sh` script in this repo
-- to see that setup steps that were performed as it's usually
-- a bit more of a tedious once-off process to get right.
require("plugins").setup() -- Keep this first
require("lsp").setup() -- Language smarts
-- }}}
--
--
-- easter egg
-- vim:foldmethod=marker
