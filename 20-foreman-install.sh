#!/bin/bash

# check:
# ------------------------------------------------
# /etc/hosts    - add foreman.foo.local
# /etc/yum.conf - add proxy = "..."

# source 00-environment.sh

function uppercase {
  echo $1 | awk '{ print toupper($0) }'
}

alias facter='/opt/puppetlabs/bin/facter'

yum install -y epel-release
yum install -y facter

DOMAIN=$(facter domain)
REALM=$(uppercase ${DOMAIN})

ETHS=$(facter interfaces)
ETH0=$(echo $ETHS | cut -d, -f 1)
ETH1=$(echo $ETHS | cut -d, -f 2)
ADDRESS0=$(facter ipaddress_${ETH0})
ADDRESS1=$(facter ipaddress_${ETH1})

echo $HOSTNAME $DOMAIN $REALM
echo $ETH0 $ADDRESS0
echo $ETH1 $ADDRESS1

# --------------------------------------------

yum install -y "http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm"
yum install -y "https://yum.theforeman.org/releases/1.14/el7/x86_64/foreman-release.rpm"
yum install -y "https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm"

yum install -y centos-release-scl centos-release-scl-rh foreman-release-scl
yum install -y puppetserver puppet-agent
yum install -y foreman-installer
yum install -y vim

echo "DHCP/PXE interface = ${ETH0}"

# --------------------------------------------
echo "Setting up Firewall Rules..."

yum install -y firewalld 

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

systemctl stop firewalld
systemctl disable firewalld

# --------------------------------------------
echo "Installing Postgresql..."

yum install -y postgresql96-server
/usr/pgsql-9.6/bin/postgresql96-setup initdb

systemctl enable postgresql-9.6
systemctl start postgresql-9.6

sudo -u postgres psql -c "CREATE ROLE foreman WITH LOGIN NOCREATEDB NOSUPERUSER PASSWORD 'foreman';"
sudo -u postgres psql -c "CREATE DATABASE foreman ENCODING 'UTF8' OWNER 'foreman';"

sudo -u postgres psql -c "CREATE ROLE puppetdb WITH LOGIN NOCREATEDB NOSUPERUSER PASSWORD 'puppetdb';"
sudo -u postgres psql -c "CREATE DATABASE puppetdb ENCODING 'UTF8' OWNER 'puppetdb';"

cat <<EOF > /var/lib/pgsql/9.6/data/pg_hba.conf
local all  postgres ident
local all  all      ident
host  all  postgres 127.0.0.1/32 md5
host  all  postgres 0.0.0.0/0    reject
host  all  all      127.0.0.1/32 md5
host  all  all      ::1/128      md5
EOF

systemctl restart postgresql-9.6

# --------------------------------------------
echo "Running Foreman Installer..."

unset http_proxy https_proxy

foreman-installer \
  --foreman-admin-password="admin" \
  --foreman-db-adapter="postgresql" \
  --foreman-db-manage=false \
  --foreman-db-database="foreman" \
  --foreman-db-username="foreman" \
  --foreman-db-password="foreman" \
  --foreman-db-host="localhost" \
  --foreman-db-port="5432"

# --------------------------------------------
echo "Installing PuppetDB..."

puppet resource package puppetdb ensure=latest

cat <<EOF >> /etc/puppetlabs/puppetdb/conf.d/database.ini
subname = //127.0.0.1:5432/puppetdb
username = puppetdb
password = puppetdb
EOF

puppet resource service puppetdb ensure=running enable=true

foreman-installer \
  --enable-foreman-plugin-puppetdb \
  --puppet-server-puppetdb-host="${HOSTNAME}" \
  --puppet-server-reports="foreman,puppetdb" \
  --puppet-server-storeconfigs-backend="puppetdb" \
  --foreman-plugin-puppetdb-address="https://${HOSTNAME}:8081/pdb/cmd/v1" \
  --foreman-plugin-puppetdb-dashboard-address="http://localhost:8080/pdb/dashboard"

setsebool -P passenger_can_connect_all on

# --------------------------------------------

mkdir -p ~/.hammer/cli.modules.d
'cp' -f foreman.yml ~/.hammer/cli.modules.d/foreman.yml 

