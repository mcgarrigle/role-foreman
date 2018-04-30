#!/bin/bash

foreman-prepare-realm admin realm-proxy

cp freeipa.keytab /etc/foreman-proxy
chown foreman-proxy /etc/foreman-proxy/freeipa.keytab
chmod 600 /etc/foreman-proxy/freeipa.keytab

cp /etc/ipa/ca.crt /etc/pki/ca-trust/source/anchors/ipa.crt
update-ca-trust enable
update-ca-trust

