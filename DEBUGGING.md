# Debugging Guide for hcloud-ssh-ctl

## Quick Fix Applied

The app was exiting unexpectedly due to `set -e` which exits on any error. This has been fixed.

## How to Debug Connection Issues

### Method 1: Run in Debug Mode (Preserves Logs)

```bash
# Enable debug mode - this preserves temp files
DEBUG_MODE=1 bash src/hcloud-ssh-ctl
```

**What this does:**
- Keeps all log files after exit
- Shows temp directory location on exit
- Preserves error details for inspection

**After running:**
```bash
# Debug mode will show:
# "Debug mode: Temp files preserved at: /tmp/hcloud-ssh-ctl-12345"

# View the logs
ls /tmp/hcloud-ssh-ctl-12345/
cat /tmp/hcloud-ssh-ctl-12345/execution.log
cat /tmp/hcloud-ssh-ctl-12345/errors/*
```

### Method 2: Use the Built-in Connection Test

```bash
# Run normally
bash src/hcloud-ssh-ctl

# From main menu:
1. Select "Test SSH Connection" (option 4)
2. Select your servers
3. Enter username and port
4. View results
5. Click "View Debug Log" button to see detailed output
```

### Method 3: Manual SSH Test Before Using Tool

Test your connection parameters first:

```bash
# Test basic connection
ssh -v -i ~/.ssh/id_rsa -p 22 root@YOUR_SERVER_IP

# If port 22 doesn't work, try common alternatives:
ssh -v -i ~/.ssh/id_rsa -p 2222 root@YOUR_SERVER_IP
ssh -v -i ~/.ssh/id_rsa -p 2200 root@YOUR_SERVER_IP
ssh -v -i ~/.ssh/id_rsa -p 22000 root@YOUR_SERVER_IP

# The -v flag shows verbose output to help diagnose issues
```

## What Was Fixed

### 1. **Removed `set -e`**
- **Problem**: Script exited on any error (even non-fatal ones)
- **Fix**: Removed strict error mode, added proper error handling
- **Result**: Script continues running even if one operation fails

### 2. **Added Debug Mode**
- **Problem**: Temp files deleted immediately on exit
- **Fix**: Added `DEBUG_MODE` environment variable
- **Result**: Can inspect logs after program exits

### 3. **Fixed Dialog Display**
- **Problem**: Using `$(cat file)` in dialog caused issues with large output
- **Fix**: Using `--textbox file` to display files directly
- **Result**: Reliable display of results and logs

### 4. **Fixed Arithmetic Operations**
- **Problem**: `((count++))` could fail and cause exit
- **Fix**: Changed to `count=$((count + 1))`
- **Result**: Safer arithmetic that doesn't cause crashes

### 5. **Better Error Messages**
- **Problem**: Generic "connection failed" message
- **Fix**: Shows specific errors from SSH, suggests causes
- **Result**: Easier to diagnose issues

## Understanding the Logs

### Execution Log (`execution.log`)

Contains verbose SSH output:

```
=== SSH Execution Log ===
Timestamp: Wed Nov 27 10:30:45 2024
Username: root
Port: 22
Key: /home/user/.config/hcloud-ssh-ctl/keys/my-key.key
Command: uptime
Servers:
192.168.1.10

=== Execution Output ===
[WARNING] pssh: ssh to 192.168.1.10 failed
debug1: Reading configuration data
debug1: Connecting to 192.168.1.10 [192.168.1.10] port 22
debug1: connect to address 192.168.1.10 port 22: Connection refused
ssh: connect to host 192.168.1.10 port 22: Connection refused
```

**What to look for:**
- `Connection refused` = Wrong port or SSH not running on that port
- `Connection timed out` = Firewall or wrong IP
- `Permission denied (publickey)` = SSH key not authorized
- `No route to host` = Network/routing issue

### Output Files

**`output/SERVER_IP`**: Stdout from command
**`errors/SERVER_IP`**: Stderr from command

```bash
# View output from specific server
cat /tmp/hcloud-ssh-ctl-12345/output/192.168.1.10

# View errors from specific server
cat /tmp/hcloud-ssh-ctl-12345/errors/192.168.1.10
```

## Common Issues and Solutions

### Issue: App Exits Immediately

**Solution**: Run in debug mode to see the error:
```bash
DEBUG_MODE=1 bash src/hcloud-ssh-ctl
```

Check the preserved logs to see what failed.

### Issue: "Connection refused"

**Diagnosis**:
```bash
# Check if SSH is running on the server (if you have console access)
systemctl status sshd

# Check which port SSH is listening on
sudo ss -tlnp | grep ssh
```

**Solution**: Use the correct port in the TUI

### Issue: "Permission denied (publickey)"

**Diagnosis**:
```bash
# Verify your public key is on the server
ssh root@SERVER_IP "cat ~/.ssh/authorized_keys"

# Generate public key from your private key
ssh-keygen -y -f ~/.ssh/id_rsa
```

**Solution**: Add your public key to the server's authorized_keys

### Issue: "Connection timed out"

**Possible causes:**
1. Wrong IP address
2. Firewall blocking connection
3. Server is down
4. Network routing issue

**Test**:
```bash
# Can you ping the server?
ping -c 3 SERVER_IP

# Is the port open?
nc -zv SERVER_IP 22

# Try with telnet
telnet SERVER_IP 22
```

## Debugging Workflow

1. **Enable Debug Mode**:
   ```bash
   DEBUG_MODE=1 bash src/hcloud-ssh-ctl
   ```

2. **Run Connection Test**:
   - Main Menu → Test SSH Connection (4)
   - Select servers
   - Try different ports (22, 2222, 2200)

3. **Review Results**:
   - Read the error messages
   - Click "View Debug Log"
   - Note the specific error (refused, timeout, permission)

4. **Check Logs After Exit**:
   ```bash
   # Logs are preserved in debug mode
   cd /tmp/hcloud-ssh-ctl-*

   # View execution log
   less execution.log

   # View errors
   ls errors/
   cat errors/*
   ```

5. **Fix the Issue**:
   - Wrong port? → Try different port
   - Permission denied? → Add SSH key to server
   - Timeout? → Check firewall/IP/server status
   - Connection refused? → Check SSH is running

6. **Test Again**:
   Run connection test with corrected parameters

## Getting More Help

If you're still stuck:

1. **Run in debug mode** and save the logs:
   ```bash
   DEBUG_MODE=1 bash src/hcloud-ssh-ctl > debug-output.txt 2>&1
   ```

2. **Copy the execution log**:
   ```bash
   cp /tmp/hcloud-ssh-ctl-*/execution.log execution-debug.log
   ```

3. **Share relevant parts** (remove sensitive info like IPs, keys):
   - Execution log
   - Error messages
   - What you tried
   - Expected vs actual behavior

## Pro Tips

### Tip 1: Test Manually First
Before using the TUI, test SSH manually to verify your parameters:
```bash
ssh -v -i ~/.ssh/id_rsa -p PORT USERNAME@SERVER_IP hostname
```

If this works, use the same parameters in the TUI.

### Tip 2: Check Server-Side Logs
If you have console access to the server:
```bash
# View SSH authentication attempts
sudo tail -f /var/log/auth.log    # Debian/Ubuntu
sudo tail -f /var/log/secure       # CentOS/RHEL
```

### Tip 3: Use Connection Test First
Always use "Test SSH Connection" before executing actual commands. This helps identify issues early.

### Tip 4: Keep Debug Logs
```bash
# Create a debug log directory
mkdir ~/hcloud-ssh-ctl-debug-logs

# Run with debug mode and save location
DEBUG_MODE=1 bash src/hcloud-ssh-ctl
# After exit, copy the temp dir
cp -r /tmp/hcloud-ssh-ctl-* ~/hcloud-ssh-ctl-debug-logs/
```

## Need More Verbose Output?

For even more debugging info:
```bash
# Run with bash tracing
bash -x src/hcloud-ssh-ctl 2>&1 | tee full-debug.log
```

This shows every command executed.

---

**Quick Start Debugging:**
```bash
# 1. Enable debug mode
DEBUG_MODE=1 bash src/hcloud-ssh-ctl

# 2. Test connection (menu option 4)
# 3. View the debug log
# 4. Fix the issue based on error message
# 5. Test again
```
