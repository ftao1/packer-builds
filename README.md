# HashiCorp Packer Builds

This is a Packer project to build Rocky Linux 9.4 Vagrant box on VirtualBox.


## Requirements

The following software must be installed/present on your local machine before you can use Packer to build any of these Vagrant boxes:

  - [Packer](http://www.packer.io/)
  - [Vagrant](http://vagrantup.com/)
  - [VirtualBox](https://www.virtualbox.org/)
  - [Rocky Linux](https://rockylinux.org/)

## Usage

Make sure all the required software (listed above) is installed, then cd into one of the box directories and run:

    $ packer build -force -timestamp-ui rocky94.pkr.hcl


## License

MIT

## Author

These configurations are maintained by Fai Tao.
