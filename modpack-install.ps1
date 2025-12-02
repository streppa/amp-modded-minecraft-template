#!/usr/bin/env pwsh
# Minecraft Modpack Installer for AMP
# Supports CurseForge and Modrinth modpacks

param(
    [Parameter(Mandatory=$false)]
    [string]$Platform = "none",

    [Parameter(Mandatory=$false)]
    [string]$ModpackID = "",

    [Parameter(Mandatory=$false)]
    [string]$Version = "latest",

    [Parameter(Mandatory=$false)]
    [string]$InstallPath = "./minecraft"
)

$ErrorActionPreference = "Stop"

# API endpoints
$CURSEFORGE_API = "https://api.curseforge.com/v1"
$MODRINTH_API = "https://api.modrinth.com/v2"

# Colors for output
function Write-Info($message) {
    Write-Host "[INFO] $message" -ForegroundColor Cyan
}

function Write-Success($message) {
    Write-Host "[SUCCESS] $message" -ForegroundColor Green
}

function Write-Error($message) {
    Write-Host "[ERROR] $message" -ForegroundColor Red
}

function Write-Warning($message) {
    Write-Host "[WARNING] $message" -ForegroundColor Yellow
}

# Download file with progress
function Download-File($url, $output) {
    Write-Info "Downloading: $url"
    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($url, $output)
        Write-Success "Downloaded: $output"
        return $true
    }
    catch {
        Write-Error "Failed to download: $_"
        return $false
    }
}

# Extract ZIP archive
function Extract-Archive($zipPath, $destination) {
    Write-Info "Extracting: $zipPath"
    try {
        if (Test-Path $destination) {
            Remove-Item -Path $destination -Recurse -Force -ErrorAction SilentlyContinue
        }
        Expand-Archive -Path $zipPath -DestinationPath $destination -Force
        Write-Success "Extracted to: $destination"
        return $true
    }
    catch {
        Write-Error "Failed to extract: $_"
        return $false
    }
}

# Install modpack from CurseForge
function Install-CurseForgeModpack {
    param($projectId, $fileId)

    Write-Info "Installing CurseForge modpack (Project: $projectId, File: $fileId)"

    # Note: CurseForge API requires an API key which users need to obtain
    # For now, we'll use direct download links if available
    Write-Warning "CurseForge installation requires manual setup or API key"
    Write-Info "Please download the server files from CurseForge and place them in: $InstallPath"
    Write-Info "Visit: https://www.curseforge.com/minecraft/modpacks/$projectId"

    # Alternative: Use CurseForge API if API key is provided
    # This is a placeholder for API integration
    if ($env:CURSEFORGE_API_KEY) {
        Write-Info "Using CurseForge API key..."

        $headers = @{
            "x-api-key" = $env:CURSEFORGE_API_KEY
        }

        try {
            # Get project info
            $projectUrl = "$CURSEFORGE_API/mods/$projectId"
            $projectInfo = Invoke-RestMethod -Uri $projectUrl -Headers $headers
            Write-Info "Modpack: $($projectInfo.data.name)"

            # Get file info
            if ($fileId -eq "latest") {
                $filesUrl = "$CURSEFORGE_API/mods/$projectId/files"
                $filesInfo = Invoke-RestMethod -Uri $filesUrl -Headers $headers
                $latestFile = $filesInfo.data | Sort-Object -Property fileDate -Descending | Select-Object -First 1
                $fileId = $latestFile.id
            }

            $fileUrl = "$CURSEFORGE_API/mods/$projectId/files/$fileId"
            $fileInfo = Invoke-RestMethod -Uri $fileUrl -Headers $headers

            $downloadUrl = $fileInfo.data.downloadUrl
            $fileName = $fileInfo.data.fileName

            Write-Info "Downloading: $fileName"
            $downloadPath = Join-Path $InstallPath $fileName

            if (Download-File $downloadUrl $downloadPath) {
                # Extract modpack
                $extractPath = Join-Path $InstallPath "modpack_temp"
                if (Extract-Archive $downloadPath $extractPath) {
                    # Look for server files or installation script
                    $serverFiles = Get-ChildItem -Path $extractPath -Filter "server*" -Recurse
                    if ($serverFiles) {
                        Write-Info "Found server files, installing..."
                        # Copy server files to installation directory
                        Copy-Item -Path "$extractPath\*" -Destination $InstallPath -Recurse -Force
                        Write-Success "Modpack installed successfully"
                    }
                    else {
                        Write-Warning "No server files found. Manual setup may be required."
                    }

                    # Cleanup
                    Remove-Item -Path $extractPath -Recurse -Force
                    Remove-Item -Path $downloadPath -Force
                }
            }
        }
        catch {
            Write-Error "Failed to install from CurseForge: $_"
            return $false
        }
    }
    else {
        Write-Warning "Set CURSEFORGE_API_KEY environment variable for automatic downloads"
        Write-Info "Get your API key from: https://console.curseforge.com/"
        return $false
    }

    return $true
}

# Install modpack from Modrinth
function Install-ModrinthModpack {
    param($projectId, $versionId)

    Write-Info "Installing Modrinth modpack: $projectId"

    try {
        # Get project info
        $projectUrl = "$MODRINTH_API/project/$projectId"
        $projectInfo = Invoke-RestMethod -Uri $projectUrl -Method Get
        Write-Info "Modpack: $($projectInfo.title)"
        Write-Info "Description: $($projectInfo.description)"

        # Get versions
        $versionsUrl = "$MODRINTH_API/project/$projectId/version"
        $versions = Invoke-RestMethod -Uri $versionsUrl -Method Get

        # Filter for server versions
        $serverVersions = $versions | Where-Object {
            $_.loaders -contains "minecraft" -or
            $_.loaders -contains "forge" -or
            $_.loaders -contains "fabric" -or
            $_.loaders -contains "quilt" -or
            $_.loaders -contains "neoforge"
        }

        if ($serverVersions.Count -eq 0) {
            Write-Error "No server versions found for this modpack"
            return $false
        }

        # Select version
        $selectedVersion = $null
        if ($versionId -eq "latest") {
            $selectedVersion = $serverVersions | Sort-Object -Property date_published -Descending | Select-Object -First 1
        }
        else {
            $selectedVersion = $serverVersions | Where-Object { $_.id -eq $versionId -or $_.version_number -eq $versionId } | Select-Object -First 1
        }

        if (-not $selectedVersion) {
            Write-Error "Version not found: $versionId"
            return $false
        }

        Write-Info "Version: $($selectedVersion.version_number) ($($selectedVersion.name))"
        Write-Info "Game Versions: $($selectedVersion.game_versions -join ', ')"
        Write-Info "Loaders: $($selectedVersion.loaders -join ', ')"

        # Find server file
        $serverFile = $selectedVersion.files | Where-Object {
            $_.filename -match "server" -or $_.primary
        } | Select-Object -First 1

        if (-not $serverFile) {
            $serverFile = $selectedVersion.files | Select-Object -First 1
        }

        Write-Info "Downloading: $($serverFile.filename)"

        # Create install directory
        if (-not (Test-Path $InstallPath)) {
            New-Item -Path $InstallPath -ItemType Directory -Force | Out-Null
        }

        # Download modpack file
        $downloadPath = Join-Path $InstallPath $serverFile.filename
        if (Download-File $serverFile.url $downloadPath) {
            Write-Success "Downloaded modpack file"

            # If it's a ZIP/MRPack file, extract it
            if ($serverFile.filename -match "\.(zip|mrpack)$") {
                Write-Info "Extracting modpack..."
                $extractPath = Join-Path $InstallPath "modpack_temp"

                if (Extract-Archive $downloadPath $extractPath) {
                    # Look for server start script or JAR
                    $startScript = Get-ChildItem -Path $extractPath -Filter "start.*" -File | Select-Object -First 1
                    $serverJar = Get-ChildItem -Path $extractPath -Filter "*.jar" -File | Where-Object { $_.Name -match "server|forge|fabric" } | Select-Object -First 1

                    # Copy all files to install directory
                    Write-Info "Installing modpack files..."
                    Get-ChildItem -Path $extractPath | ForEach-Object {
                        Copy-Item -Path $_.FullName -Destination $InstallPath -Recurse -Force
                    }

                    # Cleanup
                    Remove-Item -Path $extractPath -Recurse -Force
                    Remove-Item -Path $downloadPath -Force

                    # Find and report server JAR
                    $installedJar = Get-ChildItem -Path $InstallPath -Filter "*.jar" -File | Where-Object { $_.Name -match "server|forge|fabric" } | Select-Object -First 1
                    if ($installedJar) {
                        Write-Success "Server JAR found: $($installedJar.Name)"
                        # Update AMP config with server JAR name
                        $configPath = Join-Path $InstallPath "ServerJar.txt"
                        $installedJar.Name | Out-File -FilePath $configPath -Encoding UTF8
                    }

                    Write-Success "Modpack installed successfully!"
                    return $true
                }
            }
            else {
                Write-Info "Downloaded file is not an archive. May need manual setup."
            }
        }
    }
    catch {
        Write-Error "Failed to install from Modrinth: $_"
        Write-Error $_.Exception.Message
        return $false
    }

    return $false
}

# Main installation logic
function Install-Modpack {
    Write-Info "=== Minecraft Modpack Installer ==="
    Write-Info "Platform: $Platform"
    Write-Info "Modpack ID: $ModpackID"
    Write-Info "Version: $Version"
    Write-Info "Install Path: $InstallPath"
    Write-Info ""

    if ($Platform -eq "none" -or [string]::IsNullOrWhiteSpace($ModpackID)) {
        Write-Warning "No modpack specified. Please configure modpack settings in AMP."
        return $false
    }

    # Create installation directory
    if (-not (Test-Path $InstallPath)) {
        New-Item -Path $InstallPath -ItemType Directory -Force | Out-Null
        Write-Info "Created installation directory: $InstallPath"
    }

    # Install based on platform
    $success = $false
    switch ($Platform.ToLower()) {
        "curseforge" {
            $success = Install-CurseForgeModpack -projectId $ModpackID -fileId $Version
        }
        "modrinth" {
            $success = Install-ModrinthModpack -projectId $ModpackID -versionId $Version
        }
        default {
            Write-Error "Unknown platform: $Platform"
            return $false
        }
    }

    if ($success) {
        Write-Success "=== Installation Complete ==="
        Write-Info "Please restart the server to apply changes."
    }
    else {
        Write-Error "=== Installation Failed ==="
    }

    return $success
}

# Run installer
Install-Modpack
