#!/usr/bin/env bash
set -e

INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="gh-switch"

echo "Installing gh-switch..."

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     OS_TYPE=Linux;;
    Darwin*)    OS_TYPE=Mac;;
    *)          echo "Unsupported OS: ${OS}"; exit 1;;
esac

# Check if we're in the gh-switch directory
if [[ -f "bin/gh-switch-standalone" ]]; then
    echo "Installing from local repository..."

    # Make executable
    chmod +x bin/gh-switch-standalone

    # Install
    echo "Installing to ${INSTALL_DIR}/${SCRIPT_NAME}..."
    sudo cp bin/gh-switch-standalone "${INSTALL_DIR}/${SCRIPT_NAME}"

elif [[ -f "gh-switch-standalone" ]]; then
    echo "Installing from current directory..."
    chmod +x gh-switch-standalone
    sudo cp gh-switch-standalone "${INSTALL_DIR}/${SCRIPT_NAME}"

else
    # Download from GitHub
    echo "Downloading gh-switch from GitHub..."
    TMP_FILE=$(mktemp)

    # Replace with your actual GitHub raw URL
    DOWNLOAD_URL="https://raw.githubusercontent.com/YOUR-ORG/gh-switch/main/bin/gh-switch-standalone"

    if command -v curl &> /dev/null; then
        curl -sL "${DOWNLOAD_URL}" -o "${TMP_FILE}"
    elif command -v wget &> /dev/null; then
        wget -q "${DOWNLOAD_URL}" -O "${TMP_FILE}"
    else
        echo "Error: curl or wget is required"
        exit 1
    fi

    # Check if download was successful
    if [[ ! -s "${TMP_FILE}" ]]; then
        echo "Error: Failed to download gh-switch"
        rm -f "${TMP_FILE}"
        exit 1
    fi

    # Install
    chmod +x "${TMP_FILE}"
    sudo mv "${TMP_FILE}" "${INSTALL_DIR}/${SCRIPT_NAME}"
fi

# Verify installation
if [[ -f "${INSTALL_DIR}/${SCRIPT_NAME}" ]]; then
    echo "✓ gh-switch installed successfully!"
    echo "Version: $(${INSTALL_DIR}/${SCRIPT_NAME} --version)"
    echo ""
    echo "Run 'gh-switch init' to get started"
    echo "Run 'gh-switch help' for usage information"
else
    echo "Error: Installation failed"
    exit 1
fi

# Optional: Install shell completions
read -p "Install shell completions? (y/n): " install_completions
if [[ "$install_completions" == "y" ]]; then
    if [[ -f "completions/gh-switch.bash" ]] && [[ -d "/etc/bash_completion.d" ]]; then
        sudo cp completions/gh-switch.bash /etc/bash_completion.d/
        echo "✓ Bash completions installed"
    fi

    if [[ -f "completions/gh-switch.zsh" ]] && [[ -d "/usr/local/share/zsh/site-functions" ]]; then
        sudo cp completions/gh-switch.zsh /usr/local/share/zsh/site-functions/_gh-switch
        echo "✓ Zsh completions installed"
    fi
fi