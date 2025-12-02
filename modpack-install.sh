#!/bin/bash
# Minecraft Modpack Installer for AMP (Linux)
# Supports CurseForge and Modrinth modpacks

set -e

# Default values
PLATFORM="${1:-none}"
MODPACK_ID="${2:-}"
VERSION="${3:-latest}"
INSTALL_PATH="${4:-./minecraft}"

# API endpoints
CURSEFORGE_API="https://api.curseforge.com/v1"
MODRINTH_API="https://api.modrinth.com/v2"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Download file with curl or wget
download_file() {
    local url="$1"
    local output="$2"

    log_info "Downloading: $url"

    if command -v curl &> /dev/null; then
        curl -L -o "$output" "$url" && log_success "Downloaded: $output" && return 0
    elif command -v wget &> /dev/null; then
        wget -O "$output" "$url" && log_success "Downloaded: $output" && return 0
    else
        log_error "Neither curl nor wget is available"
        return 1
    fi
}

# Extract archive
extract_archive() {
    local archive="$1"
    local destination="$2"

    log_info "Extracting: $archive"

    mkdir -p "$destination"

    if [[ "$archive" =~ \.(zip|mrpack)$ ]]; then
        if command -v unzip &> /dev/null; then
            unzip -o "$archive" -d "$destination" && log_success "Extracted to: $destination" && return 0
        else
            log_error "unzip is not available"
            return 1
        fi
    elif [[ "$archive" =~ \.tar\.gz$ ]]; then
        tar -xzf "$archive" -C "$destination" && log_success "Extracted to: $destination" && return 0
    elif [[ "$archive" =~ \.tar$ ]]; then
        tar -xf "$archive" -C "$destination" && log_success "Extracted to: $destination" && return 0
    else
        log_error "Unknown archive format: $archive"
        return 1
    fi
}

# Install CurseForge modpack
install_curseforge_modpack() {
    local project_id="$1"
    local file_id="$2"

    log_info "Installing CurseForge modpack (Project: $project_id, File: $file_id)"

    if [ -z "$CURSEFORGE_API_KEY" ]; then
        log_warning "CurseForge installation requires an API key"
        log_info "Set CURSEFORGE_API_KEY environment variable"
        log_info "Get your API key from: https://console.curseforge.com/"
        log_info "Visit modpack page: https://www.curseforge.com/minecraft/modpacks/$project_id"
        return 1
    fi

    log_info "Using CurseForge API key..."

    # Get project info
    local project_url="$CURSEFORGE_API/mods/$project_id"
    local project_info=$(curl -s -H "x-api-key: $CURSEFORGE_API_KEY" "$project_url")

    if [ $? -ne 0 ]; then
        log_error "Failed to fetch project info"
        return 1
    fi

    local modpack_name=$(echo "$project_info" | grep -o '"name":"[^"]*"' | head -1 | cut -d'"' -f4)
    log_info "Modpack: $modpack_name"

    # Get file info
    if [ "$file_id" == "latest" ]; then
        local files_url="$CURSEFORGE_API/mods/$project_id/files"
        local files_info=$(curl -s -H "x-api-key: $CURSEFORGE_API_KEY" "$files_url")
        file_id=$(echo "$files_info" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
    fi

    local file_url="$CURSEFORGE_API/mods/$project_id/files/$file_id"
    local file_info=$(curl -s -H "x-api-key: $CURSEFORGE_API_KEY" "$file_url")

    local download_url=$(echo "$file_info" | grep -o '"downloadUrl":"[^"]*"' | cut -d'"' -f4)
    local file_name=$(echo "$file_info" | grep -o '"fileName":"[^"]*"' | cut -d'"' -f4)

    if [ -z "$download_url" ]; then
        log_error "Failed to get download URL"
        return 1
    fi

    log_info "Downloading: $file_name"

    mkdir -p "$INSTALL_PATH"
    local download_path="$INSTALL_PATH/$file_name"

    if download_file "$download_url" "$download_path"; then
        local extract_path="$INSTALL_PATH/modpack_temp"

        if extract_archive "$download_path" "$extract_path"; then
            # Copy server files
            log_info "Installing server files..."
            cp -r "$extract_path"/* "$INSTALL_PATH/"

            # Cleanup
            rm -rf "$extract_path"
            rm -f "$download_path"

            log_success "Modpack installed successfully"
            return 0
        fi
    fi

    return 1
}

# Install Modrinth modpack
install_modrinth_modpack() {
    local project_id="$1"
    local version_id="$2"

    log_info "Installing Modrinth modpack: $project_id"

    # Get project info
    local project_url="$MODRINTH_API/project/$project_id"
    local project_info=$(curl -s "$project_url")

    if [ $? -ne 0 ]; then
        log_error "Failed to fetch project info"
        return 1
    fi

    local modpack_title=$(echo "$project_info" | grep -o '"title":"[^"]*"' | head -1 | cut -d'"' -f4)
    log_info "Modpack: $modpack_title"

    # Get versions
    local versions_url="$MODRINTH_API/project/$project_id/version"
    local versions=$(curl -s "$versions_url")

    if [ $? -ne 0 ]; then
        log_error "Failed to fetch versions"
        return 1
    fi

    # Parse JSON to get version info (simplified)
    local selected_version=""
    if [ "$version_id" == "latest" ]; then
        # Get first version (latest)
        selected_version=$(echo "$versions" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
    else
        # Find specific version
        selected_version="$version_id"
    fi

    log_info "Version ID: $selected_version"

    # Get version details
    local version_url="$MODRINTH_API/version/$selected_version"
    local version_info=$(curl -s "$version_url")

    if [ $? -ne 0 ]; then
        log_error "Failed to fetch version info"
        return 1
    fi

    local version_number=$(echo "$version_info" | grep -o '"version_number":"[^"]*"' | head -1 | cut -d'"' -f4)
    log_info "Version: $version_number"

    # Extract file info (get first file URL)
    local file_url=$(echo "$version_info" | grep -o '"url":"https://[^"]*"' | head -1 | cut -d'"' -f4)
    local file_name=$(echo "$version_info" | grep -o '"filename":"[^"]*"' | head -1 | cut -d'"' -f4)

    if [ -z "$file_url" ]; then
        log_error "Failed to get download URL"
        return 1
    fi

    log_info "Downloading: $file_name"

    mkdir -p "$INSTALL_PATH"
    local download_path="$INSTALL_PATH/$file_name"

    if download_file "$file_url" "$download_path"; then
        # If it's a ZIP/MRPack file, extract it
        if [[ "$file_name" =~ \.(zip|mrpack)$ ]]; then
            log_info "Extracting modpack..."
            local extract_path="$INSTALL_PATH/modpack_temp"

            if extract_archive "$download_path" "$extract_path"; then
                # Copy all files to install directory
                log_info "Installing modpack files..."
                cp -r "$extract_path"/* "$INSTALL_PATH/"

                # Find server JAR
                local server_jar=$(find "$INSTALL_PATH" -maxdepth 1 -name "*.jar" -type f | grep -E "(server|forge|fabric)" | head -1)

                if [ -n "$server_jar" ]; then
                    local jar_name=$(basename "$server_jar")
                    log_success "Server JAR found: $jar_name"
                    echo "$jar_name" > "$INSTALL_PATH/ServerJar.txt"
                fi

                # Cleanup
                rm -rf "$extract_path"
                rm -f "$download_path"

                log_success "Modpack installed successfully!"
                return 0
            fi
        else
            log_info "Downloaded file is not an archive. May need manual setup."
        fi
    fi

    return 1
}

# Main installation function
install_modpack() {
    log_info "=== Minecraft Modpack Installer ==="
    log_info "Platform: $PLATFORM"
    log_info "Modpack ID: $MODPACK_ID"
    log_info "Version: $VERSION"
    log_info "Install Path: $INSTALL_PATH"
    echo ""

    if [ "$PLATFORM" == "none" ] || [ -z "$MODPACK_ID" ]; then
        log_warning "No modpack specified. Please configure modpack settings in AMP."
        return 1
    fi

    # Create installation directory
    mkdir -p "$INSTALL_PATH"
    log_info "Installation directory: $INSTALL_PATH"

    # Install based on platform
    case "${PLATFORM,,}" in
        curseforge)
            install_curseforge_modpack "$MODPACK_ID" "$VERSION"
            ;;
        modrinth)
            install_modrinth_modpack "$MODPACK_ID" "$VERSION"
            ;;
        *)
            log_error "Unknown platform: $PLATFORM"
            return 1
            ;;
    esac

    if [ $? -eq 0 ]; then
        log_success "=== Installation Complete ==="
        log_info "Please restart the server to apply changes."
        return 0
    else
        log_error "=== Installation Failed ==="
        return 1
    fi
}

# Make scripts executable if needed
chmod +x "$0" 2>/dev/null || true

# Run installer
install_modpack
