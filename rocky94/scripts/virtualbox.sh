#!/bin/sh

# Mount the VBoxGuestAdditions.iso.

echo "Mounting the VBoxGuestAdditions.iso..."
sudo mount -o loop /home/vagrant/VBoxGuestAdditions.iso /mnt
if [ $? -ne 0 ]; then
  echo "Failed to mount VBoxGuestAdditions.iso"
  exit 1
fi

echo "Running VBoxLinuxAdditions.run..."
sudo /mnt/VBoxLinuxAdditions.run
if [ $? -ne 0 ]; then
  echo "VBoxLinuxAdditions.run script failed"
  sudo umount /mnt
  exit 1
fi

echo "Unmounting the ISO..."
sudo umount /mnt
if [ $? -ne 0 ]; then
  echo "Failed to unmount /mnt"
  exit 1
fi

echo "Cleaning up..."
sudo rm -f /home/vagrant/VBoxGuestAdditions.iso


