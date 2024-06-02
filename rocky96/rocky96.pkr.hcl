# Main Packer file for Rocky 9.6 installation in VirtualBox using Boot ISO
#
# AUTHOR: FT
# DATE: 04/07/25
# VERSION: 0.3
#
# For debugging export these VARS
# export PACKER_LOG_PATH="packerlog.txt"
# export PACKER_LOG=1
#
# Envoke the build with timestamps. tail -f the packerlog.txt
# packer build -force -timestamp-ui rocky96.pkr.hcl

packer {
  required_plugins {
    vagrant = {
      version = "~> 1"
      source = "github.com/hashicorp/vagrant"
    }
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

# VARIABLES BLOCK

variable "iso_checksum" {
  type = string
  default = "sha256:0fad8d8b19a94a0222ea37152cdf5601229fe0178b651dc476e1cba41d2e6067"
}

variable "disk_size" {
  type = string
  default = "40960"
}

variable "urls" {
  type = list(string)
  default = [
    "iso/Rocky-9.6-x86_64-boot.iso",
    "https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.6-x86_64-boot.iso"
    ]
}

variable "iso_path" {
  type = string
  default = "iso/Rocky-9.6-x86_64-boot.iso"
}

# SOURCE BLOCK

source "virtualbox-iso" "rocky" {
  boot_command     = ["<up><wait><tab> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks-rocky96.cfg<enter><wait>"]
  boot_wait        = "5s"
  disk_size        = var.disk_size
  guest_os_type    = "RedHat_64"
  headless         = "true"
  http_directory   = "http"
  iso_checksum     = var.iso_checksum
  iso_urls         = var.urls
  iso_target_path  = var.iso_path
  shutdown_command = "echo 'vagrant' | sudo -S /sbin/halt -h -p"
  ssh_password     = "vagrant"
  ssh_timeout      = "50000s"
  ssh_username     = "vagrant"
  vboxmanage       = [
    ["modifyvm", "{{ .Name }}", "--memory", "2048"],
    ["modifyvm", "{{ .Name }}", "--cpus", "2"],
    ["modifyvm", "{{ .Name }}", "--vram", "16"],
    ["modifyvm", "{{ .Name }}", "--graphicscontroller", "vmsvga"],
    ["modifyvm", "{{ .Name }}", "--nat-localhostreachable1", "on"],
    ["modifyvm", "{{ .Name }}", "--nic2", "hostonly"],
    ["modifyvm", "{{ .Name }}", "--hostonlyadapter2", "vboxnet0"],
    ["modifyvm", "{{ .Name }}", "--clipboard", "bidirectional"]
  ]
  vm_name          = "Rocky96"
}

# BUILD BLOCK

build {
  sources = ["source.virtualbox-iso.rocky"]

  provisioner "shell" {
    inline          = ["sudo yum -y update"]
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    scripts         = ["scripts/vagrant.sh", "scripts/virtualbox.sh", "scripts/cleanup.sh"]
  }

  post-processor "vagrant" {
    compression_level = 9
    output            = "output/Rocky96.box"
  }

  provisioner "shell-local" {
    inline = [
      "echo 'Build completed successfully!'",
      "echo 'Adding Rocky96 box to Vagrant...'",
      "vagrant box remove Rocky96 --force || true",
      "vagrant box add Rocky96 output/Rocky96.box --force",
      "echo 'Box Rocky96 added successfully!'",
      "echo 'You can now use: vagrant init Rocky96 && vagrant up'"
    ]
  }
}

