# gh-switch - GitHub Account Switcher 🔄

A fast, reliable command-line tool for managing multiple GitHub accounts. Switch between personal, work, and other GitHub identities seamlessly without manual SSH or Git config editing.

![Shell](https://img.shields.io/badge/shell-bash-green.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg)

## ✨ Features

- **Instant Switching**: Change GitHub accounts with a single command
- **SSH Key Management**: Automatically configures SSH hosts for each profile
- **Git Config Integration**: Updates user.name and user.email per repository
- **GPG Signing Support**: Configure GPG signing keys per profile for verified commits
- **Profile Storage**: Securely stores multiple account profiles
- **Auto-Detection**: Automatically detects and switches profiles based on repository
- **Remote URL Updates**: Automatically updates git remote URLs when switching
- **No Dependencies**: Pure shell script - works everywhere
- **Backup Safety**: Automatically backs up SSH config before modifications

## 🚀 Quick Start

### Installation

#### Method 1: Direct Installation (Recommended)

```bash
# Download and install
curl -sSL https://raw.githubusercontent.com/TheDevOpsBlueprint/gh-switch/main/bin/gh-switch-standalone -o /tmp/gh-switch
chmod +x /tmp/gh-switch
sudo mv /tmp/gh-switch /usr/local/bin/gh-switch

# Verify installation
gh-switch --version
```

#### Method 2: From Source

```bash
# Clone the repository
git clone https://github.com/TheDevOpsBlueprint/gh-switch.git
cd gh-switch

# Install
chmod +x bin/gh-switch-standalone
sudo cp bin/gh-switch-standalone /usr/local/bin/gh-switch

# Verify
gh-switch --version
```

#### Method 3: Using Make

```bash
# Clone and install
git clone https://github.com/TheDevOpsBlueprint/gh-switch.git
cd gh-switch
make install
```

### Initial Setup

```bash
# Initialize gh-switch
gh-switch init

# Add your first profile (personal)
gh-switch add personal

# Add a work profile
gh-switch add work
```

## 📖 Usage Guide

### Managing Profiles

#### Adding a Profile

```bash
# Add a new profile interactively
gh-switch add personal

# You'll be prompted for:
# - SSH key path: ~/.ssh/id_ed25519_personal
# - Git name: John Doe
# - Git email: john@personal.com
# - GitHub username: johndoe
# - Configure GPG signing? (optional)
# - GPG key ID: (if GPG is configured)
# - Enable automatic GPG signing? (if GPG is configured)
```

#### Listing Profiles

```bash
# Show all profiles
gh-switch list

# Output:
# Available profiles:
# ==================
# * personal (active)
#     User: John Doe
#     Email: john@personal.com
#     GPG Key: ABCD1234EFGH5678
#     GPG Signing: Enabled
#   
#   work
#     User: John Smith
#     Email: john.smith@company.com
```

#### Switching Profiles

```bash
# Switch profile for current repository
gh-switch use work

# Switch globally (all new repos)
gh-switch use personal --global

# Check current profile
gh-switch current
```

### Working with Repositories

#### Cloning with Specific Profile

```bash
# Use personal profile for personal projects
gh-switch use personal
git clone git@github.com-personal:johndoe/my-project.git

# Use work profile for work projects
gh-switch use work
git clone git@github.com-work:company/work-project.git
```

#### Converting Existing Repository

```bash
# Go to existing repo
cd ~/projects/my-repo

# Switch to desired profile
gh-switch use personal

# The remote URL is automatically updated
git remote -v
# origin  git@github.com-personal:johndoe/my-repo.git
```

#### Auto-Detection

```bash
# Automatically detect profile from remote URL
cd ~/projects/some-repo
gh-switch auto
# Detects and switches to the appropriate profile
```

### Advanced Usage

#### Profile Management

```bash
# Delete a profile
gh-switch delete old-profile

# Edit profile (delete and re-add)
gh-switch delete work
gh-switch add work
```

#### SSH Key Testing

```bash
# Test personal account SSH connection
ssh -T git@github.com-personal
# Hi johndoe! You've successfully authenticated...

# Test work account SSH connection
ssh -T git@github.com-work
# Hi john-work! You've successfully authenticated...
```

## 📁 Configuration

### File Locations

```
~/.config/gh-switch/
├── config              # Main configuration
├── current             # Currently active profile
└── profiles/           # Profile storage
    ├── personal        # Personal profile config
    └── work           # Work profile config
```

### SSH Config Structure

gh-switch adds entries to `~/.ssh/config`:

```ssh
# GitHub account: personal
Host github.com-personal
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_personal
  IdentitiesOnly yes

# GitHub account: work
Host github.com-work
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_work
  IdentitiesOnly yes
```

### Profile Structure

Each profile stores:
- SSH key path
- Git user name
- Git email address
- GitHub username
- SSH host alias
- GPG signing key ID (optional)
- GPG auto-signing preference (optional)

## 🎨 Command Reference

| Command | Description | Example |
|---------|-------------|---------|
| `init` | Initialize gh-switch | `gh-switch init` |
| `add` | Add a new profile | `gh-switch add personal` |
| `use` | Switch to a profile | `gh-switch use work` |
| `current` | Show active profile | `gh-switch current` |
| `list` | List all profiles | `gh-switch list` |
| `delete` | Remove a profile | `gh-switch delete old` |
| `auto` | Auto-detect profile | `gh-switch auto` |
| `help` | Show help message | `gh-switch help` |

### Command Options

- `--global` - Apply profile globally (with `use` command)
- `--version` / `-v` - Show version information

## 🔧 Shell Aliases

Add to your `~/.bashrc` or `~/.zshrc` for quicker access:

```bash
# Quick aliases
alias ghs='gh-switch'
alias ghsp='gh-switch use personal'
alias ghsw='gh-switch use work'
alias ghsl='gh-switch list'
alias ghsc='gh-switch current'

# Function to clone with profile
ghclone() {
  local profile=$1
  local repo=$2
  gh-switch use $profile
  git clone $repo
}

# Usage: ghclone personal git@github.com-personal:user/repo.git
```

## 📋 Prerequisites

- **Git**: Version 2.0 or higher
- **OpenSSH**: Standard SSH client
- **Bash**: Version 4.0+ (macOS/Linux)
- **GitHub Account**: With SSH keys configured
- **GPG** (optional): For commit signing (gpg or gpg2)

### Setting Up SSH Keys

Before using gh-switch, ensure you have SSH keys for each GitHub account:

```bash
# Generate key for personal account
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_personal -C "personal@email.com"

# Generate key for work account
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_work -C "work@company.com"

# Add keys to SSH agent
ssh-add ~/.ssh/id_ed25519_personal
ssh-add ~/.ssh/id_ed25519_work
```

Then add each public key to the corresponding GitHub account's settings.

### Setting Up GPG Keys for Signed Commits

GitHub supports GPG-signed commits to verify your identity. gh-switch can manage GPG keys per profile.

#### Generating GPG Keys

```bash
# Generate a GPG key for personal account
gpg --full-generate-key
# Select: (1) RSA and RSA or (9) ECC and ECC
# Key size: 4096 (for RSA) or use default (for ECC)
# Expiration: Choose based on your security policy
# Real name: Your Name
# Email: personal@email.com

# Generate a GPG key for work account
gpg --full-generate-key
# Use your work email: work@company.com
```

#### List Your GPG Keys

```bash
# List all GPG keys with their IDs
gpg --list-secret-keys --keyid-format=long

# Output example:
# sec   rsa4096/ABCD1234EFGH5678 2024-01-01 [SC]
# uid                 [ultimate] Your Name <personal@email.com>
```

The key ID is the part after the `/` (e.g., `ABCD1234EFGH5678`).

#### Add GPG Key to GitHub

```bash
# Export your public GPG key
gpg --armor --export ABCD1234EFGH5678

# Copy the output (including BEGIN and END lines)
# Then add it to GitHub:
# 1. Go to GitHub Settings → SSH and GPG keys
# 2. Click "New GPG key"
# 3. Paste your public key
```

#### Configure GPG in gh-switch

When adding a new profile, gh-switch will prompt you to configure GPG signing:

```bash
gh-switch add personal

# You'll be prompted:
# - SSH key path
# - Git name
# - Git email
# - GitHub username
# - Configure GPG signing? (y/N)
# - GPG key ID: ABCD1234EFGH5678
# - Enable GPG signing for all commits? (Y/n)
```

For existing profiles, you can delete and re-add them with GPG support:

```bash
gh-switch delete personal
gh-switch add personal
```

#### Verify GPG Signing is Working

```bash
# Switch to your profile
gh-switch use personal

# Check current configuration
gh-switch current
# Should show:
#   GPG key: ABCD1234EFGH5678
#   GPG signing: Enabled

# Make a commit
git commit -m "Test signed commit"

# Verify the commit is signed
git log --show-signature -1
# Should show "Good signature from ..."
```

#### Manual GPG Configuration

If you prefer to manually sign specific commits:

1. When configuring GPG in gh-switch, answer "n" to "Enable GPG signing for all commits?"
2. This sets up the signing key but doesn't auto-sign
3. Sign individual commits with: `git commit -S -m "Your message"`

#### GPG Troubleshooting

**Issue: "gpg: signing failed: No secret key"**
```bash
# Ensure the key is in your keyring
gpg --list-secret-keys

# If missing, import it
gpg --import your-private-key.asc
```

**Issue: "gpg: signing failed: Inappropriate ioctl for device"**
```bash
# Add to ~/.bashrc or ~/.zshrc
export GPG_TTY=$(tty)

# Or use gpg-agent
echo 'use-agent' >> ~/.gnupg/gpg.conf
```

**Issue: Commits not showing as verified on GitHub**
- Ensure the GPG key email matches the commit email
- Check that the public key is added to your GitHub account
- The key must not be expired or revoked

## 🧪 Typical Workflows

### Daily Development

```bash
# Morning - work on company project
cd ~/work/company-api
gh-switch use work
git pull origin main
# ... do work, commits use work identity

# Afternoon - personal project
cd ~/personal/side-project
gh-switch use personal
git pull origin main
# ... commits use personal identity

# Check active profile anytime
gh-switch current
```

### New Project Setup

```bash
# Personal project
gh-switch use personal
mkdir ~/projects/new-app
cd ~/projects/new-app
git init
git remote add origin git@github.com-personal:johndoe/new-app.git

# Work project
gh-switch use work
mkdir ~/work/new-service
cd ~/work/new-service
git init
git remote add origin git@github.com-work:company/new-service.git
```

### Migrating Existing Repositories

```bash
# List current remotes
cd ~/projects/existing-repo
git remote -v
# origin git@github.com:johndoe/existing-repo.git

# Switch to profile
gh-switch use personal

# Remote is automatically updated
git remote -v
# origin git@github.com-personal:johndoe/existing-repo.git
```

## 🐛 Troubleshooting

### Common Issues

**Issue: "command not found"**
```bash
# Check installation
which gh-switch

# Ensure /usr/local/bin is in PATH
echo $PATH

# Reinstall if needed
sudo cp bin/gh-switch-standalone /usr/local/bin/gh-switch
```

**Issue: "Permission denied (publickey)"**
```bash
# Check SSH key is loaded
ssh-add -l

# Add key to agent
ssh-add ~/.ssh/your_key

# Test connection
ssh -T git@github.com-personal
```

**Issue: "Not in a git repository"**
```bash
# For local repository changes
cd your-git-repo
gh-switch use profile-name

# For global changes
gh-switch use profile-name --global
```

**Issue: SSH config already has entries**
```bash
# Backup is created automatically
ls ~/.ssh/config.gh-switch.backup

# Manually restore if needed
cp ~/.ssh/config.gh-switch.backup ~/.ssh/config
```

### Debug Commands

```bash
# Check profile details
cat ~/.config/gh-switch/profiles/personal

# View current profile
cat ~/.config/gh-switch/current

# Check SSH config entries
grep "github.com-" ~/.ssh/config

# Test SSH authentication
ssh -vT git@github.com-personal  # Verbose output
```

## 🤝 Contributing

We follow a small PR philosophy - each PR should be 40-80 lines max:

1. Fork the repository
2. Create your feature branch (`git checkout -b feat/amazing-feature`)
3. Keep changes focused and minimal
4. Test thoroughly on macOS and Linux
5. Submit a Pull Request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## 📄 Project Structure

```
gh-switch/
├── bin/
│   ├── gh-switch              # Main script (development)
│   └── gh-switch-standalone   # Standalone version
├── lib/
│   ├── common.sh              # Common utilities
│   ├── profile.sh             # Profile management
│   ├── ssh_parser.sh          # SSH config parsing
│   ├── ssh_writer.sh          # SSH config writing
│   ├── git_config.sh          # Git configuration
│   └── cmd_*.sh               # Command implementations
├── completions/
│   ├── gh-switch.bash         # Bash completion
│   └── gh-switch.zsh          # Zsh completion
├── tests/
│   └── test_basic.sh          # Test suite
├── install.sh                 # Installation script
├── Makefile                   # Make targets
└── README.md                  # This file
```

## 🚀 Uninstallation

```bash
# Remove the binary
sudo rm /usr/local/bin/gh-switch

# Remove configuration (optional - preserves profiles)
rm -rf ~/.config/gh-switch

# Remove SSH config entries (manual review recommended)
# Edit ~/.ssh/config and remove gh-switch sections
```

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

Built with pure shell scripting for maximum compatibility and zero dependencies.

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/TheDevOpsBlueprint/gh-switch/issues)
- **Discussions**: [GitHub Discussions](https://github.com/TheDevOpsBlueprint/gh-switch/discussions)
- **Author**: Valentin Todorov

---

**Note**: This tool modifies your SSH config and Git settings. Always review changes and maintain backups of important configurations.