#!/bin/bash

# Set the PATH environment variable to include the directory containing VBoxManage
export PATH=/usr/bin:$PATH

# Define variables
VBOX_NET_NAME=vboxnet0
VBOX_NET_IP=172.16.0.1
VBOX_NET_MASK=255.255.255.0
DHCP_SERVER=172.16.0.2
DHCP_IP_LOW=172.16.0.3
DHCP_IP_HIGH=172.16.0.254
DHCP_NET_MASK=255.255.255.0

# Get the vboxnet name
vboxnet=$(VBoxManage list hostonlyifs | grep -o "${VBOX_NET_NAME}")

# Create host-only interface if not exists
if [ -z "${vboxnet}" ]; then
    VBoxManage hostonlyif create
fi

# Configure host-only interface IP
VBoxManage hostonlyif ipconfig "${VBOX_NET_NAME}" --ip "${VBOX_NET_IP}" --netmask "${VBOX_NET_MASK}"

VBoxManage dhcpserver add --ifname "${VBOX_NET_NAME}" --ip "${DHCP_SERVER}" --netmask "${DHCP_NET_MASK}" --lowerip "${DHCP_IP_LOW}" --upperip "${DHCP_IP_HIGH}"
VBoxManage dhcpserver modify --ifname "${VBOX_NET_NAME}" --enable

VBoxManage natnetwork add --netname NatNetwork --network 10.0.2.0/24 --enable --dhcp on --ipv6=off




# Check for DHCP server
#dhcpserver=$(VBoxManage list dhcpservers | grep "${VBOX_NET_NAME}")

#VBoxManage dhcpserver modify --ifname "${VBOX_NET_NAME}" --ip "${DHCP_SERVER}" --netmask "${DHCP_NET_MASK}" --lowerip "${DHCP_IP_LOW}" --upperip "${DHCP_IP_HIGH}" --enable
#VBoxManage dhcpserver modify --netname vboxnet0 --ip 172.16.0.2 --netmask 255.255.255.0 --lowerip 172.16.0.3 --upperip 172.16.0.254 --enable

# Add or modify DHCP server configuration
#if [ -z "${dhcpserver}" ]; then
    # DHCP server does not exist, add it
#    VBoxManage dhcpserver add --ifname "${VBOX_NET_NAME}" --ip "${VBOX_NET_IP}" --netmask "${DHCP_NET_MASK}" --lowerip "${DHCP_IP_LOW}" --upperip "${DHCP_IP_HIGH}" --enable
#else
    # DHCP server exists, modify its configuration
#    VBoxManage dhcpserver modify --ifname "${VBOX_NET_NAME}" --ip "${VBOX_NET_IP}" --netmask "${DHCP_NET_MASK}" --lowerip "${DHCP_IP_LOW}" --upperip "${DHCP_IP_HIGH}" --enable
#fi

# Ensure DHCP server is enabled
#VBoxManage dhcpserver modify --ifname "${VBOX_NET_NAME}" --enable

