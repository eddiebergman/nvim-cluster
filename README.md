# nvim-cluster
This is an easy install setup for having a neovim setup on the cluster!

```bash
wget -qO- https://raw.githubusercontent.com/eddiebergman/nvim-cluster/main/install.sh | bash
```

This will install everything into `./nvim`.
After installation and restarting your shell, you can run `nvim` to launch neovim and you
can always add the line `alias vim=nvim` if you like.

After restarting your shell, the installation script will tell to launch you primary config
file for a walkthrough of some of the features, enjoy!

```bash
cd $HOME/.config/nvim
nvim init.lua
```

This walkthrough should take 10-20 minutes depending on your familiarty with vim.

## Tips

After you've gone through the walkthrough, you should be good in `90%` of situations and maybe
missing something in the other `10%`.

Go through the walkthrough.

Really, it covers a lot.

You should almost always launch `nvim` in the root of a repository if workin with a repo, otherwise
if just editing scripts, it shouldn't matter.

If using a virtual environment, activate it first before launching `nvim` so the language tools
are fully aware of your virtual environent.

I've pre-installed many language servers and language parsers for the common files I think you may encounter.
When using a virtual environment, these `python` tools may not be avialable in the virtual env.
To install new tools such as `pylint`, just launch `:Mason` once inside neovim. (type `g?` for help there)

All `plugins` are listed and installed in `nvim/plugins.lua` and managed with a plugin manager called
`packer`. You can google all these plugins and their configuration from their repos on github.
To update plugins, run `:PackerSync`.

[The neovim subreddit](https://www.reddit.com/r/neovim/) if a great place to find new cool things.

## How does this work?

The install script will download a release binary of neovim so we don't use the out-dated version
on the cluster, adding it to your `$PATH` in your `.bashrc` and `.zshrc` if present.

The config files are all located at `./nvim-cluster/nvim`, relative to wherever you ran the
installation script. This `./nvim-cluster/nvim` is symlinked to `~/.config/nvim` during the installation.
If you previously had some config files here, they will be backed up, as well as your `.vimrc`.
If you want to edit anything, you can just use `<C-f>VIMRC` or manually with:

```bash
cd $HOME/.config/nvim
nvim
```

Neovim has support for the **L**anguage **S**erver **P**rotocol (LSP), the same protocol that powers
vscode and all it's language smart plugins. This installation comes with a bunch of
servers for languages like `python`, `bash`, `yaml`, etc... . You can always use `:Mason` to
install a new one if you like.

These LSP's are usually a binary or require some runtime, like `python` or `nodejs`. This installation
will use `conda` to create a dedicated `python` virtual environment for neovim and `nvm` to update and create
a `nodejs` environent (The one on the servers is serverly out-dated).

Vim's highlighting is based purely on `regex`, which is not as powerful as an Abstract Syntax Tree that
understands the language. This is powered by `tree-sitter`, which builds tool agnostic parsers for all
sorts of languages. I've installed the `tree-sitter` cli tool which `neovim` will use to install a parser
for any new language you may use.


## Help

> I'm seeing errors during the installation.

Yup that's alright, this is because some configuration code tries to use plugins before they're installed.
These will resolve themselves

> It hangs while installing?

If this happens, try `ctrl+c` out of it, restart your shell and just launch `nvim`.
It should hopefully sort itself out. There may however be some `tree-sitter` parsers missing which
I recommend, you can check `install.sh` and search for `TSInstallSync` and run these in neovim.

```
:TSInstall a b c
```

You can check which are installed using `:TSInfo`

* `tree-sitter`: This is the technology enabling language smart parsers, used for highlighting and
smart editing features.

> I'm getting errors once launching!

Damn, this is likely some buggy plugin that's come about over time. Please let me know which one, if
this becomes a real issue, I will spend time and freeze the plugin versions to something stable.

> I can't use copy and paste from the cluster neovim to some local application. However it works from
some local app to the cluster.

Yep, it's annoying and I havn't really gone through enough to figure it out yet. See `:help clipboard`
and if you get it to work, please let me know!

> How do I refactor across a project?

Open-source python language servers are not as good as the closed-source language servers used by
Pycharm (?) and VScode (Pylance). Pylance is Microsofts closed source improvement over `pyright`
which is what I have pre-installed with neovim. Your best friend for refactoring is to search for
a string over the entire project `<leader>ss` by default and using `<C-l>` to populate the quick-jump
bar on the side.

> I don't like it, how do I uninstall?

```bash
# rm -rf the `nvim-cluster` directory which would be created wherever you ran the install command
rm -rf ~/.config/nvim  # Config files
rm -rf ~/.local/share/nvim  # Data for nvim

# Remove the lines added by `nvim-cluster` in your `.bashrc` or `.zshrc`
```
