#!/bin/bash
INSTALL_DIR="$(pwd)/nvim"

GITHUB_LINK="https://github.com/eddiebergman/nvim-cluster.git"
REPO_DIR="$INSTALL_DIR/nvim-cluster"
REPO_NVIM_CONFIG="$REPO_DIR/nvim"
MAGIC_LINE_FOR_PYTHON_PROG="8"

NVIM_VERSION="v0.8.1"
NVIM_PACKAGE="https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux64.tar.gz"
NVIM_TAR="$INSTALL_DIR/nvim-linux64.tar.gz"
NVIM_DIR="$INSTALL_DIR/nvim-linux64"
NVIM_BINARY_DIR="$NVIM_DIR/bin"
NVIM_BINARY="$NVIM_BINARY_DIR/nvim"

CONFIG_DIR="$HOME/.config"
NVIM_CONFIG_PATH="$CONFIG_DIR/nvim"
NVIM_BACKUP_CONFIG_PATH="$CONFIG_DIR/nvim.backup"

CONDA_PYTHON_VERSION="3.10"
CONDA_LINK="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
CONDA_SCRIPT="$INSTALL_DIR/Miniconda3-latest-Linux-x86_64.sh"
CONDA_ENV="$INSTALL_DIR/.nvim-python-venv"
CONDA_EXC="$HOME/miniconda3/bin/conda"

TREESITTER_VERSION="v0.20.7"
TREESITTER_LINK="https://github.com/tree-sitter/tree-sitter/releases/download/${TREESITTER_VERSION}/tree-sitter-linux-x64.gz"
TREESITTER_DIR="$INSTALL_DIR/tree-sitter"
TREESITTER_GZ="$TREESITTER_DIR/tree-sitter-linux-x64.gz"
TREESITTER_BINARY="$TREESITTER_DIR/tree-sitter"

NVM_VERSION="v0.39.2"
NVM_INSTALL_CMD="wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash"

isdir() {
	[[ -d "$1" ]]
	return
}
isfile() {
	[[ -f "$1" ]]
	return
}
iscommand () {
	if ! command -v "$1" >/dev/null; then
		return 1
	else
		return 0
	fi
}

ensure_conda () {
	if ! iscommand "conda"; then
		# If there is no binary for miniconda conda, install miniconda
		if ! isfile "$CONDA_EXC"; then
			wget --no-clobber --output-document "$CONDA_SCRIPT" "$CONDA_LINK"
			sh "$CONDA_SCRIPT"
		fi

		# If we still cant use this binary then something has gone wrong
		if ! isfile "$CONDA_EXC"; then
			echo "Something went wrong, couldn't find conda command in PATH"
			echo "Also tried looking for binary at ${CONDA_EXC}"
			echo "Try restarting your shell and running the install script again"
			exit 1
		fi

		# Initilize conda incase
		$CONDA_EXC init
		eval "$($CONDA_EXC shell.bash hook)"
		CONDA_BASE="$($CONDA_EXC info --base)"

		# Check that the conda shell exists and activate it
		CONDA_SHELL_CMD="$CONDA_BASE/etc/profile.d/conda.sh"
		if ! isfile "$CONDA_SHELL_CMD"; then
			echo "Something went wrong, try restarting your shell and running again"
			exit 1
		fi
		source "$CONDA_SHELL_CMD"
	fi
	if iscommand "conda"; then
		return 0
	fi
	return 1
}

ensure_updated_npm_through_nvm () {
	# We need a more up to date version of npm and node for some neovim things
	# This will actually replace the default node/npm on the cluster on your path
	if ! command -v "nvm" >/dev/null; then
		eval "$NVM_INSTALL_CMD"

		# These are commands put into the users .bashrc/.zshrc, we do them immediatly so we don't
		# have to source them or tell the user to reset the terminal
		export NVM_DIR="$HOME/.nvm"
		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
		[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
	fi

	# We need a more recent node version, 19 worked for me
	NODE_VERSION=$(node --version | grep -oE "^v[0-9]+" | tr -d "v")
	[[ $NODE_VERSION -gt 18 ]] || nvm install node


	if iscommand "nvm"; then
		return 0
	fi
	return 1
}

ensure_treesitter () {
	# We need tree-sitter cli for parts of the Tree Sitter language parsers
	# that neovim can use
	if ! command -v "tree-sitter" >/dev/null; then
		isdir "$TREESITTER_DIR" || mkdir "$TREESITTER_DIR"
		wget --no-clobber --output-document "$TREESITTER_GZ" "$TREESITTER_LINK"
		isfile "$TREESITTER_BINARY" || gzip -c -d "$TREESITTER_GZ" >"$TREESITTER_BINARY"
		chmod u+x "$TREESITTER_BINARY"
		export PATH="$PATH:$TREESITTER_DIR"  # We can append to end of path because we don't care which
	fi
	if iscommand "tree-sitter"; then
		return 0
	fi
	return 1
}

create_conda_virtual_env_for_neovim () {
	# We need conda to be able to create a python virtual env for all the python
	# parts of neovim
	# Create a virtual environment nvim can run from
	if ! isdir "$CONDA_ENV"; then
		conda create -y -p "$CONDA_ENV" python="$CONDA_PYTHON_VERSION"
	fi
	# Install pynvim and get the python binary path
	conda run -p "$CONDA_ENV" pip install pynvim
}

inject_python_intepreter_to_init_file () {
	PYTHON_BIN=$(conda run -p "$CONDA_ENV" which python)
	INIT_FILE="$REPO_DIR/nvim/init.lua"
	sed -i "${MAGIC_LINE_FOR_PYTHON_PROG}s:.*:vim.g.python3_host_prog = '${PYTHON_BIN}':" "$INIT_FILE"
}

install_neovim () {
	if ! isdir "$NVIM_DIR"; then
		wget --no-clobber --output-document  "$NVIM_TAR"  "$NVIM_PACKAGE"
		tar -xf "$NVIM_TAR"
	fi
	export PATH="${NVIM_BINARY_DIR}:$PATH"
	if iscommand "nvim"; then
		return 0
	fi
	return 1
}

clone_config_and_inject () {
	# Clone the nvim-cluster repo
	isdir "$REPO_DIR" || git clone "$GITHUB_LINK"
	# Link in the config from the repo
	ln -sfn "$REPO_NVIM_CONFIG" "$CONFIG_DIR"
}

backup_existing_configs () {
	# Back up any existing vimrc
	BACKUP_VIMRC="$HOME/.vimrc.copy-$(date)"
	isfile "$HOME/.vimrc" && mv "$HOME/.vimrc" "$BACKUP_VIMRC"

	# Back up the nvim config dir if it exists
	isdir "$NVIM_CONFIG_PATH" && mv "$NVIM_CONFIG_PATH" "$NVIM_BACKUP_CONFIG_PATH"
}

install_neovim_plugins () {
	# Install neovim
	nvim --headless -c "autocmd User PackerComplete quitall" -c "PackerSync"
	nvim --headless -c "LspInstall sumneko_lua bashls yamlls taplo esbonio marksman pyright jsonls clangd" \
    -c "MasonInstall ruff mypy actionlint flake8 yamllint yamlfmt black clang-format jq shfmt" \
    -c "TSInstallSync lua python query json markdown markdown_inline diff gitcommit gitignore help make bash regex toml vim yaml git_rebase" \
    -c qa
}

add_paths () {
	BASHRC_FILE="$HOME/.bashrc"
	ZSHRC_FILE="$HOME/.zshrc"

	rc_files=("$BASHRC_FILE" "$ZSHRC_FILE")

	for rc_file in "${rc_files[@]}"; do
		if isfile "$rc_file"; then
			echo "# From nvim-cluster" >> "$rc_file"
			echo "# ----------------" >> "$rc_file"
			echo "export PATH=\"${NVIM_BINARY_DIR}:\$PATH\"" >> "$rc_file"
			echo "export PATH=\"${TREESITTER_DIR}:\$PATH\"" >> "$rc_file"
			echo "# ----------------" >> "$rc_file"
		fi
	done
}


# Create the installation directory
isdir "$INSTALL_DIR" || mkdir "$INSTALL_DIR"
cd "$INSTALL_DIR" || exit 1

ensure_conda || (echo "Something went trying to install/use conda, try again?" && exit 1)
ensure_treesitter || (echo "Something went wrong, try again" && exit 1)
create_conda_virtual_env_for_neovim || (echo "Something went wrong creating Conda env for neovim, try again?" && exit 1)
ensure_updated_npm_through_nvm || (echo "Something went wrong installing nodejs for neovim" && exit 1)
install_neovim || (echo "Something went wrong building neovim" && exit 1)
backup_existing_configs
clone_config_and_inject
inject_python_intepreter_to_init_file
add_paths
install_neovim_plugins

echo
echo "======================="
echo "Successfully Installed!"
echo "Please start a new shell, and run the following to learn more about"
echo "the plugins and features of this setup!"
echo 
echo "cd $NVIM_CONFIG_PATH"
echo "nvim init.lua"
echo
echo "======================="
