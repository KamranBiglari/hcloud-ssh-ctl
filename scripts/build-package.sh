#!/bin/bash
#
# Build Debian package for hcloud-ssh-ctl
#

set -e

echo "Building hcloud-ssh-ctl Debian package..."
echo ""

# Check if we're in the project root
if [ ! -f "src/hcloud-ssh-ctl" ]; then
    echo "Error: Must be run from project root directory"
    exit 1
fi

# Check for required tools
if ! command -v dpkg-buildpackage &> /dev/null; then
    echo "Error: dpkg-buildpackage not found"
    echo "Install it with: sudo apt-get install devscripts debhelper"
    exit 1
fi

# Clean previous builds
echo "Cleaning previous builds..."
make clean

# Build the package
echo "Building package..."
dpkg-buildpackage -us -uc -b

echo ""
echo "Build complete!"
echo ""
echo "Package files:"
ls -lh ../*.deb 2>/dev/null || echo "No .deb files found"

echo ""
echo "To install locally:"
echo "  sudo dpkg -i ../hcloud-ssh-ctl_*.deb"
echo "  sudo apt-get install -f  # Install missing dependencies"
