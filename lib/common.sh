#!/usr/bin/env bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Config paths
GH_SWITCH_DIR="${HOME}/.config/gh-switch"
PROFILES_DIR="${GH_SWITCH_DIR}/profiles"
CONFIG_FILE="${GH_SWITCH_DIR}/config"
SSH_CONFIG="${HOME}/.ssh/config"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Ensure config directory exists
ensure_config_dir() {
    mkdir -p "${GH_SWITCH_DIR}"
    mkdir -p "${PROFILES_DIR}"
}