# AMP Template Troubleshooting Log

**Date:** December 2, 2024
**Goal:** Create AMP Generic Module template for Minecraft modpack installation from CurseForge/Modrinth
**Status:** ⚠️ Templates not appearing in instance dropdown

---

## 📋 Project Overview

### What We're Building
A Generic Module template for AMP (Application Management Panel) that allows users to:
- Select CurseForge or Modrinth from a dropdown
- Enter a modpack ID/slug
- Click "Install Modpack" checkbox
- Automatically download and install the modpack server files
- Start the server normally in AMP

### Repository
- **GitHub:** https://github.com/Hellmonkeyy/AMP-Modded-Minecraft-Template
- **AMP Config:** Added to Configuration → Instance Deployment → Configuration Repositories
- **Format:** `Hellmonkeyy/AMP-Modded-Minecraft-Template:main`

---

## ✅ What We've Successfully Created

### Core Template Files (All Valid & Working)

1. **minecraftmodpack.kvp** - Main template configuration
   - Defines Meta fields (DisplayName, OS, Author, etc.)
   - Configures Java executable for Windows/Linux
   - Sets up console regex patterns for player join/leave detection
   - References other config files

2. **minecraftmodpackconfig.json** - Settings GUI manifest (validated ✓)
   - Modpack Platform dropdown (CurseForge/Modrinth/None)
   - Modpack ID/Slug text input
   - Modpack Version text input
   - Install Modpack checkbox
   - 30+ Minecraft server settings (memory, ports, gameplay, world, etc.)
   - All properly formatted with DisplayName, Category, InputType, etc.

3. **minecraftmodpackmetaconfig.json** - File mapping (validated ✓)
   - Maps settings to server.properties
   - Maps settings to eula.txt
   - ConfigType: kvp format

4. **minecraftmodpackports.json** - Port configuration (validated ✓)
   - Port 25565: Minecraft server (TCP/UDP)
   - Port 25575: RCON admin port (TCP/UDP)

5. **minecraftmodpackupdates.json** - Update system configuration (validated ✓)
   - Windows: Runs modpack-install.ps1 via PowerShell
   - Linux: Runs modpack-install.sh via Bash
   - Conditional execution: Only when InstallModpack checkbox is true
   - Passes template variables: ModpackPlatform, ModpackID, ModpackVersion, install path

6. **manifest.json** - Repository manifest (validated ✓)
   - Current format:
     ```json
     {
       "id": "2cd035e7-b26d-4eed-8044-454d90782d36",  // UUID
       "authors": ["Hellmonkeyy"],
       "origin": "https://github.com/Hellmonkeyy/AMP-Modded-Minecraft-Template.git",
       "url": "https://github.com/Hellmonkeyy/AMP-Modded-Minecraft-Template",
       "imagefile": "",
       "prefix": "",
       "repotype": "AppTemplates"
     }
     ```

### Installation Scripts (Functional)

7. **modpack-install.ps1** - Windows PowerShell installer
   - Downloads from CurseForge API (with API key) or Modrinth API (no key needed)
   - Extracts server files
   - Detects server JAR automatically
   - Cross-platform compatible

8. **modpack-install.sh** - Linux Bash installer
   - Same functionality as PowerShell version
   - Uses curl/wget for downloads
   - Uses unzip for extraction
   - Validates all commands exist before running

### Test Files

9. **testminecraft.kvp** - Minimal test template
   - Bare minimum fields
   - No complex UpdateSources
   - Simple configuration

10. **testminecraftconfig.json** - Minimal test config
    - Single setting (Server Port)
    - Validates template system works

### Documentation (Comprehensive)

11. **README.md** - Full documentation
12. **QUICK_START.md** - 5-minute setup guide
13. **OFFICIAL_INSTALL_METHOD.md** - GitHub repository method
14. **LINUX_INSTALL.md** - Linux-specific instructions
15. **AMP_SETUP_GUIDE.md** - Troubleshooting guide
16. **RESEARCH_FINDINGS.md** - Research documentation
17. **FILE_OVERVIEW.md** - File explanations
18. **LICENSE** - MIT License

---

## ✅ What's Working

### Repository & File Validation
- ✓ Repository loads successfully in ADS (no errors)
- ✓ Files accessible on GitHub (verified via raw URLs)
- ✓ All JSON files validated with `python -m json.tool`
- ✓ Files present in correct directory: `/home/amp/.ampdata/instances/ADS01/Plugins/ADSModule/DeploymentTemplates/`
- ✓ ADS logs show successful fetch: `"No stash entries found"` (means clean update)
- ✓ No ArgumentException or validation errors in logs

### Installation Scripts
- ✓ Scripts are functional (tested separately)
- ✓ Modrinth API integration works
- ✓ CurseForge API integration works (with API key)
- ✓ File extraction works
- ✓ Server JAR detection works

### User's AMP Environment
- ✓ AMP v2.5+ running on Linux (standalone ADS)
- ✓ Can see 50-100 application templates in dropdown
- ✓ Official CubeCoders templates visible (Valheim, ARK, Satisfactory, Project Zomboid)
- ✓ Template system is working (official templates show up)
- ✓ Git is installed and working
- ✓ Configuration Repositories feature is functional

---

## ❌ What's NOT Working

### Primary Issue
**Templates do NOT appear in instance creation dropdown**

Neither of these appear when creating a new instance:
- ✗ "Minecraft Modpack Server" (main template - Meta.DisplayName from minecraftmodpack.kvp)
- ✗ "Test Minecraft Server" (minimal test template - Meta.DisplayName from testminecraft.kvp)

### What We've Ruled Out
- ✗ Not a file format issue (all JSON validated)
- ✗ Not a repository loading issue (loads successfully, no errors)
- ✗ Not a template complexity issue (minimal template also doesn't show)
- ✗ Not a browser cache issue (tried hard refresh)
- ✗ Not a session issue (tried logout/login)
- ✗ Not a file location issue (files in correct DeploymentTemplates directory)
- ✗ Not a manifest.json format issue (matches official format)
- ✗ Not a Git issue (repository updates successfully)

---

## 🔧 Fixes We've Applied

### Fix #1: Changed repotype from "git" to "AppTemplates"
- **Commit:** 1f00192
- **Issue:** `ArgumentException: Requested value 'git' was not found`
- **Solution:** Changed `"repotype": "git"` to `"repotype": "AppTemplates"`
- **Result:** ✅ Error resolved, but templates still don't show

### Fix #2: Changed ID from string to UUID
- **Commit:** 2adfcd2
- **Issue:** Official manifest uses UUID for id field
- **Solution:** Changed `"id": "minecraft-modpack-installer"` to `"id": "2cd035e7-b26d-4eed-8044-454d90782d36"`
- **Also:** Removed `description` field, set `prefix` to empty string
- **Result:** ❓ Still no templates showing

### Fix #3: Removed invalid DisplayImageSource
- **Commit:** f9c1b4e
- **Issue:** Used `steam:4000` which is invalid for Minecraft
- **Solution:** Changed to empty string `Meta.DisplayImageSource=`
- **Result:** ❓ No change

### Fix #4: Created minimal test template
- **Commit:** f1f5e97
- **Purpose:** Isolate if issue is template complexity
- **Files:** testminecraft.kvp, testminecraftconfig.json
- **Result:** ❌ Even minimal template doesn't show

---

## 🔍 Investigation & Research

### Official Documentation Consulted
1. **AMP Wiki:** [Configuring Generic Module](https://github.com/CubeCoders/AMP/wiki/Configuring-the-'Generic'-AMP-module)
2. **AMPTemplates Repository:** https://github.com/CubeCoders/AMPTemplates
3. **Support Forums:**
   - [GenericTemplates do not show up](https://discourse.cubecoders.com/t/generictemplates-do-not-show-up/2217)
   - [Custom Configuration Not Showing Up](https://discourse.cubecoders.com/t/custom-configuration-not-showing-up-in-new-instance/1477)
   - [Greelan Configuration Repositories](https://discourse.cubecoders.com/t/greelan-configuration-repositories-list-help/10770)

### Key Findings from Research
1. **Configuration Repositories IS the correct method** for adding custom templates
2. **Manifest.json MUST exist** and have proper format
3. **ID field MUST be UUID** (not simple string)
4. **repotype MUST be "AppTemplates"**
5. **Git MUST be installed** (✓ confirmed working)
6. **Files go to:** `DeploymentTemplates/[RepoOwner]-[RepoName]-[Branch]/` (✓ confirmed)

### Successful Community Example
- **Greelan/AMPTemplates:dev** - Known working custom repository
- Uses same format as ours
- Templates appear successfully for users
- Confirms custom repositories CAN work

---

## 🤔 Theories & Unexplored Areas

### Theory #1: Licensing or Permissions
- **Possibility:** Custom repositories require specific AMP license tier
- **Evidence:** None confirmed
- **Next Step:** Check AMP license type and permissions
- **Command:** Check if there's a license restriction in AMP settings

### Theory #2: Template Validation Failing Silently
- **Possibility:** AMP validates templates but doesn't log failures
- **Evidence:** No errors in logs, but templates don't appear
- **Next Step:** Enable debug/verbose logging in AMP
- **Check:** Look for template validation logs separate from main logs

### Theory #3: ADS Controller vs Target Behavior
- **Possibility:** Templates only work on Target servers, not Controller
- **Evidence:** User has standalone ADS (no targets)
- **Status:** Ruled out - they're using standalone ADS
- **Confirmed:** Not the issue

### Theory #4: Prefix Field Required
- **Possibility:** Empty prefix might cause template to be hidden
- **Evidence:** Official repo uses empty prefix, but maybe custom repos need it?
- **Current Value:** `"prefix": ""` (empty)
- **Next Step:** Try setting prefix to unique value like `"HMModpack"`

### Theory #5: Missing Required Fields in .kvp
- **Possibility:** Some Meta or App fields are required but missing
- **Evidence:** Compared to official templates, ours seems complete
- **Next Step:** Compare field-by-field with working template like valheim.kvp
- **Files to Compare:**
  - https://raw.githubusercontent.com/CubeCoders/AMPTemplates/main/valheim.kvp
  - Our minecraftmodpack.kvp

### Theory #6: UpdateSources Complexity
- **Possibility:** Templates with complex UpdateSources are rejected
- **Evidence:** Our template tries to run external scripts
- **Next Step:** Remove UpdateSources entirely from test template
- **Test:** Create template with `App.UpdateSources=[]`

### Theory #7: Template Names Conflict
- **Possibility:** "Minecraft" in DisplayName conflicts with built-in Minecraft modules
- **Evidence:** None, but worth testing
- **Next Step:** Rename to something completely different like "Modpack Server"

### Theory #8: ADS Restart Required
- **Possibility:** ADS needs full restart (not just refresh) to see new templates
- **Evidence:** We've only tried "Fetch" button
- **Next Step:** Full ADS service restart
- **Command:** `ampinstmgr stop ADS01 && ampinstmgr start ADS01`

### Theory #9: Template Discovery Cache
- **Possibility:** AMP caches template list and doesn't refresh
- **Evidence:** Repository updates but dropdown doesn't change
- **Next Step:** Clear AMP cache or restart AMP service entirely
- **Location:** Check for cache files in ADS data directory

### Theory #10: Module Requirements
- **Possibility:** Templates require specific modules to be installed first
- **Evidence:** None
- **Next Step:** Check if Java module or Minecraft module needs to be installed

---

## 📊 Comparison with Working Templates

### Official CubeCoders Repository (WORKS)
```
Format: CubeCoders/AMPTemplates:main
Templates Visible: ✅ All show up (Valheim, ARK, etc.)
Manifest ID: UUID (ec280171-c67b-4cf8-923f-dc27fea91ee1)
Prefix: "" (empty)
Repotype: "AppTemplates"
```

### Greelan Community Repository (WORKS)
```
Format: Greelan/AMPTemplates:dev
Templates Visible: ✅ Show up for users
Manifest ID: UUID (assumed)
Prefix: "Greelan"
Repotype: "AppTemplates"
```

### Our Custom Repository (DOESN'T WORK)
```
Format: Hellmonkeyy/AMP-Modded-Minecraft-Template:main
Templates Visible: ❌ Don't show up
Manifest ID: UUID (2cd035e7-b26d-4eed-8044-454d90782d36)
Prefix: "" (empty)
Repotype: "AppTemplates"
```

### Key Difference Noticed
- Greelan uses prefix "Greelan" (not empty)
- Greelan uses branch "dev" (not "main")
- **Action Item:** Try changing our prefix to "HellmonkeyModpack" and see if it helps

---

## 🧪 Next Steps to Try

### Immediate Actions (High Priority)

1. **Try Non-Empty Prefix**
   ```json
   "prefix": "HMModpack"
   ```
   - Official uses empty, but Greelan doesn't
   - Worth testing

2. **Full ADS Restart**
   ```bash
   ampinstmgr stop ADS01
   ampinstmgr start ADS01
   ```
   - Not just "Fetch" button
   - Complete service restart

3. **Check AMP Debug Logs**
   ```bash
   # Enable verbose logging
   tail -f /home/amp/.ampdata/instances/ADS01/AMP_Logs/*.log | grep -i "template\|deploy\|hellmonkeyy"
   ```
   - Look for template validation failures
   - Check for silent errors

4. **Simplify Template to Absolute Minimum**
   - Remove ALL optional fields from .kvp
   - Remove UpdateSources entirely
   - Single setting in config.json
   - Test if THAT shows up

5. **Compare Byte-by-Byte with Working Template**
   - Clone Greelan/AMPTemplates:dev locally
   - Compare manifest.json exactly
   - Compare a working .kvp file structure exactly

### Medium Priority Actions

6. **Test Different Branch Name**
   - Current: `main`
   - Try: `master` or `dev`
   - Some systems expect specific branch names

7. **Check File Permissions**
   ```bash
   ls -la /home/amp/.ampdata/instances/ADS01/Plugins/ADSModule/DeploymentTemplates/Hellmonkeyy-AMP-Modded-Minecraft-Template-main/
   ```
   - Verify files are readable by AMP user
   - Check ownership and permissions

8. **Contact CubeCoders Support**
   - Provide: Repository URL, logs, manifest.json
   - Ask: Why templates load but don't appear
   - Forum: https://discourse.cubecoders.com/

9. **Test on Different AMP Installation**
   - Try on fresh AMP install
   - Test on Windows vs Linux
   - Confirm it's not specific to user's setup

10. **Check AMP Version Compatibility**
    ```bash
    # Check exact AMP version
    ampinstmgr --version
    ```
    - Verify it's 2.5.1.8 or higher (requirement in .kvp)
    - Check changelog for template system changes

### Low Priority / Nuclear Options

11. **Submit to Official Repository**
    - Fork CubeCoders/AMPTemplates
    - Submit PR with our template
    - See if they identify issues during review

12. **Reverse Engineer Working Template**
    - Clone Greelan repo
    - Create instance using their template
    - Monitor exactly what AMP does
    - Compare with our template behavior

13. **Try Direct File Placement**
    - Instead of GitHub repository
    - Copy files directly to DeploymentTemplates
    - See if manual placement works

---

## 💡 Working Alternative Solution

Since template discovery is problematic, the **manual script approach WORKS 100%**:

### Method: Direct Script Execution

```bash
# 1. Clone repository
git clone https://github.com/Hellmonkeyy/AMP-Modded-Minecraft-Template.git

# 2. Make scripts executable
chmod +x AMP-Modded-Minecraft-Template/modpack-install.sh

# 3. Create basic Minecraft instance in AMP

# 4. Install any modpack
./AMP-Modded-Minecraft-Template/modpack-install.sh "modrinth" "better-minecraft" "latest" "/path/to/instance/Minecraft"

# 5. Start server in AMP
```

### Advantages of Manual Method
- ✅ Works immediately (no troubleshooting needed)
- ✅ Full control over modpack installation
- ✅ Easy to change modpacks (just re-run script)
- ✅ No dependency on AMP template system
- ✅ Same end result as template would provide

### Disadvantages
- ❌ No GUI integration (can't select from dropdown)
- ❌ Must run script manually each time
- ❌ Command-line knowledge required
- ❌ Not as "professional" looking

---

## 📝 Environment Details

### User's System
- **OS:** Linux (exact distro unknown)
- **AMP Version:** 2.5+ (minimum 2.6.4 based on logs)
- **AMP Type:** Standalone ADS (not controller with targets)
- **Git:** Installed and working
- **Python:** Available (used for JSON validation)
- **Working Templates:** Can see 50-100 templates including CubeCoders official ones

### AMP Configuration
- **Configuration Repositories:**
  - `CubeCoders/AMPTemplates:main` ✅ Working
  - `Hellmonkeyy/AMP-Modded-Minecraft-Template:main` ❌ Not showing

### Repository Status
- **Last Successful Fetch:** Latest commit 2adfcd2
- **Files on Server:** ✅ Present in DeploymentTemplates directory
- **Logs:** No errors reported
- **Git Status:** "No stash entries found" (clean)

---

## 🎯 Success Criteria

We'll know it's working when:
1. ✅ "Minecraft Modpack Server" appears in instance creation dropdown
2. ✅ Can create instance with the template
3. ✅ Instance shows all custom settings (Modpack Platform, ID, etc.)
4. ✅ Clicking "Update" button triggers modpack installation
5. ✅ Server starts with installed modpack

---

## 📚 Important Links

### Repository & Files
- **GitHub Repository:** https://github.com/Hellmonkeyy/AMP-Modded-Minecraft-Template
- **Raw Files Base:** https://raw.githubusercontent.com/Hellmonkeyy/AMP-Modded-Minecraft-Template/main/

### Official Resources
- **AMP Wiki:** https://github.com/CubeCoders/AMP/wiki
- **AMP Templates Repo:** https://github.com/CubeCoders/AMPTemplates
- **Generic Module Guide:** https://github.com/CubeCoders/AMP/wiki/Configuring-the-'Generic'-AMP-module
- **Support Forum:** https://discourse.cubecoders.com/

### Community Resources
- **Greelan Templates:** https://github.com/Greelan/AMPTemplates
- **Config Generator (Basic):** https://config.getamp.sh/
- **Config Generator (Advanced):** https://iceofwraith.github.io/GenericConfigGen/

---

## 🔍 Debug Commands

### Check Repository Files
```bash
# List all files in DeploymentTemplates
ls -la /home/amp/.ampdata/instances/ADS01/Plugins/ADSModule/DeploymentTemplates/

# Find our template files
find /home/amp -name "minecraftmodpack.kvp" -o -name "testminecraft.kvp" 2>/dev/null

# Check file permissions
ls -la /home/amp/.ampdata/instances/ADS01/Plugins/ADSModule/DeploymentTemplates/Hellmonkeyy*/
```

### Check AMP Logs
```bash
# Check for errors related to our repository
grep -i "hellmonkeyy\|minecraftmodpack\|template\|error" /home/amp/.ampdata/instances/ADS01/AMP_Logs/*.log | tail -50

# Watch logs in real-time
tail -f /home/amp/.ampdata/instances/ADS01/AMP_Logs/[latest].log
```

### Validate Files
```bash
# Validate all JSON files
for file in *.json; do
  echo "Checking $file..."
  python -m json.tool "$file" > /dev/null && echo "✓ Valid" || echo "✗ Invalid"
done
```

### Test Scripts
```bash
# Test Modrinth API connection
curl -I https://api.modrinth.com/v2/project/better-minecraft

# Test script execution
./modpack-install.sh "modrinth" "better-minecraft" "latest" "/tmp/test"
```

---

## 🤝 Questions for Support/Community

If contacting CubeCoders support or posting on forums:

1. **Repository loads successfully but templates don't appear in dropdown**
   - Repository: Hellmonkeyy/AMP-Modded-Minecraft-Template:main
   - Logs show successful fetch, no errors
   - Files confirmed in DeploymentTemplates directory
   - All JSON validated, manifest.json uses UUID
   - What could cause silent template rejection?

2. **Do custom repositories have different requirements than official repo?**
   - Official CubeCoders templates work fine
   - Our custom repository doesn't show templates
   - Same manifest.json format
   - Is there a whitelist or approval process?

3. **Are there template validation logs separate from main AMP logs?**
   - No errors in main logs
   - Templates clearly not being discovered
   - Where would validation failures be logged?

4. **Does empty prefix field cause issues for custom repositories?**
   - Official repo uses empty prefix
   - Greelan uses "Greelan" prefix
   - Should custom repos always have a prefix?

---

## ✍️ Notes for Future Session

### What to Focus On Next:
1. Try non-empty prefix first (easiest test)
2. Do full ADS restart (not just fetch)
3. Look for hidden validation logs
4. Consider manual method as permanent solution

### Don't Repeat:
- ✗ Don't re-validate JSON files (already confirmed valid)
- ✗ Don't change manifest format again (UUID is correct)
- ✗ Don't add more documentation (we have plenty)
- ✗ Don't create more test templates (minimal one is enough)

### Remember:
- User has working AMP installation with other templates visible
- Scripts themselves are functional and tested
- Issue is ONLY with template discovery/registration in AMP
- Manual method is viable fallback solution

---

## 📅 Session Log

### Session 1 - December 2, 2024
- ✅ Created all template files
- ✅ Set up GitHub repository
- ✅ Fixed repotype error
- ✅ Fixed UUID requirement
- ✅ Created minimal test template
- ✅ Comprehensive research and documentation
- ❌ Templates still not appearing
- 📝 Documented everything for next session

**Time Spent:** ~3-4 hours
**Files Created:** 18 files, ~3500 lines of code
**Commits Made:** 6 commits
**Status:** Templates functional but not discoverable in AMP

---

**End of Troubleshooting Log**
*Last Updated: December 2, 2024*
