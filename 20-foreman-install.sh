#!/bin/bash

unset http_proxy
unset https_proxy

source 00-environment.sh

yum install -y firewalld vim

echo "DHCP/PXE interface = ${ETH0}"

# --------------------------------------------------------------------------
# enable firewall

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

yum install -y epel-release
yum install -y http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum install -y https://yum.theforeman.org/releases/1.14/el7/x86_64/foreman-release.rpm
yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm

# --------------------------------------------------------------------------
# postgres server

yum install -y postgresql96-server

/usr/pgsql-9.6/bin/postgresql96-setup initdb
systemctl enable postgresql-9.6
systemctl start postgresql-9.6

sudo -u postgres psql -c "create user foreman password 'letmein' nocreatedb nocreaterole nosuperuser;"
sudo -u postgres psql -c "create database foreman owner foreman encoding 'UTF8';"
/bin/cp pg_hba.conf /var/lib/pgsql/9.6/data/pg_hba.conf

systemctl restart postgresql-9.6

yum install -y centos-release-scl centos-release-scl-rh
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

