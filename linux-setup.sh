#!/bin/bash

# Path to .bashrc
bashrc_path="$HOME/.bashrc"

# Function to replace a line in .bashrc
# TODO test this and replace default PS1 with:
# if [ "$color_prompt" = yes ]; then
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \n€€€ '
# else
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\ \n€€€ '
# fi

replace_line() {
    local search=$1
    local replace=$2
    local file=$3
    # Check if the line exists in the file
    if grep -q "$search" "$file"; then
        # Replace the line
        sed -i "s/$search/$replace/" "$file"
    else
        # If the line doesn't exist, append it
        echo "$replace" >> "$file"
    fi
}


# Take a backup for .bashrc before any modifications
cp $HOME/.bashrc $HOME/.bashrc.backup

# Replace or add PS1 line
ps1_search="if \[ \"\$color_prompt\" = yes \]; then"
ps1_replace="if [ \"\$color_prompt\" = yes ]; then\n
PS1='\${debian_chroot:+(\$debian_chroot)}\\[\\033[01;32m\\]\\u@\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\] \\n€€€ '\nelse\n    PS1='\${debian_chroot:+(\$debian_chroot)}\\u@\\h:\\w\\ \\n€€€ '\nfi"
replace_line "$ps1_search" "$ps1_replace" "$bashrc_path"

echo "Updated .bashrc with new PS1 and color prompt settings."

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

# Install dependencies
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

# Function to create SSH key
create_ssh_key() {
    # Define the SSH key file path
    local ssh_key_path="$HOME/.ssh/id_rsa"

    # Check if the SSH key already exists
    if [ -f "$ssh_key_path" ]; then
        echo "SSH key already exists at $ssh_key_path."
    else
        echo "Creating a new SSH key..."
        # Create SSH key without passphrase
        ssh-keygen -t rsa -b 4096 -f "$ssh_key_path" -N ""
        echo "SSH key created at $ssh_key_path."
    fi
}

# Ask user if they want to create an SSH key
read -p "Do you want to create a new SSH key? (y/n): " answer

case $answer in
    [Yy]* ) create_ssh_key;;
    [Nn]* ) echo "Skipping SSH key creation.";;
    * ) echo "Please answer yes or no.";;
esac

echo "Setup completed successfully."
