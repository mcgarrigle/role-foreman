#!/bin/bash

SERVER="$1"
ADDRESS="$2"

source 00-environment.sh

yum install -y firewalld vim httpd
yum install -y epel-release

# assumption: eth1 is up and configured via DHCP during kickstart

if-configure "${ETH0}" "${ADDRESS}" "${NETMASK}"

ifup ${ETH0}

hostnamectl set-hostname ${SERVER}

echo "${ADDRESS} ${SERVER}" >> /etc/hosts

# stop host connections stalling on DNS lookup

echo "UseDNS no" >> /etc/ssh/sshd_config


