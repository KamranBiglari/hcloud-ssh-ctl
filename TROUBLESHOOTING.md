# Troubleshooting Guide

Common issues and solutions for hcloud-ssh-ctl.

## SSH Key Issues

### Issue: App exits when adding SSH key name

**Cause**: Earlier versions had issues with dialog exit handling.

**Solution**: Update to the latest version. The fix includes:
- Proper exit status checking when dialog is cancelled
- Better handling of empty inputs
- Template file with instructions

### Issue: Can't paste SSH private key

**Problem**: The editbox doesn't accept pasted content properly.

**Solutions**:

1. **Use the Import from File option** (Easiest):
   ```
   Main Menu → Manage SSH Keys → Import SSH Key from File
   Enter key name: my-key
   Enter path: ~/.ssh/id_rsa
   ```

2. **Use the Paste option with proper steps**:
   - Select "Add SSH Private Key (Paste)"
   - In the editor, delete the instruction lines (lines starting with #)
   - Paste your private key
   - The key should start with `-----BEGIN` and end with `-----END`
   - Save and exit

3. **Manual copy method**:
   ```bash
   # Copy your key manually
   mkdir -p ~/.config/hcloud-ssh-ctl/keys
   cp ~/.ssh/id_rsa ~/.config/hcloud-ssh-ctl/keys/my-key.key
   chmod 600 ~/.config/hcloud-ssh-ctl/keys/my-key.key
   ```

### Issue: SSH key format not recognized

**Problem**: "Permission denied" or "invalid format" errors.

**Check your key format**:

```bash
# View your key
head -1 ~/.ssh/id_rsa
```

Should show one of:
- `-----BEGIN OPENSSH PRIVATE KEY-----`
- `-----BEGIN RSA PRIVATE KEY-----`
- `-----BEGIN EC PRIVATE KEY-----`

**Common issues**:
- Using public key instead of private key (`.pub` file)
- Key is password-protected (remove passphrase first)
- Wrong file permissions (should be 600)

**Fix**:
```bash
# Ensure correct permissions
chmod 600 ~/.ssh/id_rsa

# Remove passphrase if needed
ssh-keygen -p -f ~/.ssh/id_rsa
```

## Connection Issues

### Issue: Connection failed to servers

**Possible causes**:

1. **Wrong username**:
   - Hetzner servers usually use `root` (default)
   - Ubuntu images might use `ubuntu`
   - Custom images may have different users

2. **SSH key not authorized**:
   ```bash
   # Check if your public key is on the server
   ssh root@SERVER_IP "cat ~/.ssh/authorized_keys"
   ```

3. **Firewall blocking**:
   - Check Hetzner Cloud Firewall settings
   - Verify port 22 is open

4. **Server not running**:
   - Check server status in Hetzner Cloud Console

### Issue: "Permission denied (publickey)"

**Solutions**:

1. **Verify key is on the server**:
   ```bash
   # Get your public key
   ssh-keygen -y -f ~/.ssh/id_rsa

   # Add to server (if you have password access)
   ssh-copy-id -i ~/.ssh/id_rsa root@SERVER_IP
   ```

2. **Check key permissions locally**:
   ```bash
   ls -la ~/.config/hcloud-ssh-ctl/keys/
   # Should show: -rw------- (600)
   ```

3. **Test connection manually**:
   ```bash
   ssh -i ~/.config/hcloud-ssh-ctl/keys/my-key.key root@SERVER_IP
   ```

### Issue: Connection timeout or "No route to host"

**Possible causes**:

1. **Non-standard SSH port**:
   - Server might be using a custom SSH port (not 22)
   - When executing commands, enter the correct port when prompted
   - Default is 22, but many servers use different ports for security

2. **Test with custom port**:
   ```bash
   # Test connection manually with custom port
   ssh -i ~/.ssh/id_rsa -p 2222 root@SERVER_IP

   # If this works, use port 2222 in the TUI when prompted
   ```

3. **Check which port SSH is listening on**:
   ```bash
   # If you have console access to the server
   sudo netstat -tlnp | grep ssh
   # Or
   sudo ss -tlnp | grep ssh
   ```

**Solution in hcloud-ssh-ctl**:
- When executing commands, you'll be prompted for SSH port
- Enter your custom port (e.g., `2222`, `2200`, `22000`)
- The tool will use this port for all selected servers
- Port is validated to ensure it's a number

## API Issues

### Issue: "No servers found" or API errors

**Possible causes**:

1. **Invalid API key**:
   - Get new key from: https://console.hetzner.cloud/ → Project → Security → API Tokens
   - Ensure "Read" permission is enabled

2. **Wrong project**:
   - Verify you selected the correct project
   - Check servers exist in that project

3. **Network issues**:
   ```bash
   # Test API manually
   curl -H "Authorization: Bearer YOUR_API_KEY" \
     https://api.hetzner.cloud/v1/servers
   ```

### Issue: API key keeps getting rejected

**Solution**:
1. Delete old project configuration:
   ```bash
   # Edit config
   nano ~/.config/hcloud-ssh-ctl/config
   # Or delete and recreate
   rm ~/.config/hcloud-ssh-ctl/config
   ```

2. Add project again with new API key

## Installation Issues

### Issue: "Command not found: dialog"

**Solution**:
```bash
sudo apt-get update
sudo apt-get install dialog jq curl pssh
```

### Issue: "parallel-ssh: command not found"

**Solution**:
```bash
# On Debian/Ubuntu
sudo apt-get install pssh

# The package provides: parallel-ssh, parallel-scp, etc.
```

### Issue: Package installation fails

**Solution**:
```bash
# If using .deb package
sudo dpkg -i hcloud-ssh-ctl_*.deb
sudo apt-get install -f  # Install missing dependencies

# Or install dependencies first
sudo apt-get install dialog jq curl pssh
sudo dpkg -i hcloud-ssh-ctl_*.deb
```

## UI/Display Issues

### Issue: Dialog boxes look corrupted

**Possible causes**:
- Terminal too small
- Terminal encoding issues

**Solutions**:

1. **Resize terminal**:
   - Minimum recommended: 80x24 characters
   - Recommended: 100x40 or larger

2. **Check terminal type**:
   ```bash
   echo $TERM
   # Should show: xterm, xterm-256color, screen, etc.
   ```

3. **Set proper locale**:
   ```bash
   export LANG=en_US.UTF-8
   export LC_ALL=en_US.UTF-8
   ```

### Issue: Colors not working

**Solution**:
```bash
# Use 256 color terminal
export TERM=xterm-256color
```

## Configuration Issues

### Issue: Lost configuration after upgrade

**Solution**:
Configuration is preserved in `~/.config/hcloud-ssh-ctl/`

```bash
# Check config exists
ls -la ~/.config/hcloud-ssh-ctl/

# View config
cat ~/.config/hcloud-ssh-ctl/config

# List saved keys
ls ~/.config/hcloud-ssh-ctl/keys/
```

### Issue: Want to reset configuration

**Solution**:
```bash
# Backup first (optional)
cp -r ~/.config/hcloud-ssh-ctl ~/.config/hcloud-ssh-ctl.backup

# Remove configuration
rm -rf ~/.config/hcloud-ssh-ctl

# Restart app - will create fresh config
hcloud-ssh-ctl
```

## Execution Issues

### Issue: Commands time out

**Possible causes**:
- Long-running commands
- Network latency
- Servers not responding

**Solution**:
The tool uses `parallel-ssh` which has default timeouts. For long-running commands:

1. **Use background jobs**:
   ```bash
   # Instead of: apt-get upgrade
   # Use: nohup apt-get upgrade > /tmp/upgrade.log 2>&1 &
   ```

2. **Check status later**:
   ```bash
   # First command: start the process
   nohup long-command > /tmp/output.log 2>&1 &

   # Second command: check if running
   ps aux | grep long-command

   # Third command: check output
   tail -20 /tmp/output.log
   ```

### Issue: Different outputs from different servers

**This is expected!** Each server may have:
- Different installed packages
- Different configurations
- Different states

**Review outputs carefully** in the results dialog.

## Getting More Help

### Enable Debug Mode

For troubleshooting, you can run commands manually:

```bash
# Test API connection
API_KEY="your-key-here"
curl -H "Authorization: Bearer $API_KEY" \
  https://api.hetzner.cloud/v1/servers | jq .

# Test SSH connection
ssh -i ~/.config/hcloud-ssh-ctl/keys/my-key.key \
  -o StrictHostKeyChecking=no \
  root@SERVER_IP "hostname"

# Test parallel-ssh
echo "SERVER_IP" > /tmp/hosts
parallel-ssh -h /tmp/hosts \
  -i \
  -x "-i ~/.config/hcloud-ssh-ctl/keys/my-key.key" \
  -l root \
  "uptime"
```

### Check Logs

```bash
# Dialog doesn't log, but you can trace execution
bash -x src/hcloud-ssh-ctl 2> /tmp/debug.log
```

### Report Issues

If you can't solve the issue:

1. **Gather information**:
   - OS version: `cat /etc/os-release`
   - App version: Check "About" in the app
   - Error messages
   - Steps to reproduce

2. **Report at**:
   https://github.com/KamranBiglari/hcloud-ssh-ctl/issues

3. **Include**:
   - Description of the problem
   - Steps to reproduce
   - Expected vs actual behavior
   - System information
   - **DO NOT include API keys or private keys!**

## Quick Fixes Summary

| Problem | Quick Fix |
|---------|-----------|
| Can't paste SSH key | Use "Import from File" option |
| App exits on key add | Update to latest version |
| Connection failed | Check username (try `root` or `ubuntu`) and port (default 22) |
| Connection timeout | Try custom SSH port (enter when prompted) |
| No servers found | Verify API key and project |
| Command not found | `sudo apt-get install dialog jq curl pssh` |
| Permission denied | Check SSH key is authorized on server |
| Dialog looks wrong | Resize terminal to 80x24 minimum |
| Lost configuration | Check `~/.config/hcloud-ssh-ctl/` |

## Still Need Help?

- 📖 Read: [README.md](README.md)
- 🚀 Quick Start: [QUICKSTART.md](QUICKSTART.md)
- 📝 Man page: `man hcloud-ssh-ctl`
- 🐛 Report: [GitHub Issues](https://github.com/KamranBiglari/hcloud-ssh-ctl/issues)
