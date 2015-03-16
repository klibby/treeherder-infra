#!/usr/bin/env bash

#echo "Installing linux-headers..."
#apt-get -y install linux-headers-$(uname -r) >/dev/null

echo "Installing dkms..."
apt-get -y install dkms >/dev/null

echo "Setting sshd UseDNS to no..."
echo "UseDNS no" >> /etc/ssh/sshd_config

#date > /etc/vagrant_box_build_time
#
#mkdir /home/ubuntu/.ssh
#wget --no-check-certificate \
#        'https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub' \
#            -O /home/ubuntu/.ssh/authorized_keys
#chown -R ubuntu /home/ubuntu/.ssh
#chmod -R go-rwsx /home/ubuntu/.ssh

echo "Cleaning up VBoxGuestAdditions..."
rm -f VBoxGuestAdditions.iso

#echo "cleaning up dhcp leases"
#rm /var/lib/dhcp/*
#
#echo "cleaning up udev rules"
#rm /etc/udev/rules.d/70-persistent-net.rules
#mkdir /etc/udev/rules.d/70-persistent-net.rules
#rm -rf /dev/.udev/
#rm /lib/udev/rules.d/75-persistent-net-generator.rules
