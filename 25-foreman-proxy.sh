#!/bin/bash

function yaml {
  TEXT=$(cat $1 | sed 's/^--- //')
  echo $TEXT
}

NAMESERVERS="10.0.30.11"
FQDN=$(facter fqdn)
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

CONSUMER_KEY_FILE='/opt/puppetlabs/puppet/cache/foreman_cache_data/oauth_consumer_key'
CONSUMER_SECRET_FILE='/opt/puppetlabs/puppet/cache/foreman_cache_data/oauth_consumer_secret'

CONSUMER_KEY=$(yaml $CONSUMER_KEY_FILE)
CONSUMER_SECRET=$(yaml $CONSUMER_SECRET_FILE)

unset http_proxy https_proxy

FOREMAN_URL="https://${FQDN}"

foreman-installer \
  --enable-foreman-proxy \
  --foreman-proxy-tftp=true \
  --foreman-proxy-tftp-servername="${ADDRESS0}" \
  --foreman-proxy-dhcp=true \
  --foreman-proxy-dhcp-interface="${ETH0}" \
  --foreman-proxy-dhcp-gateway= \
  --foreman-proxy-dhcp-nameservers="${NAMESERVERS}" \
  --foreman-proxy-dns=false \
  --foreman-proxy-foreman-base-url="${FOREMAN_URL}" \
  --foreman-proxy-oauth-consumer-key="${CONSUMER_KEY}" \
  --foreman-proxy-oauth-consumer-secret="${CONSUMER_SECRET}"

