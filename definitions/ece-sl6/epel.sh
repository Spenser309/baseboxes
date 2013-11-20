#!/bin/bash

# Install EPEL Repo
yum -y install epel-release

rpm --import /etc/pki/rpm-gpg/*GPG*
yum update --enablerepo=epel-testing puppet-2.7.23-1.el6
