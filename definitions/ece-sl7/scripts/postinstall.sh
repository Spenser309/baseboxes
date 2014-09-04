# Install EPEL Repo
yum -y install epel-release

# Install puppet
yum -y install puppet

# cannot remove dev tools must be present for dkms
yum -y clean all
