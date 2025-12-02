# Minecraft Modpack Server Template for AMP

This is a custom AMP (Application Management Panel) template for running Minecraft servers with modpacks from **CurseForge** and **Modrinth**.

## Files Included

- `minecraftmodpack.kvp` - Main template configuration
- `minecraftmodpackconfig.json` - Server settings manifest
- `minecraftmodpackports.json` - Port configuration
- `modpack-install.ps1` - PowerShell installer script (Windows)
- `modpack-install.sh` - Bash installer script (Linux)

## Installation

### 1. Copy Template Files

Copy all template files to your AMP templates directory:

**Windows:**
```
C:\AMP\AMPTemplates\
```

**Linux:**
```
/home/amp/.ampdata/AMPTemplates/
```

**Important:** Make sure the installation scripts are executable on Linux:
```bash
chmod +x /home/amp/.ampdata/AMPTemplates/modpack-install.sh
```

### 2. Import Template in AMP

1. Open AMP web interface
2. Go to **Instances** → **Create Instance**
3. Select **Generic Module** as the application type
4. Choose the **minecraftmodpack** template from the dropdown
5. Name your instance (e.g., "Modpack Server")
6. Click **Create**

## How Installation Works

This template uses AMP's **Update System** to trigger modpack installation. Here's the workflow:

1. You configure modpack settings in the GUI
2. You check the **"Install Modpack"** checkbox
3. You click the **"Update"** button in AMP (NOT the Start button)
4. AMP's update system triggers the installation script:
   - On Windows: Runs `modpack-install.ps1` via PowerShell
   - On Linux: Runs `modpack-install.sh` via Bash
5. The script downloads and installs the modpack
6. Once complete, you can start the server normally

**Key Point:** Use the **Update button** in AMP to trigger modpack installation, not the Start button!

## Using the Template

### How It Works

This template allows you to **choose a modpack in the AMP GUI** and have it **automatically download and set up** the modded Minecraft server. Here's what happens:

1. **You configure** the modpack settings in the AMP web interface
2. **You check the "Install Modpack" box** and apply settings
3. **The template automatically**:
   - Downloads the modpack from CurseForge or Modrinth
   - Extracts server files
   - Detects and configures the server JAR
   - Sets up all necessary files
   - Prepares the server for startup

No manual file downloads or extractions needed - it's all done through the GUI!

### Modrinth Modpacks (Recommended - Easiest)

Modrinth is the easiest option as it doesn't require an API key and has excellent API support.

#### Step-by-Step:

1. **Find a modpack** on Modrinth
   - Example: https://modrinth.com/modpack/better-minecraft
   - Or browse: https://modrinth.com/modpacks

2. **Get the project slug** from the URL
   - URL: `https://modrinth.com/modpack/better-minecraft`
   - Slug: `better-minecraft`

3. **Open AMP** and go to your Minecraft Modpack server instance

4. **Go to Configuration** → Click on the **Modpack** section

5. **Fill in the settings**:
   - **Modpack Platform**: Select `Modrinth` from dropdown
   - **Modpack ID/Slug**: Enter `better-minecraft`
   - **Modpack Version**: Enter `latest` (or a specific version number)
   - **Install Modpack**: ✅ Check this box

6. **Click "Update"** at the top to save settings

7. **Wait for installation**
   - The template will automatically download and install the modpack
   - Watch the console for progress messages
   - Installation typically takes 1-5 minutes depending on modpack size

8. **Start the server**
   - Once installation completes, start the server normally
   - The server will use the newly installed modpack

### Popular Modrinth Modpacks You Can Try:

- **All of Fabric**: `aof` - Popular fabric modpack
- **Better Minecraft**: `better-minecraft` - Enhanced vanilla experience
- **Fabulously Optimized**: `fabulously-optimized` - Performance-focused
- **Create: Above and Beyond**: `create-above-and-beyond` - Tech/automation
- **Medieval Minecraft**: `medieval-minecraft` - Medieval themed

### CurseForge Modpacks

CurseForge requires an API key for automated downloads.

#### Getting a CurseForge API Key

1. Go to https://console.curseforge.com/
2. Create an account or log in
3. Generate an API key
4. Add the API key as an environment variable:

**Windows (PowerShell):**
```powershell
[Environment]::SetEnvironmentVariable("CURSEFORGE_API_KEY", "your-api-key-here", "User")
```

**Linux (add to ~/.bashrc or AMP service file):**
```bash
export CURSEFORGE_API_KEY="your-api-key-here"
```

#### Installing from CurseForge

1. Find a modpack on CurseForge (e.g., https://www.curseforge.com/minecraft/modpacks/all-the-mods-9)
2. Get the **project ID** from the URL or page (numeric ID)
3. In AMP, go to **Configuration** → **Modpack Settings**
4. Set:
   - **Modpack Platform**: `CurseForge`
   - **Modpack ID/Slug**: `123456` (project ID)
   - **Modpack Version**: `latest` (or specific file ID)
5. Click **Install Modpack** checkbox
6. Click **Update** to apply settings

**Note:** Some CurseForge modpacks may require manual server file downloads due to API restrictions.

## Configuration Options

### Modpack Settings

- **Modpack Platform**: Choose CurseForge, Modrinth, or None
- **Modpack ID/Slug**: Project identifier from the platform
- **Modpack Version**: Version to install (use "latest" for most recent)
- **Install Modpack**: Check to trigger installation
- **Auto-Install on Startup**: Automatically check for updates on server start

### Minecraft Server Settings

- **Server JAR**: Name of the server JAR file (auto-detected after modpack install)
- **Initial Memory**: Starting RAM allocation (MB)
- **Maximum Memory**: Maximum RAM allocation (MB)
- **Server Port**: Port for client connections (default: 25565)
- **Server Name**: Server MOTD (Message of the Day)
- **Max Players**: Maximum concurrent players

### Gameplay Settings

- **Game Mode**: Survival, Creative, Adventure, or Spectator
- **Difficulty**: Peaceful, Easy, Normal, or Hard
- **Allow Nether**: Enable/disable Nether dimension
- **PvP Enabled**: Enable player vs player combat
- **Enable Command Blocks**: Allow command blocks

### Security Settings

- **Online Mode**: Enable Mojang authentication (disable for offline/cracked servers)
- **Whitelist**: Enable whitelist mode
- **Spawn Protection**: Radius of spawn protection in blocks

### Performance Settings

- **View Distance**: Server-side view distance (chunks)
- **Simulation Distance**: Active chunk distance around players

### World Settings

- **Level Type**: Default, Flat, Large Biomes, or Amplified
- **Level Name**: World folder name
- **World Seed**: Seed for world generation
- **Generate Structures**: Enable villages, strongholds, etc.

## Manual Modpack Installation

If automatic installation doesn't work:

1. Download the modpack server files manually
2. Extract to the Minecraft server directory in AMP
3. Update the **Server JAR** setting to point to the correct JAR file
4. Restart the server

## Troubleshooting

### Modpack Won't Install

- **Modrinth**: Check that the modpack slug is correct
- **CurseForge**: Verify your API key is set correctly
- Check AMP console output for error messages

### Server Won't Start

- Verify **Server JAR** setting points to the correct file
- Ensure sufficient **Maximum Memory** is allocated
- Check that Java is installed and in the PATH
- Review server logs in AMP console

### Port Already in Use

- Change **Server Port** in settings
- Ensure no other Minecraft servers are running on the same port

## Advanced Usage

### Custom Scripts

You can modify `modpack-install.ps1` or `modpack-install.sh` to add custom installation logic:

- Pre-download mod installations
- Custom configuration file modifications
- Integration with other tools

### Multiple Modpacks

To run multiple modpack servers:

1. Create separate AMP instances
2. Use different ports for each server
3. Install different modpacks in each instance

## Requirements

- AMP v2.5.1.8 or higher
- Java 17 or higher (for modern Minecraft versions)
- Sufficient RAM (recommended: 4GB+ for most modpacks)
- Internet connection for modpack downloads

### Linux Additional Requirements

- `unzip` - for extracting modpack archives
- `curl` or `wget` - for downloading files
- `jq` - for JSON parsing (optional, for enhanced features)

Install on Debian/Ubuntu:
```bash
sudo apt-get install unzip curl jq
```

## Support

For issues specific to this template:
- Check the AMP console for error messages
- Verify all files are correctly placed
- Ensure platform-specific scripts have execute permissions (Linux)

For AMP-related issues:
- Visit: https://github.com/CubeCoders/AMP
- Discord: https://discord.gg/cubecoders

For modpack-specific issues:
- Contact the modpack author
- Visit the modpack page on CurseForge or Modrinth

## License

This template is provided as-is for use with AMP. Refer to individual modpack licenses for usage restrictions.

## Credits

- Template created for the AMP community
- Uses CurseForge API: https://docs.curseforge.com/
- Uses Modrinth API: https://docs.modrinth.com/

## Version History

- **v1.0** - Initial release
  - CurseForge support (with API key)
  - Modrinth support
  - Cross-platform (Windows/Linux)
  - Automatic server configuration
