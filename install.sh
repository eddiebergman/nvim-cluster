#!/bin/sh
isdir () {
    [[ -d "$1" ]];
    return
}
isfile () {
    [[ -f "$1" ]];
    return
}

GITHUB_LINK="www.github.com/eddiebergman/nvim-cluster"
NVIM_LINK="https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz"
NVIM_TAR="$(pwd)/nvim-linux64.tar.gz"
NVIM_UNPACK_DIR="$(pwd)/nvim-linux64"
CONDA_LINK="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
CONDA_SCRIPT="$(pwd)/Miniconda3-latest-Linux-x86_64.sh"
CONDA_ENV="$(pwd)/.nvim-python-venv"
NVIM_BINARY_DIR="$NVIM_UNPACK_DIR/bin"
CONDA_PYTHON_VERSION="3.10"
VIMRC_PATH="$(pwd)"

HAS_CONDA=0
if command -v "conda" > /dev/null; then
    HAS_CONDA=1
fi

if ! isdir "nvim-cluster"; then
    git clone "$GITHUB_LINK"
fi

{
    if ! isfile "$NVIM_TAR"; then
        wget "$NVIM_LINK"
    fi
    if ! isdir "$NVIM_UNPACK_DIR"; then
        tar xvf nvim-linux64.tar.gz
    fi
}

if ! command -v "conda" > /dev/null; then
    wget "$CONDA_LINK"
    sh "$CONDA_SCRIPT"

    if isfile "$HOME/.bashrc"; then
        source "$HOME/.bashrc"
    elif isfile "$HOME/.zshrc"; then
        source "$HOME/.zshrc"
    else
        echo "-----------------------------"
        echo "Not sure what shell is being used, please restart your shell and re-run this script"
        echo "It will not need to redownload or reinstall conda"
        exit 1
    fi
fi

BACKUP_VIMRC="$HOME/.vimrc.copy-$(date)"
if isfile "$HOME/.vimrc"; then
    cp "$HOME/.vimrc" "$BACKUP_VIMRC"
fi

conda create -y -p "$CONDA_ENV" python="$CONDA_PYTHON_VERSION"
nvim --headless -c 'call mkdir(stdpath("config"), "p") | exe "edit" stdpath("config") . "/init.lua" | write | quit'

echo "To launch, use ${bin_location}/nvim"
echo "Or add the following to your .bashrc"
echo "export PATH=${bin_location}/\$PATH"
