#!/usr/bin/env bash
set -exu

HOSTNAME=%%HOSTNAME%% # terraform replace()
DOMAIN=ie.p16n.org
FQDN="$HOSTNAME.$DOMAIN"

# Update the hostname
sed -ie "s/$(hostname --fqdn)/$FQDN/" /etc/hosts
sed -ie "s/$(hostname)/$HOSTNAME/" /etc/hosts
echo "$HOSTNAME" > /etc/hostname
/etc/init.d/hostname.sh

PUPPET_AGENT_VERSION=5.2.0-1jessie

PUPPET_SERVER=puppet.za.p16n.org
PUPPET_ENVIRONMENT=ge-aws-dublin

# Add the Puppet repository
wget -q https://apt.puppetlabs.com/puppet5-release-jessie.deb
dpkg --install puppet5-release-jessie.deb
rm puppet5-release-jessie.deb
apt-get update

# Install puppet-agent and configure
apt-get install -y puppet-agent=$PUPPET_AGENT_VERSION
cat <<EOF >> /etc/puppetlabs/puppet/puppet.conf
[agent]
server = $PUPPET_SERVER
environment = $PUPPET_ENVIRONMENT
EOF

# Run the Puppet agent
PATH="/opt/puppetlabs/bin:$PATH"
puppet agent --enable
puppet agent --test --waitforcert
