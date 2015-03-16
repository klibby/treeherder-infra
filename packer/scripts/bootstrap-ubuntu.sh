#!/usr/bin/env bash
#
# This bootstraps Puppet on Ubuntu 12.04 LTS.
# https://github.com/hashicorp/puppet-bootstrap/blob/188286a80a1286691c5fda8a719fcaa45e9d3d43/ubuntu.sh
#
set -e

# Load up the release information
. /etc/lsb-release

REPO_DEB_URL="http://apt.puppetlabs.com/puppetlabs-release-${DISTRIB_CODENAME}.deb"

#--------------------------------------------------------------------
# NO TUNABLES BELOW THIS POINT
#--------------------------------------------------------------------
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root." >&2
    exit 1
fi
if which puppet > /dev/null 2>&1 -a apt-cache policy | grep --quiet apt.puppetlabs.com; then
    echo "Puppet is already installed."
    exit 0
fi

# Do the initial apt-get update
echo "Initial apt-get update..."
apt-get update >/dev/null

# Install wget if we have to (some older Ubuntu versions)
echo "Installing wget..."
apt-get install -y wget >/dev/null

# Install the PuppetLabs repo
echo "Configuring PuppetLabs repo..."
repo_deb_path=$(mktemp)
wget --output-document="${repo_deb_path}" "${REPO_DEB_URL}" 2>/dev/null
dpkg -i "${repo_deb_path}" >/dev/null
apt-get update >/dev/null

# Install Puppet
echo "Installing Puppet..."
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install puppet >/dev/null
echo "Puppet installed!"

# ruby1.9.3 includes rubygems
echo "Installing ruby..."
#apt-get install -y rubygems >/dev/null
apt-get install -y ruby 1.9.3 >/dev/null
update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby1.9.1 400 \
    --slave   /usr/share/man/man1/ruby.1.gz ruby.1.gz /usr/share/man/man1/ruby1.9.1.1.gz \
    --slave   /usr/bin/ri ri /usr/bin/ri1.9.1 \
    --slave   /usr/bin/irb irb /usr/bin/irb1.9.1 \
    --slave   /usr/bin/rdoc rdoc /usr/bin/rdoc1.9.1

echo "Installing git..."
apt-get install -y git >/dev/null

echo "Installing make..."
apt-get install -y make >/dev/null

echo "Installing python-pip..."
apt-get install -y python-pip >/dev/null

echo "installing awscli..."
pip install awscli >/dev/null

echo "Updating pip..."
pip install -U pip >/dev/null

if [ "$(gem list -i '^facter$')" = "false" ]; then
    echo "installing the 'facter' gem"
    gem install --no-ri --no-rdoc facter >/dev/null
fi

if [ "$(gem list -i '^json$')" = "false" ]; then
    echo "installing the 'json' gem"
    gem install --no-ri --no-rdoc json >/dev/null
fi

if [ "$(gem list -i '^aws-sdk$')" = "false" ]; then
    echo "installing the 'aws-sdk' gem"
    gem install --no-ri --no-rdoc aws-sdk >/dev/null
fi

#if [ "$(gem list -i '^r10k$')" = "false" ]; then
#    echo "installing the 'r10k' gem"
#    gem install --no-ri --no-rdoc r10k >/dev/null
#fi

if [ "$(gem list -i '^librarian-puppet$')" = "false" ]; then
    echo "installing the 'librarian-puppet' gem"
    gem install --no-ri --no-rdoc librarian-puppet >/dev/null
fi

echo "Making /usr/local/lib/site_ruby/facter..."
mkdir -p /usr/local/lib/site_ruby/facter
chmod 755 /usr/local/lib/site_ruby/facter

echo "Enabling password-less sudo..."
sed -i -e 's/%sudo\sALL=(ALL:ALL) ALL/%sudo\tALL=NOPASSWD:ALL/g' /etc/sudoers

