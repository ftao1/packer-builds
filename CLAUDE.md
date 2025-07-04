# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a HashiCorp Packer project for building Rocky Linux 9.6 Vagrant boxes on VirtualBox using Boot ISO. The project creates VM images with pre-configured systems ready for development or testing environments.

## Common Commands

### Building and Adding the Vagrant Box (Recommended)
```bash
cd rocky96
# Linux/macOS/WSL:
./build-and-add.sh

# Windows:
build-and-add.bat
```

### Manual Building Process
```bash
cd rocky96
packer build -force -timestamp-ui rocky96.pkr.hcl
# Box is automatically added to Vagrant via shell-local provisioner
```

### Manual Box Management (if needed)
```bash
cd output
vagrant box add Rocky96 Rocky96.box --force
vagrant box remove Rocky96 --force
vagrant box list | grep Rocky96
```

### Debugging Builds
Enable Packer logging:
```bash
export PACKER_LOG_PATH="packerlog.txt"
export PACKER_LOG=1
packer build -force -timestamp-ui rocky96.pkr.hcl
```

## Architecture

### Directory Structure
- `rocky96/` - Main build directory for Rocky Linux 9.6
  - `rocky96.pkr.hcl` - Main Packer configuration file
  - `http/ks-rocky96.cfg` - Kickstart file for automated installation
  - `scripts/` - Post-installation scripts
  - `iso/` - Location for ISO files (local cache)
  - `output/` - Generated Vagrant box files

### Key Components

**Packer Configuration** (`rocky96.pkr.hcl`):
- Uses `virtualbox-iso` builder with Boot ISO
- Configures VM with 2GB RAM, 2 CPUs, 40GB disk
- Sets up host-only networking on vboxnet0
- Runs automated network installation via kickstart

**Kickstart Configuration** (`http/ks-rocky96.cfg`):
- UK keyboard/locale settings
- Creates vagrant user with sudo privileges
- Installs development tools and VirtualBox prerequisites
- Configures EPEL repository

**Post-Installation Scripts**:
- `vagrant.sh` - Sets up Vagrant SSH keys and user environment
- `virtualbox.sh` - Installs VirtualBox Guest Additions
- `cleanup.sh` - Removes temporary files and zeros free space

### Build Process
1. Downloads/uses local Rocky Linux 9.6 Boot ISO (~1.17GB)
2. Boots VM with kickstart for automated network installation
3. Downloads packages during installation via internet connection
4. Runs provisioning scripts for Vagrant and VirtualBox setup
5. Packages as compressed Vagrant box file
6. Automatically adds box to local Vagrant installation (via shell-local provisioner)

## Prerequisites

Required software on build machine:
- Packer
- VirtualBox
- Vagrant
- VirtualBox host-only network (vboxnet0) with DHCP enabled

## Important Notes

- Boot ISO (~1.17GB) downloads automatically or can be pre-cached in `iso/` directory
- Requires internet connection during build for package downloads
- The build is configured for UK locale/keyboard - modify kickstart for other regions
- VirtualBox Guest Additions are automatically installed for folder sharing
- Built boxes include development tools and are ready for immediate use
- 90% smaller ISO download compared to DVD-based builds