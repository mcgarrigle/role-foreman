#!/bin/bash

source 00-environment.sh

puppet resource package puppetdb ensure=latest

sudo -u postgres psql -c "create user puppetdb password 'letmein' nocreatedb nocreaterole nosuperuser;"
sudo -u postgres psql -c "create database puppetdb owner puppetdb encoding 'UTF8';"

cat <<EOF > /etc/puppetlabs/puppetdb/conf.d/database.ini
[database]
subname = //127.0.0.1:5432/puppetdb
username = puppetdb
password = letmein
EOF

puppet resource service puppetdb ensure=running enable=true

setsebool -P passenger_can_connect_all on

foreman-installer \
  --enable-foreman-plugin-puppetdb \
  --puppet-server-puppetdb-host=${FOR_SERVER} \
  --puppet-server-reports=foreman,puppetdb \
  --puppet-server-storeconfigs-backend=puppetdb \
  --foreman-plugin-puppetdb-address=${FOR_URL}:8081/pdb/cmd/v1 \
  --foreman-plugin-puppetdb-dashboard-address=http://localhost:8080/pdb/dashboard
