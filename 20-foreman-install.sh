#!/bin/bash

source 00-environment.sh

echo "DHCP/PXE interface = ${ETH0}"

# --------------------------------------------------------------------------
# enable firewall

yum install -y firewalld vim

echo "Setting up Firewall Rules..."

systemctl start firewalld
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --permanent --add-port=81/tcp
firewall-cmd --permanent --add-port=69/tcp
firewall-cmd --permanent --add-port=67-69/udp
firewall-cmd --permanent --add-port=53/tcp
firewall-cmd --permanent --add-port=53/udp
firewall-cmd --permanent --add-port=8443/tcp
firewall-cmd --permanent --add-port=8140/tcp
firewall-cmd --reload
systemctl enable firewalld

# yum install -y centos-release-scl centos-release-scl-rh
# yum install -y puppetserver puppetdb puppet-agent

# --------------------------------------------------------------------------
# foreman server

echo "Running Foreman Installer..."

yum install -y foreman-installer

# foreman-installer \
# --foreman-foreman-url="http://${FOR_SERVER}" \
# --foreman-admin-password=admin \
# --foreman-configure-epel-repo=false \
# --foreman-configure-scl-repo=false \
# --enable-foreman-plugin-dhcp-browser \
# --foreman-proxy-tftp=true \
# --foreman-proxy-dhcp=true \
# --foreman-proxy-dhcp-interface="${ETH0}" \
# --foreman-proxy-dhcp-range="${IPRANGE}" \
# --foreman-proxy-dhcp-nameservers="${FOR_ADDRESS}" \
# --foreman-proxy-dhcp-pxeserver="${FOR_ADDRESS}" \
# --foreman-ipa-authentication=false

foreman-installer \
--foreman-admin-password=admin \
--foreman-db-adapter=postgresql \
--foreman-db-database=foreman \
--foreman-db-host=localhost \
--foreman-db-manage=false \
--foreman-db-username=foreman \
--foreman-db-password=letmein \
--foreman-db-port=5432 \
--foreman-configure-epel-repo=false \
--foreman-configure-scl-repo=false

/bin/cp -f foreman.yml .hammer/cli.modules.d/foreman.yml 

