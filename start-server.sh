#!/bin/bash
# AMP Minecraft Modpack Server Startup Wrapper
# This script handles modpack installation before starting the server

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log() {
    echo -e "${CYAN}[AMP-MODPACK]${NC} $1"
}

log_error() {
    echo -e "${RED}[AMP-MODPACK]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[AMP-MODPACK]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[AMP-MODPACK]${NC} $1"
}

# Get directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AMP_DIR="$(dirname "$SCRIPT_DIR")"
SERVER_DIR="$AMP_DIR/minecraft"
CONFIG_FILE="$AMP_DIR/.amp-config.json"

# Default configuration
MODPACK_PLATFORM="none"
MODPACK_ID=""
MODPACK_VERSION="latest"
INSTALL_MODPACK=false
AUTO_INSTALL=false
SERVER_JAR="server.jar"

# Read AMP configuration
if [ -f "$CONFIG_FILE" ]; then
    log "Reading configuration from $CONFIG_FILE"

    if command -v jq &> /dev/null; then
        # Use jq for better JSON parsing
        MODPACK_PLATFORM=$(jq -r '.ModpackPlatform // "none"' "$CONFIG_FILE")
        MODPACK_ID=$(jq -r '.ModpackID // ""' "$CONFIG_FILE")
        MODPACK_VERSION=$(jq -r '.ModpackVersion // "latest"' "$CONFIG_FILE")
        INSTALL_MODPACK=$(jq -r '.InstallModpack // false' "$CONFIG_FILE")
        AUTO_INSTALL=$(jq -r '.AutoInstall // false' "$CONFIG_FILE")
        SERVER_JAR=$(jq -r '.ServerJar // "server.jar"' "$CONFIG_FILE")
    else
        # Fallback to grep/sed parsing
        MODPACK_PLATFORM=$(grep -o '"ModpackPlatform"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" 2>/dev/null | sed 's/.*"\([^"]*\)"/\1/' || echo "none")
        MODPACK_ID=$(grep -o '"ModpackID"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" 2>/dev/null | sed 's/.*"\([^"]*\)"/\1/' || echo "")
        MODPACK_VERSION=$(grep -o '"ModpackVersion"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" 2>/dev/null | sed 's/.*"\([^"]*\)"/\1/' || echo "latest")
        SERVER_JAR=$(grep -o '"ServerJar"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" 2>/dev/null | sed 's/.*"\([^"]*\)"/\1/' || echo "server.jar")
    fi
fi

# Check if we need to install/update modpack
SHOULD_INSTALL=false

if [ "$INSTALL_MODPACK" = "true" ]; then
    log "Install Modpack flag is set"
    SHOULD_INSTALL=true
elif [ "$AUTO_INSTALL" = "true" ]; then
    log "Auto-Install is enabled, checking for updates..."
    SHOULD_INSTALL=true
fi

# Run modpack installation if needed
if [ "$SHOULD_INSTALL" = "true" ] && [ "$MODPACK_PLATFORM" != "none" ] && [ -n "$MODPACK_ID" ]; then
    log_success "Installing modpack from $MODPACK_PLATFORM..."

    INSTALLER_SCRIPT="$SCRIPT_DIR/modpack-install.sh"

    if [ -f "$INSTALLER_SCRIPT" ]; then
        # Make installer executable
        chmod +x "$INSTALLER_SCRIPT"

        # Run installer
        if "$INSTALLER_SCRIPT" "$MODPACK_PLATFORM" "$MODPACK_ID" "$MODPACK_VERSION" "$SERVER_DIR"; then
            log_success "Modpack installation completed"

            # Clear the install flag
            if [ "$INSTALL_MODPACK" = "true" ] && command -v jq &> /dev/null; then
                jq '.InstallModpack = false' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
                log "Cleared install flag"
            fi

            # Check if ServerJar.txt was created by installer
            SERVER_JAR_FILE="$SERVER_DIR/ServerJar.txt"
            if [ -f "$SERVER_JAR_FILE" ]; then
                DETECTED_JAR=$(cat "$SERVER_JAR_FILE" | tr -d '\n\r')
                if [ -n "$DETECTED_JAR" ]; then
                    log_success "Detected server JAR: $DETECTED_JAR"
                    SERVER_JAR="$DETECTED_JAR"
                fi
            fi
        else
            log_error "Modpack installation failed"
            log_warning "Continuing with existing server files..."
        fi
    else
        log_error "Installer script not found: $INSTALLER_SCRIPT"
    fi
fi

# Accept EULA automatically
EULA_FILE="$SERVER_DIR/eula.txt"
if [ ! -f "$EULA_FILE" ] || grep -q "eula=false" "$EULA_FILE"; then
    log "Accepting Minecraft EULA..."
    echo "eula=true" > "$EULA_FILE"
fi

# Check if server JAR exists
SERVER_JAR_PATH="$SERVER_DIR/$SERVER_JAR"

if [ ! -f "$SERVER_JAR_PATH" ]; then
    log_error "Server JAR not found: $SERVER_JAR_PATH"
    log_warning "Please install a modpack or place server files manually"

    # Look for any JAR file
    FOUND_JAR=$(find "$SERVER_DIR" -maxdepth 1 -name "*.jar" -type f | grep -E "(server|forge|fabric|quilt|neoforge)" | head -1)

    if [ -n "$FOUND_JAR" ]; then
        SERVER_JAR=$(basename "$FOUND_JAR")
        log_success "Found alternative JAR: $SERVER_JAR"
        SERVER_JAR_PATH="$FOUND_JAR"
    else
        log_error "No server JAR files found. Cannot start server."
        exit 1
    fi
fi

log_success "Using server JAR: $SERVER_JAR"
log "Starting Minecraft server..."

# Note: The actual Java command will be handled by AMP based on the KVP configuration
# This script is primarily for pre-start setup
exit 0
