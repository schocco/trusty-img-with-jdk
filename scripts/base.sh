#!/bin/bash

#perl -p -i -e 's#http://us.archive.ubuntu.com/ubuntu#http://mirror.rackspace.com/ubuntu#gi' /etc/apt/sources.list


# set a proxy server
#echo 'Acquire::http::Proxy::download.virtualbox.org DIRECT;
#Acquire::http { Proxy "http://192.168.178.63:3142"; };
#Acquire::https { Proxy "https://"; };' > /etc/apt/apt.conf.d/20proxy

# Update the box
apt-get -y update >/dev/null
apt-get -y install facter python python-pip zlib1g-dev libssl-dev libreadline-gplv2-dev curl unzip >/dev/null
apt-get -y install build-essential linux-headers-`uname -r` dkms
apt-get -y install software-properties-common
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7BB9C367
apt-add-repository ppa:ansible/ansible
apt-get update
apt-get -y install ansible

# Tweak sshd to prevent DNS resolution (speed up logins)
echo 'UseDNS no' >> /etc/ssh/sshd_config

# Remove 5s grub timeout to speed up booting
cat <<EOF > /etc/default/grub
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.

GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX="debian-installer=en_US"
EOF

update-grub
