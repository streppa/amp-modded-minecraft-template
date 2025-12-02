# Linux AMP Installation Guide - Minecraft Modpack Template

## Your Situation
- Running AMP on Linux
- Home server for friends
- Can't find Generic Module in instance creation

## Solution: Use the Template Directly (No Dev Version Needed!)

---

## Method 1: Direct Template Installation (Recommended)

### Step 1: Find Your AMP Installation

```bash
# Common AMP locations on Linux:
# Check which one exists:
ls /home/amp/
ls ~/.ampdata/
ls /opt/cubecoders/amp/

# Find AMP processes:
ps aux | grep -i amp
```

### Step 2: Copy Template Files

```bash
# Navigate to your template files
cd ~/Desktop/"Amp Custom imports"

# Make scripts executable
chmod +x modpack-install.sh
chmod +x start-server.sh

# Find AMP templates directory (usually one of these):
# Option A:
sudo cp *.kvp *.json *.sh /home/amp/.ampdata/AMPTemplates/

# Option B:
sudo cp *.kvp *.json *.sh ~/.ampdata/AMPTemplates/

# Option C (if using system-wide installation):
sudo cp *.kvp *.json *.sh /opt/cubecoders/amp/AMPTemplates/
```

### Step 3: Restart AMP to Load Templates

```bash
# Stop AMP (try one of these):
sudo systemctl stop amp
# OR
ampinstmgr stop

# Start AMP:
sudo systemctl start amp
# OR
ampinstmgr start
```

### Step 4: Create Instance

After restart:
1. Open AMP web interface
2. Try creating a new instance
3. Look for "minecraftmodpack" in the template dropdown or configuration options

---

## Method 2: Manual Installation (Works 100% of the Time)

If the template still doesn't show up, use the scripts manually:

### One-Time Setup

```bash
# 1. Create a standard Minecraft instance in AMP
#    (Use Minecraft Java Edition)

# 2. Stop the instance in AMP

# 3. Navigate to your template directory
cd ~/Desktop/"Amp Custom imports"

# 4. Make scripts executable
chmod +x modpack-install.sh

# 5. Find your instance directory
# Usually at:
ls /home/amp/.ampdata/instances/
# OR
ls ~/.ampdata/instances/

# 6. Run the installer
./modpack-install.sh "modrinth" "better-minecraft" "latest" "/home/amp/.ampdata/instances/[YourInstanceName]/Minecraft"

# Example with real path:
./modpack-install.sh "modrinth" "better-minecraft" "latest" "/home/amp/.ampdata/instances/MinecraftServer01/Minecraft"
```

### What This Does

1. ✅ Downloads the modpack from Modrinth
2. ✅ Extracts server files
3. ✅ Detects the server JAR
4. ✅ Sets up everything automatically

### After Running the Script

1. Open AMP web interface
2. Go to your Minecraft instance
3. Configuration → Server Settings
4. Update "Server JAR" to point to the detected JAR file (check console output)
5. Start the server!

---

## Method 3: Create a Wrapper Script (Semi-Automated)

Create a script that makes it even easier:

```bash
# Create installation script
nano ~/install-modpack.sh
```

**Paste this:**

```bash
#!/bin/bash

echo "=== AMP Minecraft Modpack Installer ==="
echo ""

# Configuration
TEMPLATE_DIR="$HOME/Desktop/Amp Custom imports"
INSTANCE_DIR="/home/amp/.ampdata/instances"

# List available instances
echo "Available Minecraft instances:"
ls -1 "$INSTANCE_DIR" | grep -i minecraft

echo ""
read -p "Enter instance name: " INSTANCE_NAME

echo ""
echo "Choose platform:"
echo "1) Modrinth (recommended)"
echo "2) CurseForge (requires API key)"
read -p "Enter choice (1 or 2): " PLATFORM_CHOICE

if [ "$PLATFORM_CHOICE" = "1" ]; then
    PLATFORM="modrinth"
elif [ "$PLATFORM_CHOICE" = "2" ]; then
    PLATFORM="curseforge"
else
    echo "Invalid choice"
    exit 1
fi

read -p "Enter modpack ID/slug: " MODPACK_ID
read -p "Enter version (or 'latest'): " VERSION

echo ""
echo "Installing $MODPACK_ID from $PLATFORM..."
echo ""

cd "$TEMPLATE_DIR"
./modpack-install.sh "$PLATFORM" "$MODPACK_ID" "$VERSION" "$INSTANCE_DIR/$INSTANCE_NAME/Minecraft"

echo ""
echo "Installation complete!"
echo "Go to AMP and start your instance."
```

**Make it executable:**

```bash
chmod +x ~/install-modpack.sh
```

**Use it:**

```bash
~/install-modpack.sh
```

---

## Method 4: Systemd Service (Advanced - Auto-Update)

Create a service that checks for modpack updates:

```bash
sudo nano /etc/systemd/system/amp-modpack-updater.service
```

**Content:**

```ini
[Unit]
Description=AMP Modpack Auto-Updater
After=network.target

[Service]
Type=oneshot
User=amp
ExecStart=/home/amp/Desktop/Amp Custom imports/modpack-install.sh modrinth better-minecraft latest /home/amp/.ampdata/instances/MinecraftServer01/Minecraft

[Install]
WantedBy=multi-user.target
```

**Enable it:**

```bash
sudo systemctl daemon-reload
sudo systemctl enable amp-modpack-updater.service
```

---

## Troubleshooting Linux-Specific Issues

### Permission Denied

```bash
# Fix script permissions:
chmod +x modpack-install.sh
chmod +x start-server.sh

# If AMP runs as different user:
sudo chown amp:amp modpack-install.sh
sudo chown amp:amp start-server.sh
```

### Command Not Found: unzip

```bash
# Install required tools:
sudo apt-get update
sudo apt-get install unzip curl jq

# OR on RHEL/CentOS:
sudo yum install unzip curl jq
```

### Cannot Find Instance Directory

```bash
# Find AMP installation:
find / -name "amp" -type d 2>/dev/null | grep -v proc

# Find Minecraft instances:
find / -name "*.jar" -path "*/Minecraft/*" 2>/dev/null | grep -i server
```

### Script Won't Download

```bash
# Test internet connectivity:
curl -I https://api.modrinth.com/v2/project/better-minecraft

# If blocked by firewall, check:
sudo ufw status
sudo iptables -L
```

---

## Quick Reference Commands

### Install a Modrinth Modpack

```bash
cd ~/Desktop/"Amp Custom imports"
./modpack-install.sh "modrinth" "MODPACK-SLUG" "latest" "/path/to/instance/Minecraft"
```

### Install a CurseForge Modpack

```bash
export CURSEFORGE_API_KEY="your-key-here"
cd ~/Desktop/"Amp Custom imports"
./modpack-install.sh "curseforge" "PROJECT-ID" "latest" "/path/to/instance/Minecraft"
```

### Check Installation Progress

```bash
tail -f /home/amp/.ampdata/instances/[InstanceName]/AMP_Logs/[latest-log].log
```

---

## Recommendation for Your Home Server

For a **home server for friends**, I recommend:

✅ **Use Method 2 (Manual Installation)** - It's simple and reliable

**Workflow:**
1. Create Minecraft instance in AMP
2. Run the installer script with your chosen modpack
3. Start the server in AMP
4. Play with friends!

**When you want to change modpacks:**
1. Stop server in AMP
2. Run installer script with new modpack
3. Start server again

**This approach:**
- ✅ No dev version needed
- ✅ No complex AMP configuration
- ✅ Works 100% reliably
- ✅ Easy to update modpacks
- ✅ Perfect for home servers

---

## Do NOT Switch to Dev Version

For a home server, you **definitely don't need dev version** because:
- The scripts work independently of AMP version
- Manual method is actually simpler
- Dev version might crash during gameplay with friends
- Stable version is much better for reliability

---

## Summary

**Best Solution for You:**
1. Use stable AMP version (what you have now)
2. Create a normal Minecraft instance
3. Run `modpack-install.sh` manually when you want to install/change modpacks
4. Start the server normally in AMP

**This gives you:**
- ✅ Full modpack support (CurseForge + Modrinth)
- ✅ Reliable stable AMP
- ✅ Easy modpack management
- ✅ Perfect for friends server

No dev version needed!
