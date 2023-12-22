#!/bin/bash

# Function to check and install a command if it doesn't exist
check_install() {
    local command=$1
    local install_script=$2

    if ! command -v $command >/dev/null 2>&1; then
        echo "Installing $command..."
        eval $install_script
    else
        echo "$command is already installed."
    fi
}

# Updating and upgrading packages with auto-agree
sudo apt update && sudo apt upgrade -y

# Install dependencies and pyenv
pyenv_install_script="\
    sudo apt-get update; sudo apt-get install --no-install-recommends -y \
    make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
    libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev \
    libxmlsec1-dev libffi-dev liblzma-dev checkinstall \
    libncursesw5-dev libgdbm-dev libc6-dev python-openssl git; \

    curl https://pyenv.run | bash; \
    echo 'export PYENV_ROOT=\"\$HOME/.pyenv\"' >> ~/.bashrc; \
    echo 'command -v pyenv >/dev/null || export PATH=\"\$PYENV_ROOT/bin:\$PATH\"' >> ~/.bashrc; \
    echo 'eval \"\$(pyenv init -)\"' >> ~/.bashrc"
check_install pyenv "$pyenv_install_script"

# Install NVM and set Node version
nvm_install_script="\
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash; \
    source ~/.bashrc; \
    nvm install node; \
    nvm use node"
check_install nvm "$nvm_install_script"

# Install fzf
fzf_install_script="\
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; \
    ~/.fzf/install --all; \
    echo '[ -f ~/.fzf.bash ] && source ~/.fzf.bash' >> ~/.bashrc"
check_install fzf "$fzf_install_script"


# Create dev directory and subdirectories if they don't exist
mkdir -p ~/dev/invenio-dev
mkdir -p ~/dev/test-dev

echo "Setup completed successfully."
