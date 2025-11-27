#!/bin/bash
#
# Test installation of hcloud-ssh-ctl
#

set -e

echo "==================================="
echo "hcloud-ssh-ctl Installation Test"
echo "==================================="
echo ""

# Check if script exists
echo "1. Checking if binary exists..."
if command -v hcloud-ssh-ctl &> /dev/null; then
    echo "   ✓ hcloud-ssh-ctl found at: $(which hcloud-ssh-ctl)"
else
    echo "   ✗ hcloud-ssh-ctl not found"
    exit 1
fi

# Check dependencies
echo ""
echo "2. Checking dependencies..."
deps=(dialog jq curl parallel-ssh)
missing=()

for dep in "${deps[@]}"; do
    if command -v "$dep" &> /dev/null; then
        echo "   ✓ $dep found"
    else
        echo "   ✗ $dep missing"
        missing+=("$dep")
    fi
done

if [ ${#missing[@]} -ne 0 ]; then
    echo ""
    echo "Missing dependencies: ${missing[*]}"
    echo "Install with: sudo apt-get install ${missing[*]}"
    exit 1
fi

# Check man page
echo ""
echo "3. Checking man page..."
if man -w hcloud-ssh-ctl &> /dev/null; then
    echo "   ✓ Man page found at: $(man -w hcloud-ssh-ctl)"
else
    echo "   ⚠ Man page not found (optional)"
fi

# Check configuration directory
echo ""
echo "4. Checking configuration setup..."
CONFIG_DIR="${HOME}/.config/hcloud-ssh-ctl"
if [ -d "$CONFIG_DIR" ]; then
    echo "   ✓ Config directory exists: $CONFIG_DIR"
    echo "   ✓ Permissions: $(stat -c %a "$CONFIG_DIR" 2>/dev/null || stat -f %Lp "$CONFIG_DIR" 2>/dev/null)"
else
    echo "   ℹ Config directory will be created on first run"
fi

# Version check
echo ""
echo "5. Checking version..."
version=$(grep '^VERSION=' "$(which hcloud-ssh-ctl)" | cut -d'"' -f2)
if [ -n "$version" ]; then
    echo "   ✓ Version: $version"
else
    echo "   ⚠ Could not determine version"
fi

echo ""
echo "==================================="
echo "✓ All checks passed!"
echo "==================================="
echo ""
echo "To start using hcloud-ssh-ctl, run:"
echo "  hcloud-ssh-ctl"
echo ""
echo "For help, see:"
echo "  man hcloud-ssh-ctl"
echo "  hcloud-ssh-ctl (select option 4 - About)"
echo ""
