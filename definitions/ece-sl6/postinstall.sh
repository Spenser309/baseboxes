date > /etc/vagrant_box_build_time
#!/bin/bash

# Install EPEL Repo
yum -y install epel-release

# Install build needs
yum -y install gcc make gcc-c++ kernel-devel-`uname -r` zlib-devel openssl-devel readline-devel sqlite-devel perl wget dkms

# Installing the virtualbox guest additions
VBOX_VERSION=$(cat /root/.vbox_version)
cd /tmp
wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt

# Networking fixups
sed -i /HWADDR/d /etc/sysconfig/network-scripts/ifcfg-eth0
rm /etc/udev/rules.d/70-persistent-net.rules

# Install puppet
yum -y install puppet

# Clean up
rm -rf VBoxGuestAdditions_$VBOX_VERSION.iso
# cannot remove dev tools must be present for dkms
yum -y clean all

dd if=/dev/zero of=/EMTPY bs=1M
rm -f /EMPTY

