#!/bin/bash

source 00-environment.sh

yum install -y centos-release-scl centos-release-scl-rh foreman-release-scl
yum install -y https://yum.theforeman.org/releases/1.14/el7/x86_64/foreman-release.rpm
yum install -y epel-release
yum install -y firewalld
yum install -y foreman-installer puppet

echo "DHCP/PXE interface = ${ETH0}"

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

echo "Running Foreman Installer..."

foreman-installer \
  --foreman-foreman-url="http://${FOR_SERVER}" \
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

'cp' -f foreman.yml .hammer/cli.modules.d/foreman.yml 

