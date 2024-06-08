# HashiCorp Packer Builds for Rocky Linux with Jenkins

This is a Packer project to build Rocky Linux 9.4 Vagrant box on VirtualBox using Jenkins.

## Assumptions

This project assumes no existing installed software (listed below) and everything will be created from scratch.
Jenkins should also be installed and configured on the same server to make things as simple as possible.
A Jenkins pipeline should aready be set up to run the Jenkinsfile.

## Requirements

The following software must be installed on your local machine before you can use Packer to build this Vagrant box:

  - [Packer](http://www.packer.io/)
  - [Vagrant](http://vagrantup.com/)
  - [VirtualBox](https://www.virtualbox.org/)
  - [Rocky Linux](https://rockylinux.org/)
  - [Jenkins](https://www.jenkins.io/)

Although not strictly necessary this is a recommended tree structure to get things going:

```bash
├── README.md
├── Jenkinsfile
└── rocky94
    ├── http
    │   └── ks-rocky94.cfg
    ├── rocky94.pkr.hcl
    └── scripts
        ├── cleanup.sh
        ├── vagrant.sh
        └── virtualbox.sh
```

## VirtualBox homelab setup

For the homelab setup on VirtualBox I recommend that a separate host-only network is setup so you can have a private network of VMs.
You will need to create a new host-only network - vboxnet0 - and create the IP range the network will use such as 172.16.0.0/24.
Also be sure to enable DHCP for the network to make things easy.

<div align="center">
  <img src="./assets/vbox.jpg" alt="Screenshot">
</div>

## Post Install Scripts

  - **ks-rocky94.cfg** - This is the kickstart file for the VM build
  - **rocky94.pkr.hcl** - This is the main packer file
  - **cleanup.sh** - Cleanup script after the VM has been created
  - **vagrant.sh** - Setup the vagrant user
  - **virtualbox.sh** - Mount the VBoxGuestAdditions.iso

## Output

Once the packer build is complete the Vagrant box file will be saved to the **/vagrant_boxes** directory.

## Usage

Clone the repo and checkout the jenkins branch:

    $ git clone https://github.com/ftao1/packer_builds.git
    $ cd packer_builds
    $ git checkout jenkins

In the Jenkins webUI click **Build Now** button.

The Jenkinsfile will create these directories:

   - **/vagrant_boxes**
   - **/ISO**

After the pipeline completes, the vagrant box is saved in **/vagrant_boxes** and **vagrant box add** is automatically run to add the vagrant box in the environment.
ISO's that are downloaded are saved in /ISO and cached.

## License

MIT

## Author

These configurations are maintained by F.Tao.
