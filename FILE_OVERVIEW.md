# File Overview - AMP Minecraft Modpack Template

## 📁 Template Files Summary

This template consists of multiple files that work together to enable GUI-based modpack installation in AMP.

---

## Core Template Files (Required)

### `minecraftmodpack.kvp`
**Purpose:** Main template definition file
**What it does:**
- Defines the application metadata (name, author, version)
- Specifies Java as the executable
- Sets up console monitoring (player join/leave detection)
- Configures ports and network settings
- Links to other configuration files

**Why you need it:** This is the heart of the template. AMP reads this file to understand how to run your Minecraft server.

---

### `minecraftmodpackconfig.json`
**Purpose:** Settings manifest for the AMP GUI
**What it does:**
- Defines all the settings you see in the AMP web interface
- Creates dropdown menus (Modpack Platform, Game Mode, Difficulty)
- Creates text inputs (Modpack ID, Server Name)
- Creates checkboxes (Install Modpack, PvP Enabled, Whitelist)
- Organizes settings into categories (Modpack, Minecraft, Gameplay, etc.)

**Why you need it:** This creates the GUI where you choose your modpack and configure server settings.

**Key Settings for You:**
```json
{
  "DisplayName": "Modpack Platform",
  "FieldName": "ModpackPlatform",
  "InputType": "enum",
  "EnumValues": {
    "none": "None - Manual Installation",
    "curseforge": "CurseForge",
    "modrinth": "Modrinth"
  }
}
```
This creates the dropdown where you select CurseForge or Modrinth!

---

### `minecraftmodpackmetaconfig.json`
**Purpose:** Defines how AMP should read/write Minecraft configuration files
**What it does:**
- Maps AMP settings to server.properties file
- Handles EULA acceptance
- Manages key-value pair format

**Why you need it:** Without this, AMP wouldn't know how to write your settings to Minecraft's config files.

---

### `minecraftmodpackports.json`
**Purpose:** Network port configuration
**What it does:**
- Defines which ports the server uses
- Port 25565: Main Minecraft server port
- Port 25575: RCON admin port (optional)

**Why you need it:** So AMP knows which ports to open and manage.

---

### `minecraftmodpackupdates.json`
**Purpose:** Update system integration
**What it does:**
- Registers the modpack installer with AMP's update system
- Allows triggering installation through AMP interface

**Why you need it:** Connects the installation process to AMP's update mechanism.

---

## Installation Scripts (Required)

### `modpack-install.ps1`
**Purpose:** PowerShell installer for Windows
**What it does:**
1. Reads your modpack configuration (Platform, ID, Version)
2. Connects to CurseForge or Modrinth API
3. Downloads the modpack files
4. Extracts server files to the correct location
5. Detects the server JAR file
6. Updates configuration automatically

**Languages/Tools Used:**
- PowerShell (Windows scripting)
- REST API calls (HTTP requests)
- ZIP extraction
- JSON parsing

**Why you need it:** This is the script that actually downloads and installs your modpack on Windows.

---

### `modpack-install.sh`
**Purpose:** Bash installer for Linux
**What it does:**
- Same as modpack-install.ps1 but for Linux
- Uses curl/wget for downloads
- Uses unzip for extraction
- Compatible with various Linux distributions

**Why you need it:** This is the script that actually downloads and installs your modpack on Linux.

---

## Helper Scripts (Optional but Recommended)

### `start-server.ps1`
**Purpose:** Windows startup wrapper
**What it does:**
- Runs before server starts
- Checks if installation is needed
- Calls modpack-install.ps1 if "Install Modpack" is checked
- Accepts EULA automatically
- Verifies server JAR exists
- Provides helpful error messages

**Why you might want it:** Automates pre-start checks and installation.

---

### `start-server.sh`
**Purpose:** Linux startup wrapper
**What it does:**
- Same as start-server.ps1 but for Linux
- Handles installation on server startup
- Makes sure everything is ready before launch

**Why you might want it:** Automates pre-start checks and installation on Linux.

---

## Documentation Files

### `README.md`
**Purpose:** Full documentation
**Contents:**
- Detailed installation instructions
- Configuration guide
- Troubleshooting section
- Examples for both CurseForge and Modrinth
- Requirements and prerequisites

**When to read:** First time setup and troubleshooting.

---

### `QUICK_START.md`
**Purpose:** Fast setup guide
**Contents:**
- 5-minute setup walkthrough
- Recommended modpacks
- Essential settings
- Common issues

**When to read:** When you just want to get started quickly.

---

### `FILE_OVERVIEW.md` (this file)
**Purpose:** Explains what each file does
**When to read:** When you want to understand how the template works.

---

## 🔄 How They Work Together

```
User opens AMP GUI
       ↓
minecraftmodpackconfig.json
(Creates the settings interface)
       ↓
User selects Modrinth and enters "better-minecraft"
       ↓
User checks "Install Modpack" and clicks Update
       ↓
AMP saves settings
       ↓
modpack-install.ps1 (Windows) or modpack-install.sh (Linux)
(Script runs automatically)
       ↓
Script reads configuration
       ↓
Script calls Modrinth API
       ↓
Downloads modpack files
       ↓
Extracts to minecraft/ folder
       ↓
Finds server.jar
       ↓
Updates minecraftmodpack.kvp with JAR location
       ↓
Server ready to start!
       ↓
AMP uses minecraftmodpack.kvp to launch Java
       ↓
minecraftmodpackmetaconfig.json applies settings
       ↓
Server starts with your modpack! 🎉
```

---

## 📦 Required vs Optional Files

### Absolutely Required
✅ `minecraftmodpack.kvp`
✅ `minecraftmodpackconfig.json`
✅ `minecraftmodpackports.json`

### Required for Installation Feature
✅ `modpack-install.ps1` (Windows)
✅ `modpack-install.sh` (Linux)
✅ `minecraftmodpackupdates.json`

### Recommended
⭐ `minecraftmodpackmetaconfig.json`
⭐ `README.md`
⭐ `QUICK_START.md`

### Optional Enhancements
➕ `start-server.ps1` (Windows wrapper)
➕ `start-server.sh` (Linux wrapper)
➕ `FILE_OVERVIEW.md` (this file)

---

## 🛠️ Customization Points

Want to modify the template? Here's where to look:

### Add More Settings
- Edit: `minecraftmodpackconfig.json`
- Add new JSON objects with your settings

### Change Default Values
- Edit: `minecraftmodpackconfig.json`
- Modify "DefaultValue" fields

### Add Another Platform
- Edit: `modpack-install.ps1` and `modpack-install.sh`
- Add new case in switch statement
- Add API integration for new platform

### Modify Java Arguments
- Edit: `minecraftmodpack.kvp`
- Change: `App.LinuxCommandLineArgs` and `App.WindowsCommandLineArgs`

### Add Custom Ports
- Edit: `minecraftmodpackports.json`
- Add new port objects

---

## 🎯 For Developers

### Technologies Used
- **PowerShell**: Windows automation
- **Bash**: Linux automation
- **JSON**: Configuration format
- **KVP Format**: AMP's key-value pair format
- **REST APIs**: CurseForge and Modrinth APIs
- **Regular Expressions**: Console monitoring

### API Endpoints Used

**Modrinth:**
- Project Info: `GET https://api.modrinth.com/v2/project/{id}`
- Versions: `GET https://api.modrinth.com/v2/project/{id}/version`
- Version Info: `GET https://api.modrinth.com/v2/version/{version_id}`

**CurseForge:**
- Project Info: `GET https://api.curseforge.com/v1/mods/{id}`
- Files: `GET https://api.curseforge.com/v1/mods/{id}/files`
- File Info: `GET https://api.curseforge.com/v1/mods/{id}/files/{file_id}`

---

## 📝 File Sizes (Approximate)

- KVP files: 2-5 KB
- JSON config files: 10-30 KB
- PowerShell scripts: 5-15 KB
- Bash scripts: 5-10 KB
- Documentation: 10-20 KB

**Total template size: ~100 KB**

---

## 🔐 Security Considerations

### API Keys
- CurseForge API key stored as environment variable (not in files)
- Never commit API keys to version control

### Script Execution
- Scripts download from official APIs only
- No arbitrary code execution
- File paths validated

### Network
- HTTPS only for downloads
- API endpoints are official and trusted

---

**Questions about any file? Check the comments in the file itself or see README.md for more details!**
