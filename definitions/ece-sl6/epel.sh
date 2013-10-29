#!/bin/bash

# Install EPEL Repo
yum -y install epel-release

rpm --import /etc/pki/rpm-gpg/*GPG*
