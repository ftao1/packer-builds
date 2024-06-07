# Main Packer file for Rocky 9.4 installation in VirtualBox
#
# AUTHOR: FT
# DATE: 18/05/24
# VERSION: 0.2
#
# For debugging export these VARS
# export PACKER_LOG_PATH="packerlog.txt"
# export PACKER_LOG=1
#
# Envoke the build with timestamps. tail -f the packerlog.txt
# packer build -force -timestamp-ui rocky94.pkr.hcl

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
  default = "sha256:e20445907daefbfcdb05ba034e9fc4cf91e0e8dc164ebd7266ffb8fdd8ea99e7"
}

variable "disk_size" {
  type = string
  default = "40960"
}

variable "urls" {
  type = list(string)
  default = [
    "/ISO/Rocky-9.4-x86_64-dvd.iso",
    "https://mirrors.vinters.com/rocky/9.4/isos/x86_64/Rocky-9.4-x86_64-dvd.iso"
    ]
}

variable "iso_path" {
  type = string
  default = "/ISO/Rocky-9.4-x86_64-dvd.iso"
}

# SOURCE BLOCK

source "virtualbox-iso" "rocky" {
  boot_command     = ["<up><wait><tab> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks-rocky94.cfg<enter><wait>"]
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
  vm_name          = "Rocky94"
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
    output            = "/vagrant_boxes/Rocky94.box"
  }
}

