# Quick Start Guide

Get up and running with `hcloud-ssh-ctl` in minutes!

## Installation

### Option 1: Build and Install from Source

```bash
# Clone the repository
git clone https://github.com/KamranBiglari/hcloud-ssh-ctl.git
cd hcloud-ssh-ctl

# Install dependencies
sudo apt-get update
sudo apt-get install dialog jq curl pssh

# Install the tool
sudo make install

# Or build a .deb package
sudo apt-get install devscripts debhelper
make build-deb
sudo dpkg -i ../hcloud-ssh-ctl_*.deb
sudo apt-get install -f
```

### Option 2: Install from Pre-built Package

```bash
# Download the .deb file from releases
wget https://github.com/KamranBiglari/hcloud-ssh-ctl/releases/download/v1.0.0/hcloud-ssh-ctl_1.0.0_all.deb

# Install
sudo dpkg -i hcloud-ssh-ctl_1.0.0_all.deb
sudo apt-get install -f
```

## First Run

1. **Start the application**:
   ```bash
   hcloud-ssh-ctl
   ```

2. **Add your first project**:
   - Select `1` for "Manage Projects"
   - Select `1` for "Add/Update Project"
   - Enter a name (e.g., "my-project")
   - Enter your Hetzner Cloud API key
     - Get it from: https://console.hetzner.cloud/ → Project → Security → API Tokens

3. **Add an SSH key** (Easiest method):
   - Go back to main menu (select `5`)
   - Select `2` for "Manage SSH Keys"
   - Select `2` for "Import SSH Key from File"
   - Enter a name (e.g., "default")
   - Enter the path: `~/.ssh/id_rsa` (or your key file path)

   Alternative - Paste manually:
   - Select `1` for "Add SSH Private Key (Paste)"
   - Enter a name, delete instruction lines, paste key, save and exit

4. **Execute your first command**:
   - Go back to main menu
   - Select `3` for "Execute SSH Commands"
   - Select your project
   - Filter servers (or leave empty for all)
   - Check the servers you want (use `Space` to select, `Enter` to confirm)
   - Select your SSH key
   - Enter username (default: `root`)
   - Enter SSH port (default: `22`, change if using custom port)
   - Enter a command (e.g., `uptime`)
   - View results!

## Example Workflow

Here's a complete example:

```bash
# Start the tool
hcloud-ssh-ctl

# Configure (first time only)
1 → Manage Projects
  1 → Add/Update Project
    Project name: production
    API Key: your-hetzner-api-key

4 → Back to Main Menu

2 → Manage SSH Keys
  1 → Add SSH Private Key
    Name: prod-key
    [Paste your private key]

4 → Back to Main Menu

# Execute commands
3 → Execute SSH Commands
  Select project: production
  Filter: web  (to filter servers with "web" in name)
  [Select servers with Space, confirm with Enter]
  Select SSH key: prod-key
  Username: root
  Command: df -h
  [View results]
```

## Common Commands to Try

Once connected, here are some useful commands:

```bash
# Check disk usage
df -h

# Check memory
free -h

# Check uptime
uptime

# Check running services
systemctl list-units --type=service --state=running

# Update packages (Ubuntu/Debian)
apt-get update && apt-get upgrade -y

# Check logs
tail -n 50 /var/log/syslog

# Check Docker containers (if Docker is installed)
docker ps
```

## Tips

- **Multiple Servers**: Use the filter to quickly find specific servers
- **Select All**: Press `Space` on each server or use a more specific filter
- **Save Time**: Save commonly used SSH keys instead of pasting each time
- **Multiple Projects**: Easily switch between different Hetzner projects
- **Secure**: All credentials are stored in `~/.config/hcloud-ssh-ctl/` with proper permissions

## Troubleshooting

### "Missing dependencies" error
```bash
sudo apt-get install dialog jq curl pssh
```

### "Connection failed" for servers
- Check if the server IP is correct
- Verify SSH key has proper permissions
- Ensure the server allows SSH connections
- Verify username (usually `root` for Hetzner servers)

### "API key invalid"
- Verify your API key at https://console.hetzner.cloud/
- Ensure the key has read permissions
- Check if the key belongs to the correct project

## What's Next?

- Set up multiple projects for different environments
- Add multiple SSH keys for different access levels
- Explore filtering options to target specific servers
- Consider creating a bash alias: `alias hctl='hcloud-ssh-ctl'`

## Getting Help

- Run `man hcloud-ssh-ctl` for detailed documentation
- Check README.md for full documentation
- Report issues: https://github.com/KamranBiglari/hcloud-ssh-ctl/issues

Happy server management! 🚀
