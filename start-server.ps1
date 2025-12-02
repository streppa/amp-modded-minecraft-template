#!/usr/bin/env pwsh
# AMP Minecraft Modpack Server Startup Wrapper
# This script handles modpack installation before starting the server

param(
    [Parameter(Mandatory=$false)]
    [string]$JavaArgs = ""
)

$ErrorActionPreference = "Stop"

# Get AMP configuration directory
$AMP_DIR = Split-Path -Parent $PSScriptRoot
$SERVER_DIR = Join-Path $AMP_DIR "minecraft"
$CONFIG_FILE = Join-Path $AMP_DIR ".amp-config.json"

function Write-Log($message, $color = "White") {
    Write-Host "[AMP-MODPACK] $message" -ForegroundColor $color
}

# Read AMP configuration
$Config = @{
    ModpackPlatform = "none"
    ModpackID = ""
    ModpackVersion = "latest"
    InstallModpack = $false
    AutoInstall = $false
    ServerJar = "server.jar"
}

# Try to read config from AMP settings
if (Test-Path $CONFIG_FILE) {
    try {
        $ampConfig = Get-Content $CONFIG_FILE -Raw | ConvertFrom-Json
        if ($ampConfig.ModpackPlatform) { $Config.ModpackPlatform = $ampConfig.ModpackPlatform }
        if ($ampConfig.ModpackID) { $Config.ModpackID = $ampConfig.ModpackID }
        if ($ampConfig.ModpackVersion) { $Config.ModpackVersion = $ampConfig.ModpackVersion }
        if ($ampConfig.InstallModpack) { $Config.InstallModpack = $ampConfig.InstallModpack }
        if ($ampConfig.AutoInstall) { $Config.AutoInstall = $ampConfig.AutoInstall }
        if ($ampConfig.ServerJar) { $Config.ServerJar = $ampConfig.ServerJar }
    }
    catch {
        Write-Log "Could not read AMP config, using defaults" "Yellow"
    }
}

# Check if we need to install/update modpack
$shouldInstall = $false

if ($Config.InstallModpack -eq $true) {
    Write-Log "Install Modpack flag is set" "Cyan"
    $shouldInstall = $true
}
elseif ($Config.AutoInstall -eq $true) {
    Write-Log "Auto-Install is enabled, checking for updates..." "Cyan"
    $shouldInstall = $true
}

# Run modpack installation if needed
if ($shouldInstall -and $Config.ModpackPlatform -ne "none" -and $Config.ModpackID -ne "") {
    Write-Log "Installing modpack from $($Config.ModpackPlatform)..." "Green"

    $installerScript = Join-Path $PSScriptRoot "modpack-install.ps1"

    if (Test-Path $installerScript) {
        try {
            & $installerScript `
                -Platform $Config.ModpackPlatform `
                -ModpackID $Config.ModpackID `
                -Version $Config.ModpackVersion `
                -InstallPath $SERVER_DIR

            Write-Log "Modpack installation completed" "Green"

            # Clear the install flag
            if ($Config.InstallModpack -eq $true) {
                $Config.InstallModpack = $false
                $Config | ConvertTo-Json | Set-Content $CONFIG_FILE
                Write-Log "Cleared install flag" "Cyan"
            }

            # Check if ServerJar.txt was created by installer
            $serverJarFile = Join-Path $SERVER_DIR "ServerJar.txt"
            if (Test-Path $serverJarFile) {
                $detectedJar = Get-Content $serverJarFile -Raw
                $detectedJar = $detectedJar.Trim()
                if ($detectedJar) {
                    Write-Log "Detected server JAR: $detectedJar" "Green"
                    $Config.ServerJar = $detectedJar
                }
            }
        }
        catch {
            Write-Log "Modpack installation failed: $_" "Red"
            Write-Log "Continuing with existing server files..." "Yellow"
        }
    }
    else {
        Write-Log "Installer script not found: $installerScript" "Red"
    }
}

# Accept EULA automatically
$eulaFile = Join-Path $SERVER_DIR "eula.txt"
if (-not (Test-Path $eulaFile) -or (Select-String -Path $eulaFile -Pattern "eula=false" -Quiet)) {
    Write-Log "Accepting Minecraft EULA..." "Cyan"
    "eula=true" | Set-Content $eulaFile
}

# Check if server JAR exists
$serverJarPath = Join-Path $SERVER_DIR $Config.ServerJar

if (-not (Test-Path $serverJarPath)) {
    Write-Log "Server JAR not found: $serverJarPath" "Red"
    Write-Log "Please install a modpack or place server files manually" "Yellow"

    # Look for any JAR file
    $foundJars = Get-ChildItem -Path $SERVER_DIR -Filter "*.jar" -File | Where-Object { $_.Name -match "server|forge|fabric|forge|quilt|neoforge" }

    if ($foundJars.Count -gt 0) {
        $Config.ServerJar = $foundJars[0].Name
        Write-Log "Found alternative JAR: $($Config.ServerJar)" "Green"
        $serverJarPath = $foundJars[0].FullName
    }
    else {
        Write-Log "No server JAR files found. Cannot start server." "Red"
        exit 1
    }
}

Write-Log "Using server JAR: $($Config.ServerJar)" "Green"
Write-Log "Starting Minecraft server..." "Cyan"

# Note: The actual Java command will be handled by AMP based on the KVP configuration
# This script is primarily for pre-start setup
exit 0
