# hcloud-ssh-ctl

A terminal-based user interface (TUI) for managing and executing SSH commands on Hetzner Cloud servers.

## Features

- **Multi-project Support**: Manage multiple Hetzner Cloud projects with separate API keys
- **Server Management**: List, filter, and select servers from your projects
- **SSH Key Management**: Store and manage SSH private keys securely
- **Parallel SSH Execution**: Execute commands on multiple servers simultaneously
- **User-friendly TUI**: Easy-to-use dialog-based interface
- **Secure Configuration**: All credentials stored securely in `~/.config/hcloud-ssh-ctl/`

## Requirements

- Bash 4.0+
- `dialog` - For TUI interface
- `jq` - For JSON parsing
- `curl` - For API calls
- `pssh` (parallel-ssh) - For parallel SSH execution

## Installation

### From APT Repository (Recommended)

```bash
# Add the repository (instructions below for setting up your own repository)
sudo apt-get update
sudo apt-get install hcloud-ssh-ctl
```

### From Source

```bash
# Clone the repository
git clone https://github.com/KamranBiglari/hcloud-ssh-ctl.git
cd hcloud-ssh-ctl

# Install dependencies
sudo apt-get install dialog jq curl pssh

# Install
sudo make install
```

### Build Debian Package

```bash
# Install build dependencies
sudo apt-get install debhelper devscripts

# Build the package
make build-deb

# Install the package
sudo dpkg -i ../hcloud-ssh-ctl_*.deb

# Install missing dependencies if any
sudo apt-get install -f
```

## Usage

Simply run:

```bash
hcloud-ssh-ctl
```

### First-time Setup

1. **Add a Project**:
   - Select "Manage Projects" from the main menu
   - Choose "Add/Update Project"
   - Enter your project name
   - Enter your Hetzner Cloud API key

2. **Add SSH Keys** (Two methods):

   **Method A - Import from File (Recommended)**:
   - Select "Manage SSH Keys" from the main menu
   - Choose "Import SSH Key from File"
   - Enter a name for the key
   - Enter the path to your key file (e.g., `~/.ssh/id_rsa`)

   **Method B - Paste Manually**:
   - Select "Manage SSH Keys" from the main menu
   - Choose "Add SSH Private Key (Paste)"
   - Enter a name for the key
   - Delete the instruction lines and paste your private key content
   - Save and exit

### Executing SSH Commands

1. Select "Execute SSH Commands" from the main menu
2. Choose a project
3. Filter servers (optional) and select target servers
4. Choose an SSH key
5. Enter SSH username (default: root)
6. Enter SSH port (default: 22)
7. Enter the command to execute
8. View results for each server

## Configuration

Configuration files are stored in `~/.config/hcloud-ssh-ctl/`:

- `config` - Project configurations and API keys (JSON format)
- `keys/` - SSH private keys (one file per key)

### Configuration File Format

```json
{
  "project-name": {
    "api_key": "your-hetzner-api-key"
  }
}
```

## Setting Up APT Repository

To distribute your package via APT, you'll need to set up a Debian repository. Here's a simple guide:

### Option 1: GitHub Releases + packagecloud.io

1. Sign up at [packagecloud.io](https://packagecloud.io)
2. Create a repository
3. Upload your `.deb` file
4. Users can add your repository:

```bash
curl -s https://packagecloud.io/install/repositories/your-username/hcloud-ssh-ctl/script.deb.sh | sudo bash
sudo apt-get install hcloud-ssh-ctl
```

### Option 2: Self-hosted Repository

1. Set up a web server (nginx/apache)
2. Create repository structure:

```bash
# Create directory structure
mkdir -p /var/www/apt/pool/main
mkdir -p /var/www/apt/dists/stable/main/binary-amd64

# Copy your .deb file
cp hcloud-ssh-ctl_*.deb /var/www/apt/pool/main/

# Generate Packages file
cd /var/www/apt
dpkg-scanpackages pool/main /dev/null | gzip -9c > dists/stable/main/binary-amd64/Packages.gz

# Generate Release file
cd dists/stable
cat > Release <<EOF
Origin: hcloud-ssh-ctl
Label: hcloud-ssh-ctl
Suite: stable
Codename: stable
Architectures: all
Components: main
Description: Hetzner Cloud SSH Control Repository
EOF

# Generate Release.gpg (optional but recommended)
gpg --armor --detach-sign -o Release.gpg Release
```

3. Users add your repository:

```bash
echo "deb [trusted=yes] http://your-server.com/apt stable main" | sudo tee /etc/apt/sources.list.d/hcloud-ssh-ctl.list
sudo apt-get update
sudo apt-get install hcloud-ssh-ctl
```

### Option 3: GitHub Pages + apt-get

1. Create a `gh-pages` branch
2. Set up repository structure there
3. Enable GitHub Pages
4. Users can use:

```bash
echo "deb [trusted=yes] https://your-username.github.io/hcloud-ssh-ctl stable main" | sudo tee /etc/apt/sources.list.d/hcloud-ssh-ctl.list
```

## Security Considerations

- API keys are stored in `~/.config/hcloud-ssh-ctl/config` with permissions 600
- SSH private keys are stored in `~/.config/hcloud-ssh-ctl/keys/` with permissions 600
- The configuration directory has permissions 700
- SSH connections use `StrictHostKeyChecking=no` for convenience - consider changing this for production use

## Troubleshooting

### Common Issues

**SSH Key Problems**:
- **App exits when adding key**: Use "Import SSH Key from File" instead of paste
- **Can't paste key**: Import directly from `~/.ssh/id_rsa` using the import option
- **Permission denied**: Ensure your public key is in the server's `~/.ssh/authorized_keys`

**Connection Issues**:
- **Connection failed**: Try username `root` (Hetzner default) or `ubuntu` for Ubuntu images
- **Custom SSH port**: If using non-standard port, enter it when prompted (default is 22)
- **No servers found**: Verify API key has read permissions and correct project selected

**Installation Issues**:
- **Missing dependencies**: Run `sudo apt-get install dialog jq curl pssh`

For detailed troubleshooting, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Author

Kamran Biglari

## Support

For issues and questions, please use the [GitHub issue tracker](https://github.com/KamranBiglari/hcloud-ssh-ctl/issues).
