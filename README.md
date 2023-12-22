# WSL2 Setup Script

This script automates the setup of a WSL2 environment, including the installation of `pyenv`, `nvm`, `fzf`, and setting up a development directory structure.

## Features

- Updates and upgrades existing packages.
- Installs `pyenv` and its dependencies.
- Configures `pyenv` in `.bashrc`.
- Installs `nvm` (Node Version Manager) and sets the latest Node version.
- Installs `fzf` (a command-line fuzzy finder) and configures it in `.bashrc`.
- Creates a development directory structure under `~/dev`.

## Prerequisites

- WSL2 should be installed on your Windows machine.
- A Debian-based Linux distribution (like Ubuntu) running in WSL2.

## Installation

1. Clone or download this repository to your WSL2 environment.
2. Navigate to the directory containing the script.

    ```bash
    cd path/to/script
    ```

3. Make the script executable:

    ```bash
    chmod +x setup_wsl.sh
    ```

4. Run the script:

    ```bash
    ./setup_wsl.sh
    ```

## Usage

After running the script, your WSL2 environment will be set up with the specified tools and configurations. You can start using `pyenv`, `nvm`, and `fzf` immediately.

The script also creates two directories under `~/dev`: `invenio-dev` and `test-dev`, which you can use for your development projects.

## Customization

You can customize the script according to your needs. Edit the script to add or remove packages, modify the `.bashrc` configurations, or change the directory structure.

## Note

- Running the script may take some time, especially for compiling and installing certain packages.
- Ensure you have sufficient permissions to install and configure the listed software.
- Always review and test the script in a safe environment before running it on your primary system.

## License

This script is provided "as is", without warranty of any kind. Use it at your own risk.
