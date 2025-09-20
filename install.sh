#!/usr/bin/env bash
set -e

REPO="YOUR-ORG/gh-switch"
INSTALL_DIR="/usr/local/bin"
CONFIG_DIR="$HOME/.config/gh-switch"

echo "Installing gh-switch..."

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     OS_TYPE=Linux;;
    Darwin*)    OS_TYPE=Mac;;
    *)          echo "Unsupported OS: ${OS}"; exit 1;;
esac

# Create temp directory
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# Download latest release
echo "Downloading gh-switch..."
curl -sL "https://github.com/${REPO}/archive/main.tar.gz" | tar xz

# Install
echo "Installing to ${INSTALL_DIR}..."
cd gh-switch-main

# Create standalone script
cat > gh-switch-standalone <<'EOF'
#!/usr/bin/env bash
# Auto-generated standalone script
EOF

# Combine all libs into standalone
for lib in lib/*.sh; do
    echo "# --- $(basename $lib) ---" >> gh-switch-standalone
    grep -v '^#!/' "$lib" >> gh-switch-standalone
    echo "" >> gh-switch-standalone
done

# Add main logic
grep -v '^#!/' bin/gh-switch | grep -v 'source.*lib' >> gh-switch-standalone

# Install
sudo mv gh-switch-standalone "${INSTALL_DIR}/gh-switch"
sudo chmod +x "${INSTALL_DIR}/gh-switch"

# Cleanup
cd /
rm -rf "$TMP_DIR"

echo "✓ gh-switch installed successfully!"
echo "Run 'gh-switch init' to get started"