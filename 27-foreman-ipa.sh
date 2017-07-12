#!/bin/bash

source 00-environment.sh

yum install -y ipa-admintools

kinit admin
ipa service-add HTTP/${FOR_SERVER}

foreman-installer \
  --foreman-ipa-authentication=true

# add user to kick foreman
# echo thisisfoobar | ipa user-add foo --first foo --last bar --password

hammer user-group create \
  --name=foreman-admins \
  --admin=true

hammer user-group external create \
  --name=foreman-admins \
  --user-group=foreman-admins \
  --auth-source-id=3

ipa group-add foreman-admins --nonposix

# ----------------------------------------------------------------
# IPA realm integration

foreman-prepare-realm admin foreman-realm-proxy

cp freeipa.keytab /etc/foreman-proxy/freeipa.keytab
chown foreman-proxy:foreman-proxy /etc/foreman-proxy/freeipa.keytab
chmod 600 /etc/foreman-proxy/freeipa.keytab

foreman-installer \
--foreman-proxy-realm=true \
--foreman-proxy-realm-principal="foreman-realm-proxy@${REALM}" \
--foreman-proxy-freeipa-remove-dns=true

hammer realm create \
--name="${REALM}" \
--realm-proxy-id=1 \
--realm-type="FreeIPA"

