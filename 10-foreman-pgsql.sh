#!/bin/bash

source 00-environment.sh

# --------------------------------------------------------------------------
# get all required repos

yum install -y epel-release
yum install -y http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum install -y https://yum.theforeman.org/releases/1.14/el7/x86_64/foreman-release.rpm
yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
yum install -y centos-release-scl centos-release-scl-rh

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

