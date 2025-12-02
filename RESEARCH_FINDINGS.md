# Research Findings - AMP Template Requirements

## Question: Do we need a Custom Module or is Generic Module Template correct?

### Answer: ✅ Generic Module Template is CORRECT

Based on thorough research of the AMP Templates repository and official documentation, here's what was discovered:

---

## Generic Module vs Custom Module

### Generic Module Templates (What We're Using)
**Purpose:** For applications that AMP doesn't have dedicated modules for

**Requirements:**
- `.kvp` file for configuration
- `config.json` for settings manifest
- `metaconfig.json` for file mapping (optional)
- Can run custom scripts via UpdateSources
- No compilation required
- Easy to share in community repository

**Use Cases:**
- ✅ Game servers without official AMP modules
- ✅ Applications requiring custom installation scripts
- ✅ Modpack installers (like ours!)
- ✅ Any executable application with a console

### Custom Modules (NOT Needed for This)
**Purpose:** Deep AMP integration requiring C# code

**Requirements:**
- C# programming
- Compilation into DLL
- Deep knowledge of AMP plugin system
- Complex module-specific features

**Use Cases:**
- Applications needing custom AMP UI beyond settings
- Complex server management features
- Integration with AMP's permission system
- When Generic Module capabilities aren't enough

---

## Why Generic Module is Perfect for Minecraft Modpacks

1. **Executable Launching** ✅
   - We launch Java with command-line arguments
   - AMP handles process management
   - Console output is captured automatically

2. **Settings Manifest** ✅
   - We use `config.json` to create GUI dropdowns, text inputs, checkboxes
   - AMP renders these settings in the web interface
   - Settings are passed to scripts via template variables

3. **Update System** ✅
   - We use `UpdateSources` to trigger installation scripts
   - Platform-specific (Windows PowerShell, Linux Bash)
   - Conditional execution (only when "Install Modpack" is checked)

4. **File Management** ✅
   - We use `metaconfig.json` to map settings to server.properties
   - AMP handles file writing automatically
   - No custom file I/O code needed

5. **No Custom Logic Required** ✅
   - Installation scripts are standard PowerShell/Bash
   - API calls are simple HTTP requests
   - No need for compiled AMP plugin code

---

## Key Findings from Research

### 1. UpdateSources is the Correct Mechanism

**Original Concern:** How do we trigger modpack installation?

**Solution:** UpdateSources configuration in `minecraftmodpackupdates.json`

**How it Works:**
```json
{
    "UpdateStageName": "Install Modpack",
    "UpdateSourcePlatform": "Windows",
    "UpdateSourceData": "pwsh",
    "UpdateSourceArgs": "-ExecutionPolicy Bypass -File \"{{$FullBaseDir}}modpack-install.ps1\" ...",
    "UpdateSourceCondition": "{{InstallModpack}}"
}
```

- **UpdateSourcePlatform:** Specifies OS (Windows/Linux/All)
- **UpdateSourceData:** The executable to run (pwsh, bash)
- **UpdateSourceArgs:** Command-line arguments with template variables
- **UpdateSourceCondition:** Only runs if `{{InstallModpack}}` is true

### 2. Template Variables

AMP provides these variables we can use:

- `{{ModpackPlatform}}` - User's platform choice (CurseForge/Modrinth)
- `{{ModpackID}}` - User's modpack ID
- `{{ModpackVersion}}` - User's version choice
- `{{InstallModpack}}` - Checkbox state (true/false)
- `{{$FullBaseDir}}` - AMP template directory path
- `{{$FullRootDir}}` - Server installation directory path

These are automatically populated from `config.json` settings!

### 3. Script Execution Flow

```
User clicks "Update" in AMP
         ↓
AMP checks UpdateSourceCondition
         ↓
Is {{InstallModpack}} true?
         ↓ YES
Platform-specific UpdateSource is selected
         ↓
Windows: pwsh runs modpack-install.ps1
Linux: bash runs modpack-install.sh
         ↓
Script receives arguments:
  - Platform (CurseForge/Modrinth)
  - Modpack ID
  - Version
  - Install Path
         ↓
Script downloads modpack from API
         ↓
Extracts server files
         ↓
Detects server JAR
         ↓
Installation complete!
         ↓
User clicks "Start" to run server
```

### 4. Why PreStartStages Wasn't the Right Choice

**Initial Thought:** Use PreStartStages to run installation before server starts

**Why That's Wrong:**
- PreStartStages is for AMP-specific pre-configuration
- It's NOT for running installation scripts
- It's for directory creation, file prep, etc.
- Installation should happen during "Update" phase, not "Start" phase

**Correct Approach:**
- Use UpdateSources for installation (runs during "Update")
- Use PreStartStages only if needed for pre-start AMP config

---

## What Changed After Research

### Before Research:
```json
{
    "UpdateStageName": "Install Modpack",
    "UpdateSourceData": "",  // ❌ Empty
    "UpdateSourceArgs": "",  // ❌ Empty
    "UpdateSourceCondition": ""  // ❌ Empty
}
```
This wouldn't trigger anything!

### After Research:
```json
{
    "UpdateStageName": "Install Modpack",
    "UpdateSourcePlatform": "Windows",
    "UpdateSourceData": "pwsh",  // ✅ PowerShell executable
    "UpdateSourceArgs": "-ExecutionPolicy Bypass -File \"{{$FullBaseDir}}modpack-install.ps1\" -Platform \"{{ModpackPlatform}}\" ...",  // ✅ Full command
    "UpdateSourceCondition": "{{InstallModpack}}"  // ✅ Only when checked
}
```
This properly triggers the installation script!

---

## File Structure Validation

Based on official AMP Templates repository requirements:

### Required Files ✅
- `minecraftmodpack.kvp` - Main configuration
- `minecraftmodpackconfig.json` - Settings manifest
- `minecraftmodpackports.json` - Port definitions

### Recommended Files ✅
- `minecraftmodpackmetaconfig.json` - File mapping
- `minecraftmodpackupdates.json` - Update configuration

### Custom Files ✅
- `modpack-install.ps1` - Windows installer
- `modpack-install.sh` - Linux installer

### Documentation ✅
- `README.md` - Full documentation
- `QUICK_START.md` - Quick setup guide
- `FILE_OVERVIEW.md` - File explanations

**All files follow AMP naming conventions and requirements!**

---

## Official AMP Template Requirements

From the AMPTemplates repository README:

### ✅ Authentication
"The application must not require any login/authentication in order to download (except for SteamCMD logins)."
- **Modrinth:** No authentication required ✅
- **CurseForge:** Optional API key (user-provided) ✅

### ✅ Cross-Platform Support
"If Linux versions don't exist, add Proton downloads via SteamCMD when feasible."
- We support both Windows and Linux natively ✅

### ✅ Configuration Management
"Applications that have customizable settings must use a Settings Manifest."
- We use `minecraftmodpackconfig.json` as settings manifest ✅

### ✅ Console Requirements
"Only applications that expose some kind of Console that AMP is able to pick up."
- Minecraft servers have console output ✅
- We configure console regex patterns in .kvp ✅

### ✅ Executable Launch
"Do not invoke any shell scripts/batch files. You must only launch actual executables."
- We launch `java` (executable) ✅
- NOT launching .sh or .bat files ✅

### ✅ Testing Requirements
"Before submission, your template must successfully:
- Load the configuration
- Perform updates
- Start and reach 'Ready' state
- Stop and reach 'Stopped' state"
- Ready to test once deployed ⏳

---

## Comparison with Existing AMP Templates

### Similar Templates in Repository:

**Valheim Template:**
- Uses Generic Module ✅
- Has `.kvp`, `config.json`, `metaconfig.json` ✅
- Supports mod installation (BepInEx) via config ✅
- Supports both Windows and Linux ✅

**Our Template:**
- Uses Generic Module ✅
- Has `.kvp`, `config.json`, `metaconfig.json` ✅
- Supports modpack installation via UpdateSources ✅
- Supports both Windows and Linux ✅

**Conclusion:** Our template follows the same pattern as existing community templates!

---

## Additional Research Sources

1. **AMP Templates Repository**
   - https://github.com/CubeCoders/AMPTemplates
   - Contains 100+ community-contributed templates
   - All use Generic Module format
   - None require Custom Module for basic functionality

2. **AMP Wiki** (Referenced in repo)
   - Generic Module configuration guide
   - Settings Manifest documentation
   - UpdateSources and PreStartStages explanations

3. **Existing Minecraft Templates**
   - Various Forge/Fabric/Paper templates exist
   - All use Generic Module
   - Some have custom startup scripts
   - None require Custom Module

---

## Final Verdict

### Question: Do we need a Custom Module?
### Answer: **NO - Generic Module Template is correct and complete!**

**Reasons:**
1. ✅ Generic Module meets all requirements
2. ✅ UpdateSources handles installation perfectly
3. ✅ Settings Manifest creates the GUI we need
4. ✅ No custom AMP plugin code required
5. ✅ Follows official template guidelines
6. ✅ Matches patterns of existing community templates
7. ✅ Cross-platform support achieved
8. ✅ Ready for community contribution

**The template is production-ready once tested!**

---

## Next Steps

### Testing Checklist:

1. **Windows Testing:**
   - [ ] Copy template to AMP templates directory
   - [ ] Create instance with template
   - [ ] Configure Modrinth modpack
   - [ ] Click "Update" and verify script runs
   - [ ] Verify modpack downloads and installs
   - [ ] Start server and verify it reaches "Ready" state
   - [ ] Stop server and verify clean shutdown

2. **Linux Testing:**
   - [ ] Copy template to AMP templates directory
   - [ ] Make .sh scripts executable (chmod +x)
   - [ ] Create instance with template
   - [ ] Configure Modrinth modpack
   - [ ] Click "Update" and verify script runs
   - [ ] Verify modpack downloads and installs
   - [ ] Start server and verify it reaches "Ready" state
   - [ ] Stop server and verify clean shutdown

3. **Community Submission:**
   - [ ] All files use lowercase naming
   - [ ] Testing completed on both platforms
   - [ ] Documentation is complete
   - [ ] Submit PR to AMPTemplates repository

---

## Conclusion

After thorough research and analysis:

**✅ Generic Module Template is the correct approach**
**✅ No Custom Module needed**
**✅ Template design is sound and follows best practices**
**✅ Ready for testing and deployment**

The template allows users to choose modpacks in the GUI and automatically download/install them using AMP's built-in update system. No custom compiled modules required!
