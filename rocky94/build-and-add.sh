#!/bin/bash
# build-and-add.sh - Cross-platform build script for Rocky94 Vagrant box
# Works on Linux, macOS, and Windows (via WSL/Git Bash)

set -e

echo "========================================"
echo "Rocky94 Vagrant Box Builder"
echo "========================================"

# Check if we're in the right directory
if [ ! -f "rocky94.pkr.hcl" ]; then
    echo "Error: rocky94.pkr.hcl not found. Please run this script from the rocky94 directory."
    exit 1
fi

# Check if required tools are available
command -v packer >/dev/null 2>&1 || { echo "Error: packer is not installed or not in PATH"; exit 1; }
command -v vagrant >/dev/null 2>&1 || { echo "Error: vagrant is not installed or not in PATH"; exit 1; }

echo "Starting Packer build..."
echo "This will take some time (typically 1-2 hours)..."
echo ""

# Run the build
packer build -force -timestamp-ui rocky94.pkr.hcl

echo ""
echo "========================================"
echo "Build completed successfully!"
echo "The Rocky94 box has been automatically added to Vagrant."
echo ""
echo "To use the box:"
echo "  mkdir my-rocky94-vm"
echo "  cd my-rocky94-vm"
echo "  vagrant init Rocky94"
echo "  vagrant up"
echo "========================================"