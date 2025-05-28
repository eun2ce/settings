#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Homebrew if not installed (for macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command_exists brew; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
fi

# Install Visual Studio Code if not installed
if ! command_exists code; then
    echo "Installing Visual Studio Code..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install --cask visual-studio-code
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # For Ubuntu/Debian
        if command_exists apt; then
            sudo apt update
            sudo apt install -y software-properties-common apt-transport-https wget
            wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
            sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
            sudo apt update
            sudo apt install -y code
        # For Fedora
        elif command_exists dnf; then
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
            sudo dnf install -y code
        fi
    fi
fi

# Create VSCode config directories if they don't exist
VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    VSCODE_CONFIG_DIR="$HOME/.config/Code/User"
fi

mkdir -p "$VSCODE_CONFIG_DIR"

# Copy configuration files
echo "Copying VSCode configuration files..."
cp vscode/settings.json "$VSCODE_CONFIG_DIR/settings.json"
cp vscode/keybindings.json "$VSCODE_CONFIG_DIR/keybindings.json"

# Install extensions
echo "Installing VSCode extensions..."
while IFS= read -r extension || [[ -n "$extension" ]]; do
    if [[ ! "$extension" =~ ^#.*$ && ! -z "$extension" ]]; then
        code --install-extension "$extension"
    fi
done < vscode/extensions.txt

echo "Installation completed successfully!" 