#!/bin/sh
GITHUB_LINK="https://github.com/eddiebergman/nvim-cluster.git"
REPO_DIR="$(pwd)/nvim-cluster"
REPO_NVIM_CONFIG="$(pwd)/nvim"

CONDA_PYTHON_VERSION="3.10"
CONDA_LINK="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
CONDA_SCRIPT="$(pwd)/Miniconda3-latest-Linux-x86_64.sh"
CONDA_ENV="$(pwd)/.nvim-python-venv"
CONDA_EXC="$HOME/miniconda3/bin/conda"

TREESITTER_VERSION="v0.20.7"
TREESITTER_LINK="https://github.com/tree-sitter/tree-sitter/releases/download/${TREESITTER_VERSION}/tree-sitter-linux-x64.gz"
TREESITTER_DIR="$(pwd)/tree-sitter"
TREESITTER_GZ="$TREESITTER_DIR/tree-sitter-linux-x64.gz"
TREESITTER_BINARY="$TREESITTER_DIR/tree-sitter"

NVIM_VERSION="stable"
NVIM_LINK="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux64.tar.gz"
NVIM_TAR="$(pwd)/nvim-linux64.tar.gz"
NVIM_UNPACK_DIR="$(pwd)/nvim-linux64"
NVIM_BINARY_DIR="$NVIM_UNPACK_DIR/bin"
NVIM_BINARY="$NVIM_BINARY_DIR/nvim"

NVM_VERSION="v0.39.2"
NVM_INSTALL_CMD="wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash"

BIN_DIR="$(pwd)/bin"

isdir () {
    [[ -d "$1" ]];
    return
}
isfile () {
    [[ -f "$1" ]];
    return
}

isdir "$BIN_DIR" || mkdir "$BIN_DIR"
isdir "$REPO_DIR" || git clone "$GITHUB_LINK"
isfile "$NVIM_TAR" || wget "$NVIM_LINK"
isdir "$NVIM_UNPACK_DIR" || tar xvf "$NVIM_TAR"

# We need conda to be able to create a python virtual env for all the python
# parts of neovim
if ! command -v "conda" > /dev/null; then
    wget --no-clobber --output-document "$CONDA_SCRIPT" "$CONDA_LINK"
    sh "$CONDA_SCRIPT"
    if ! isfile "$CONDA_EXC"; then
        echo "Something went wrong, couldn't find conda command in PATH"
        echo "Also tried looking for binary at ${CONDA_EXC}"
        echo "Try restarting your shell and running the install script again"
        exit 1
    fi
fi

# Create a virtual environemtn nvim can run from
if ! isdir "$CONDA_ENV"; then
    if command -v "conda"; then
        conda create -y -p "$CONDA_ENV" python="$CONDA_PYTHON_VERSION"
    else
        $CONDA_EXC create -y -p "$CONDA_ENV" python="$CONDA_PYTHON_VERSION"
    fi
fi

# We need a more up to date version of npm and node for some neovim things
# This will actually replace the default node/npm on the cluster on your path
if ! command -v "nvm" > /dev/null; then
    eval "$NVM_INSTALL_CMD"

    # These are commands put into the users .bashrc/.zshrc, we do them immediatly so we don't
    # have to source them or tell the user to reset the terminal
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# We need a more recent node version, 19 worked for me
NODE_VERSION=$(node --version | grep -oE "^v[0-9]+" | tr -d "v")
[[ $NODE_VERSION -gt 18 ]] || nvm install node

# We need tree-sitter cli for parts of the Tree Sitter language parsers
# that neovim can use
if ! command -v "tree-sitter" > /dev/null; then
    isdir "$TREESITTER_DIR" || mkdir "$TREESITTER_DIR"
    wget --no-clobber --output-document "$TREESITTER_GZ" "$TREESITTER_LINK"
    gzip -c -d "$TREESITTER_GZ" > "$TREESITTER_BINARY"
    chmod u+x "$TREESITTER_BINARY"
fi

# Back up any existing vimrc
BACKUP_VIMRC="$HOME/.vimrc.copy-$(date)"
isfile "$HOME/.vimrc" && cp "$HOME/.vimrc" "$BACKUP_VIMRC"

# Move binaries to one folder
cp "$NVIM_BINARY" "${BIN_DIR}/nvim"
cp "$TREESITTER_BINARY" "${BIN_DIR}/tree-sitter"

CONFIG_DIR="$HOME/.config"
NVIM_CONFIG_PATH="$CONFIG_DIR/nvim"
NVIM_BACKUP_CONFIG_PATH="$CONFIG_DIR/nvim.backup"

# Back up the nvim config dir if it exists
isdir "$NVIM_CONFIG_PATH" && mv "$NVIM_CONFIG_PATH" "$NVIM_BACKUP_CONFIG_PATH"

# Link in the config from the repo
ln -sfn "$REPO_NVIM_CONFIG" "$CONFIG_DIR"

print_addpath () {
    echo "export PATH=\"\${PATH}:${1}\""
}
BASHRC_FILE="$HOME/.bashrc"
ZSHRC_FILE="$HOME/.zshrc"

rc_files=("$BASHRC_FILE" "$ZSHRC_FILE")

for rc_file in "${rc_files[@]}"; do
    if isfile "$rc_file"; then
        echo "# From nvim-cluster"
        echo "# ----------------"
        print_addpath "$BIN_DIR" >> "$BASHRC_FILE"
        echo "# ----------------"

        echo "Added the following lines to your $(basename "${rc_file}") at"
        echo " - $BASHRC_FILE"
        print_addpath "$BIN_DIR"
        echo "export PATH=\"{PATH}:${HOME}\""
    fi
done
