# Install EPEL Repo
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Install puppet
yum -y install puppet

# cannot remove dev tools must be present for dkms
yum -y clean all
