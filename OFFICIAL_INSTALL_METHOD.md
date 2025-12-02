# Official AMP Template Installation Method (2024)

Based on: [Official AMP Wiki - Configuring Generic Module](https://github.com/CubeCoders/AMP/wiki/Configuring-the-'Generic'-AMP-module)

## ⚠️ Important Discovery

The **correct method has changed**! Instead of copying files to local directories, AMP now uses **GitHub repositories** for custom templates.

---

## Method 1: Use GitHub Repository (Official Recommended)

### Step 1: Create GitHub Repository

1. **Create a new GitHub repository** (or fork [CubeCoders/AMPTemplates](https://github.com/CubeCoders/AMPTemplates))
   - Repository name example: `amp-minecraft-modpack`
   - Make it **public** (so AMP can access it)

2. **Upload all template files** to the repository root:
   - ✅ `manifest.json` (REQUIRED!)
   - ✅ `minecraftmodpack.kvp`
   - ✅ `minecraftmodpackconfig.json`
   - ✅ `minecraftmodpackmetaconfig.json`
   - ✅ `minecraftmodpackports.json`
   - ✅ `minecraftmodpackupdates.json`
   - ✅ `modpack-install.ps1`
   - ✅ `modpack-install.sh`
   - ✅ `README.md`

3. **Edit manifest.json** with your repository details:
   ```json
   {
       "id": "minecraft-modpack-installer",
       "authors": ["YourUsername"],
       "origin": "https://github.com/YOUR-USERNAME/amp-minecraft-modpack.git",
       "url": "https://github.com/YOUR-USERNAME/amp-minecraft-modpack",
       "prefix": "ModpackInstaller",
       "repotype": "git",
       "branch": "main",
       "description": "Minecraft modpack server template with CurseForge and Modrinth support"
   }
   ```

   **IMPORTANT:** Change `YOUR-USERNAME` to your actual GitHub username!

### Step 2: Add Repository to AMP

1. Open **AMP web interface**

2. Go to **Configuration** → **Instance Deployment**

3. Under **Configuration Repositories**, click **Add**

4. Enter your repository in format: `YOUR-USERNAME/amp-minecraft-modpack:main`
   - Example: `john-doe/amp-minecraft-modpack:main`

5. Click **Fetch** to load the repository

6. **Refresh your browser**

### Step 3: Create Instance with Your Template

1. Go to **Instances** → **Create New Instance**

2. In the application/template dropdown, look for:
   - `ModpackInstaller - minecraftmodpack`
   - Or similar (based on your prefix in manifest.json)

3. Select it and create your instance

4. Configure modpack settings as usual!

---

## Method 2: Use CubeCoders Repository (Contribute to Community)

If you want to share with the whole AMP community:

### Step 1: Fork Official Repository

1. Go to: https://github.com/CubeCoders/AMPTemplates

2. Click **Fork** to create your own copy

3. Clone your fork locally or edit on GitHub

### Step 2: Add Your Template Files

1. Add all your template files to the repository root

2. **Edit manifest.json** in the repository:
   - Change `id`, `origin`, `url`, `prefix` to be unique

3. **Important:** If you plan to submit a pull request:
   - **Revert or exclude manifest.json changes** before the PR
   - Only submit the template files themselves

### Step 3: Submit Pull Request

1. Create a **pull request** to CubeCoders/AMPTemplates

2. Wait for review and approval

3. Once merged, your template becomes available to **all AMP users globally**!

---

## Method 3: Local Testing (Quick & Easy for Home Server)

For your **Linux home server**, if you don't want to use GitHub:

### Option A: Use the Scripts Standalone

**You don't actually need the Generic Module template at all!**

Just:
1. Create a regular **Minecraft Java Edition** instance in AMP
2. Run the `modpack-install.sh` script manually
3. Start the server

**This is actually simpler for home servers!**

```bash
# One-time setup
cd ~/Desktop/"Amp Custom imports"
chmod +x modpack-install.sh

# Install a modpack (repeat anytime you want to change modpacks)
./modpack-install.sh "modrinth" "better-minecraft" "latest" "/path/to/amp/instances/YourInstance/Minecraft"

# Start server in AMP
```

### Option B: Create Local Git Repository

If you want to test before publishing to GitHub:

```bash
# Create local git repo
cd ~/Desktop/"Amp Custom imports"
git init
git add .
git commit -m "Initial commit"

# Serve it locally (requires git daemon or local web server)
# Then add to AMP using: file:///path/to/repo
```

---

## Key Differences from Old Method

### ❌ Old Method (No Longer Used):
- Copy files to `AMPTemplates/` directory
- Restart AMP to load templates
- Templates appear automatically

### ✅ New Method (Current 2024):
- Upload files to **GitHub repository**
- Include **manifest.json** file
- Add repository URL to **AMP Configuration**
- Templates appear with custom prefix

---

## Why This Changed

From the [official documentation](https://discourse.cubecoders.com/t/generic-module-new-configuration/2806) and [templates support thread](https://discourse.cubecoders.com/t/generictemplates-do-not-show-up/2217):

1. **Centralized management**: Easier to update templates across multiple AMP installations
2. **Version control**: Git provides history and rollback
3. **Community sharing**: Easy to fork and contribute
4. **Automatic updates**: AMP can fetch updates from repositories
5. **manifest.json requirement**: Prevents conflicts between different template collections

---

## Recommended Approach for Your Linux Home Server

Given that you're running a **home server for friends**, I recommend:

### 🎯 Best Option: Manual Script Method (No GitHub Needed!)

**Why this is better for you:**
- ✅ No need to create GitHub repository
- ✅ No need to configure AMP repositories
- ✅ Works immediately
- ✅ Simple and reliable
- ✅ Easy to change modpacks

**How it works:**
1. Create normal Minecraft instance in AMP
2. Run `./modpack-install.sh "modrinth" "modpack-name" "latest" "/path/to/instance"`
3. Start server
4. Done!

**When you want to change modpacks:**
1. Stop server
2. Run script again with different modpack
3. Start server

This gives you **all the benefits** of the template without needing to set up GitHub or repository configurations.

---

## Tools for Creating Templates

Official tools mentioned in the [AMP Wiki](https://github.com/CubeCoders/AMP/wiki/Configuring-the-'Generic'-AMP-module):

1. **Basic Config Generator**: https://config.getamp.sh/
2. **Advanced Config Generator (Beta)**: https://iceofwraith.github.io/GenericConfigGen/

These tools help create the `config.json` file with proper formatting.

---

## Summary

**Official Method (2024):**
1. Create GitHub repository with template files + manifest.json
2. Add repository to AMP via Configuration → Instance Deployment
3. Create instances using the template from the repository

**For Your Home Server:**
- Skip the template complexity
- Use the manual script method
- Much simpler and works perfectly for friends server!

---

## Sources

- [Configuring Generic AMP Module - Official Wiki](https://github.com/CubeCoders/AMP/wiki/Configuring-the-'Generic'-AMP-module)
- [AMPTemplates Repository](https://github.com/CubeCoders/AMPTemplates)
- [Generic Module Configuration Support Thread](https://discourse.cubecoders.com/t/generic-module-new-configuration/2806)
- [GenericTemplates Not Showing Up - Support Thread](https://discourse.cubecoders.com/t/generictemplates-do-not-show-up/2217)
