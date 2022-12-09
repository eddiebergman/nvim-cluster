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
