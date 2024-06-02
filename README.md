# HashiCorp Packer Builds for Rocky Linux

This is a Packer project to build Rocky Linux 9.4 Vagrant box on VirtualBox.


## Requirements

The following software must be installed/present on your local machine before you can use Packer to build any of these Vagrant boxes:

  - [Packer](http://www.packer.io/)
  - [Vagrant](http://vagrantup.com/)
  - [VirtualBox](https://www.virtualbox.org/)
  - [Rocky Linux](https://rockylinux.org/)

Although not strictly necessary this is a recommended tree structure to get things going:

```bash
.
├── README.md
└── rocky94
    ├── http
    │   └── ks-rocky94.cfg
    ├── iso
    │   └── Rocky-9.4-x86_64-dvd.iso
    ├── output
    │   └── Rocky94FT.box
    ├── rocky94.pkr.hcl
    └── scripts
        ├── cleanup.sh
        ├── vagrant.sh
        └── virtualbox.sh
```
Unless you have a very fast Internet link I would suggest the Rocky Linux ISO is pre-downloaded prior to running.

## Usage

Make sure all the required software (listed above) is installed, then cd into one of the box directories and run:

    $ packer build -force -timestamp-ui rocky94.pkr.hcl


## License

MIT

## Author

These configurations are maintained by Fai Tao.
