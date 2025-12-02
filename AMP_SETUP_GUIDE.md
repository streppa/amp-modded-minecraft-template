# AMP Setup Guide - Installing Generic Module

## Issue: "Generic Module" Not Available When Creating Instance

If you don't see "Generic Module" or "Generic" in your instance creation list, you need to install it first.

---

## Solution 1: Install Generic Module Application

### Step 1: Install the Generic Application

1. Open AMP web interface
2. Go to **Instances** (or **Applications**)
3. Look for **"Add New Application"** or **"Install New Application"**
4. In the application list, search for **"Generic"** or **"Generic Application"**
5. Click **Install** or **Add**
6. Wait for installation to complete

### Step 2: Create Instance with Your Template

Once Generic is installed:

1. Go to **Instances** → **Create New Instance**
2. Select **Generic** from the application type list
3. In the **Template** or **Configuration** dropdown, select **minecraftmodpack**
4. Name your instance
5. Click **Create**

---

## Solution 2: Direct Template Import (Alternative Method)

If the Generic Module still isn't available, you can import the template directly:

### Method A: Using Existing Minecraft Instance

1. Create a standard **Minecraft Java Edition** instance
2. Stop the instance
3. Go to **Configuration** → **Edit Configuration Files**
4. Replace the configuration with our template files
5. Restart AMP to load the new configuration

### Method B: Manual Template Application

1. Navigate to your AMP installation directory
2. Find the instances folder (usually `AMP/instances/`)
3. Copy an existing instance folder as a template
4. Replace these files in the new instance:
   - Instance configuration files
   - Point to our `.kvp` file
5. Restart AMP

---

## Solution 3: Check AMP Version and Modules

### Verify AMP Version

1. Open AMP web interface
2. Click your **username** (top right)
3. Go to **About** or **System Information**
4. Check the version number

**Required:** AMP v2.5.1.8 or higher (as specified in our template)

### Check Installed Modules

1. Go to **Configuration** → **AMP Configuration** (or click gear icon)
2. Look for **Installed Modules** or **Available Applications**
3. Verify **Generic Module** is in the list
4. If not, install it from the module marketplace

---

## Solution 4: Use ADS (AMP Deployment System)

If you're using ADS (the controller for multiple AMP instances):

1. Open ADS interface
2. Go to **Targets** or **Instances**
3. Click **Create New Instance**
4. From the **Application** dropdown, select **Generic**
5. From the **Template** dropdown, select **minecraftmodpack**
6. Configure and create

---

## Troubleshooting: Why Generic Module Might Not Appear

### Reason 1: Not Installed
**Solution:** Install Generic Module from AMP's application marketplace

### Reason 2: License Issue
**Solution:** Verify your AMP license supports Generic Module
- Some licenses only include specific game servers
- Professional/Enterprise licenses include Generic Module

### Reason 3: Wrong AMP Edition
**Solution:** Check if you're using:
- **AMP Standard** - May not include Generic Module
- **AMP Professional** - Should include Generic Module
- **AMP Enterprise** - Includes all modules

### Reason 4: Looking in Wrong Place
**Solution:** Try these locations:
- **Instances** → **Create Instance** → Dropdown at top
- **Applications** → **New Application**
- **ADS** (if using deployment system) → **New Target**

---

## Alternative: Use as Minecraft Java Template

If Generic Module is absolutely not available, you can adapt this as a **Minecraft Java Edition** template:

### Quick Adaptation Steps:

1. **Use Minecraft Java Edition instance** instead of Generic
2. **Before starting the server:**
   - Run the modpack installer manually:
     ```powershell
     # Windows
     pwsh -File modpack-install.ps1 -Platform "modrinth" -ModpackID "better-minecraft" -Version "latest" -InstallPath "./minecraft"

     # Linux
     bash modpack-install.sh "modrinth" "better-minecraft" "latest" "./minecraft"
     ```
3. **Configure the instance** to use the downloaded server JAR
4. **Start the server**

This bypasses the template system but achieves the same result.

---

## Where to Find Help

### Check AMP Documentation
- Main site: https://cubecoders.com/AMP
- Wiki: https://github.com/CubeCoders/AMP/wiki
- Discord: https://discord.gg/cubecoders

### Check Your AMP Installation

**Windows - Default Paths:**
```
C:\AMP\
C:\Program Files\CubeCoders\AMP\
C:\ProgramData\CubeCoders\AMP\
```

**Linux - Default Paths:**
```
/home/amp/
/opt/cubecoders/amp/
~/.ampdata/
```

### Verify Template Directory

Your templates should be in:

**Windows:**
```
C:\AMP\AMPTemplates\
[Your AMP Install Dir]\AMPTemplates\
```

**Linux:**
```
/home/amp/.ampdata/AMPTemplates/
~/.ampdata/AMPTemplates/
```

---

## Testing If Generic Module Works

Once you think Generic Module is available, test it:

1. Create a test instance with Generic Module
2. Use a simple template (like a basic Java app)
3. Verify it creates and starts successfully
4. If successful, try with our Minecraft modpack template

---

## What to Do Next

### If Generic Module is Available:
✅ Follow the main README.md setup instructions

### If Generic Module is NOT Available:
1. Check your AMP license type
2. Contact AMP support about Generic Module access
3. Consider upgrading your AMP license
4. OR use the manual installation method described above

### If You're Stuck:
1. Take a screenshot of your "Create Instance" screen
2. Note your AMP version (from About page)
3. Note your AMP license type
4. Contact AMP support with this information

---

## Quick Command to Check AMP Version

**Windows (PowerShell):**
```powershell
Get-Content "C:\AMP\InstanceInfo.json" | Select-String -Pattern "Version"
```

**Linux (Bash):**
```bash
cat /home/amp/.ampdata/InstanceInfo.json | grep -i version
```

Or check in the web interface: **Top Right Menu** → **About AMP**

---

## Summary

The Generic Module should be available in AMP v2.5+, but:
- It may need to be installed separately
- Your license must support it
- It might be in a different location in the UI

If it's truly not available, you can still use the modpack installer scripts manually or adapt the template for standard Minecraft instances.
