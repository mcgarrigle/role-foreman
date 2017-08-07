#!/bin/bash

# check:
# ------------------------------------------------
# /etc/hosts    - add foreman.foo.local
# /etc/yum.conf - add proxy = "..."

source 00-environment.sh

yum install -y firewalld vim

yum install -y http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum install -y https://yum.theforeman.org/releases/1.14/el7/x86_64/foreman-release.rpm
yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm

yum install -y centos-release-scl centos-release-scl-rh foreman-release-scl
yum install -y puppetserver puppetdb puppet-agent
yum install -y foreman-installer

echo "DHCP/PXE interface = ${ETH0}"

# --------------------------------------------
echo "Setting up Firewall Rules..."

#systemctl start firewalld
#firewall-cmd --permanent --add-service=http
#firewall-cmd --permanent --add-service=https
#firewall-cmd --permanent --add-port=81/tcp
#firewall-cmd --permanent --add-port=69/tcp
#firewall-cmd --permanent --add-port=67-69/udp
#firewall-cmd --permanent --add-port=53/tcp
#firewall-cmd --permanent --add-port=53/udp
#firewall-cmd --permanent --add-port=8443/tcp
#firewall-cmd --permanent --add-port=8140/tcp
#firewall-cmd --reload
#systemctl enable firewalld

# --------------------------------------------
echo "Installing Postgresql..."

yum install -y postgresql96-server
/usr/pgsql-9.6/bin/postgresql96-setup initdb

systemctl enable postgresql-9.6
systemctl start postgresql-9.6

# CREATE ROLE foo WITH NOCREATEDB NOSUPERUSER PASSWORD 'foo';

exit

# --------------------------------------------
echo "Running Foreman Installer..."

unset http_proxy https_proxy

foreman-installer \
  --foreman-foreman-url="${FOR_URL}" \
  --foreman-admin-password=admin \
  --foreman-configure-epel-repo=false \
  --foreman-configure-scl-repo=false \
  --enable-foreman-plugin-dhcp-browser \
  --foreman-proxy-tftp=true \
  --foreman-proxy-dhcp=true \
  --foreman-proxy-dhcp-interface="${ETH0}" \
  --foreman-proxy-dhcp-range="${IPRANGE}" \
  --foreman-proxy-dhcp-nameservers="${FOR_ADDRESS}" \
  --foreman-proxy-dhcp-pxeserver="${FOR_ADDRESS}" \
  --foreman-ipa-authentication=false

mkdir -p ~/.hammer/cli.modules.d
'cp' -f foreman.yml ~/.hammer/cli.modules.d/foreman.yml 

