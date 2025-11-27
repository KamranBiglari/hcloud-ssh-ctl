#!/bin/bash
#
# Setup self-hosted APT repository for hcloud-ssh-ctl
# This script helps you create a Debian repository structure
#

set -e

REPO_DIR="${1:-./apt-repo}"
DEB_FILE="${2}"

if [ -z "$DEB_FILE" ] || [ ! -f "$DEB_FILE" ]; then
    echo "Usage: $0 [repo-directory] <path-to-deb-file>"
    echo ""
    echo "Example:"
    echo "  $0 ./apt-repo ../hcloud-ssh-ctl_1.0.0_all.deb"
    echo ""
    echo "This will create an APT repository structure in ./apt-repo"
    exit 1
fi

echo "Setting up APT repository in: $REPO_DIR"
echo "Package: $DEB_FILE"
echo ""

# Create directory structure
echo "Creating directory structure..."
mkdir -p "$REPO_DIR/pool/main"
mkdir -p "$REPO_DIR/dists/stable/main/binary-amd64"
mkdir -p "$REPO_DIR/dists/stable/main/binary-arm64"
mkdir -p "$REPO_DIR/dists/stable/main/binary-all"

# Copy .deb file
echo "Copying package file..."
cp "$DEB_FILE" "$REPO_DIR/pool/main/"

# Generate Packages files
echo "Generating Packages files..."
cd "$REPO_DIR"

# For all architectures (since our package is 'all')
for arch in binary-amd64 binary-arm64 binary-all; do
    dpkg-scanpackages pool/main /dev/null | gzip -9c > "dists/stable/main/$arch/Packages.gz"
    dpkg-scanpackages pool/main /dev/null > "dists/stable/main/$arch/Packages"
done

# Generate Release file
echo "Generating Release file..."
cd dists/stable
cat > Release <<EOF
Origin: hcloud-ssh-ctl
Label: hcloud-ssh-ctl
Suite: stable
Codename: stable
Architectures: amd64 arm64 all
Components: main
Description: Hetzner Cloud SSH Control Repository
Date: $(date -R)
EOF

# Add checksums
echo "MD5Sum:" >> Release
find main -type f -exec md5sum {} \; | sed 's|main/| |' | awk '{print $1, $3, $2}' >> Release

echo "SHA1:" >> Release
find main -type f -exec sha1sum {} \; | sed 's|main/| |' | awk '{print $1, $3, $2}' >> Release

echo "SHA256:" >> Release
find main -type f -exec sha256sum {} \; | sed 's|main/| |' | awk '{print $1, $3, $2}' >> Release

cd ../../

echo ""
echo "Repository created successfully!"
echo ""
echo "Repository structure:"
find "$REPO_DIR" -type f

echo ""
echo "Next steps:"
echo ""
echo "1. Host this directory on a web server (nginx, apache, GitHub Pages, etc.)"
echo ""
echo "2. Users can add your repository with:"
echo "   echo \"deb [trusted=yes] http://your-server.com/path stable main\" | sudo tee /etc/apt/sources.list.d/hcloud-ssh-ctl.list"
echo "   sudo apt-get update"
echo "   sudo apt-get install hcloud-ssh-ctl"
echo ""
echo "3. (Optional) Sign the Release file with GPG:"
echo "   cd $REPO_DIR/dists/stable"
echo "   gpg --armor --detach-sign -o Release.gpg Release"
echo "   gpg --clearsign -o InRelease Release"
echo ""
echo "4. If you sign the repository, users should add your GPG key:"
echo "   curl -s http://your-server.com/path/key.gpg | sudo apt-key add -"
echo ""
echo "For GitHub Pages hosting:"
echo "   - Push the $REPO_DIR contents to gh-pages branch"
echo "   - Enable GitHub Pages in repository settings"
echo "   - Use: deb [trusted=yes] https://username.github.io/repo-name stable main"
