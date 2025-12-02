# Quick Start Guide - Minecraft Modpack Template

## ⚡ Fast Setup (5 Minutes)

### Step 1: Install the Template (2 min)

Copy all files to your AMP templates directory:

**Windows:**
```powershell
# Copy all files to
C:\AMP\AMPTemplates\
```

**Linux:**
```bash
# Copy all files to
/home/amp/.ampdata/AMPTemplates/
```

Files to copy:
- ✅ `minecraftmodpack.kvp`
- ✅ `minecraftmodpackconfig.json`
- ✅ `minecraftmodpackmetaconfig.json`
- ✅ `minecraftmodpackports.json`
- ✅ `minecraftmodpackupdates.json`
- ✅ `modpack-install.ps1` (Windows)
- ✅ `modpack-install.sh` (Linux)

### Step 2: Create AMP Instance (1 min)

1. Open AMP web interface
2. Click **Create Instance**
3. Choose **Generic Module**
4. Select **minecraftmodpack** template
5. Name your instance (e.g., "My Modpack Server")
6. Click **Create**

### Step 3: Choose a Modpack (2 min)

1. Open your new instance
2. Go to **Configuration** tab
3. Find **Modpack Settings** section
4. Fill in:

```
Modpack Platform: Modrinth
Modpack ID/Slug: better-minecraft
Modpack Version: latest
Install Modpack: ✅ Checked
```

5. Click **"Update"** button at top (NOT "Start"!)
6. **IMPORTANT:** Wait for the update/installation to complete
   - Watch the console output for download progress
   - Installation takes 1-5 minutes depending on modpack size
   - Look for "Installation Complete" or similar success message
7. Once installation completes, click **"Start"** to launch the server

**Done! Your modpack server is running! 🎉**

---

## 🔥 Recommended Modpacks for First-Time Setup

These are tested and work well:

### Easy & Popular (Modrinth)

1. **Better Minecraft** - `better-minecraft`
   - Enhanced vanilla with quality of life mods
   - Works great for beginners
   - 4GB RAM minimum

2. **Fabulously Optimized** - `fabulously-optimized`
   - Vanilla Minecraft but optimized
   - Great performance
   - 2GB RAM minimum

3. **Medieval Minecraft** - `medieval-minecraft`
   - Medieval themed adventure
   - Beautiful builds and quests
   - 4GB RAM minimum

### Tech/Automation (Modrinth)

1. **All of Fabric** - `aof`
   - Tech and magic mods
   - Fabric-based
   - 4GB RAM minimum

2. **Create: Above and Beyond** - `create-above-and-beyond`
   - Engineering and automation
   - Quest-based progression
   - 6GB RAM minimum

---

## ⚙️ Essential Settings

After installation, configure these in AMP:

### Memory Settings
- **Initial Memory**: Start with 2048 MB (2GB)
- **Maximum Memory**: 4096 MB (4GB) for small packs, 6-8GB for large packs

### Server Settings
- **Server Port**: 25565 (default, change if needed)
- **Max Players**: 20 (adjust based on your needs)
- **Server Name**: Your custom MOTD

### Gameplay Settings
- **Game Mode**: Survival (or Creative for testing)
- **Difficulty**: Normal
- **Online Mode**: Keep enabled for legitimate players

---

## 🔍 Troubleshooting

### Installation Stuck?
- Check console for error messages
- Ensure internet connection is working
- Verify modpack ID/slug is correct

### "Server JAR not found"?
- Installation may not be complete
- Check if modpack files are in minecraft/ folder
- Try manual download if automatic fails

### Out of Memory Error?
- Increase **Maximum Memory** in settings
- Restart the server
- Large modpacks need 6-8GB

### Wrong Minecraft Version?
- Specify exact version in **Modpack Version** field
- Check modpack page for available versions

---

## 📋 What Happens When You Install?

```
[You Check "Install Modpack"]
         ↓
[AMP Saves Configuration]
         ↓
[Installation Script Runs]
         ↓
[Downloads Modpack from Platform]
         ↓
[Extracts Server Files]
         ↓
[Detects Server JAR]
         ↓
[Configures Settings]
         ↓
[Ready to Start! 🎉]
```

---

## 🎮 Connecting to Your Server

Once the server starts:

1. Open Minecraft (same version as modpack)
2. Install the **CLIENT version** of the modpack (from CurseForge/Modrinth launcher)
3. Click **Multiplayer**
4. Click **Add Server**
5. Enter:
   - **Server Name**: Whatever you want
   - **Server Address**: `your-server-ip:25565`
6. Click **Done** and **Join Server**

**Important:** The server and client must use the same modpack!

---

## 🔄 Updating a Modpack

To update to a newer version:

1. Go to **Configuration**
2. Change **Modpack Version** to new version or keep as `latest`
3. Check **Install Modpack** again
4. Click **Update**
5. Restart server

**Warning:** Back up your world before updating!

---

## 📞 Getting Help

- **AMP Issues**: https://cubecoders.com/support
- **Template Issues**: Check README.md in template folder
- **Modpack Issues**: Visit the modpack's page on CurseForge/Modrinth

---

## ✅ Checklist

Before asking for help, verify:

- [ ] All template files are in the correct directory
- [ ] AMP instance is using the minecraftmodpack template
- [ ] Modpack Platform is set correctly (CurseForge or Modrinth)
- [ ] Modpack ID/Slug is correct (check the modpack page URL)
- [ ] "Install Modpack" checkbox is checked
- [ ] Console shows installation progress/errors
- [ ] Sufficient RAM is allocated
- [ ] Java is installed and in PATH

---

## 🚀 Advanced Tips

### Multiple Modpacks
- Create separate AMP instances for each modpack
- Use different ports for each (25565, 25566, 25567, etc.)

### Auto-Update
- Enable **Auto-Install on Startup** to check for updates automatically
- Be careful: auto-updates may break existing worlds

### Custom Java Args
- Edit command line in KVP file for custom JVM arguments
- Useful for garbage collection tuning on large servers

### Backup Strategy
- Use AMP's built-in backup feature
- Schedule automatic backups before updates
- Keep at least 3 backup copies

---

**Need more details? See README.md for full documentation.**
