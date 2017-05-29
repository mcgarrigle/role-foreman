
function uppercase {
  echo $1 | awk '{ print toupper($0) }'
}

function if-enable {
  sed -i 's/ONBOOT=no/ONBOOT=yes/' "/etc/sysconfig/network-scripts/ifcfg-${1}"
}

function if-configure {
cat <<EOF > "/etc/sysconfig/network-scripts/ifcfg-${1}"
DEVICE=${1}
BOOTPROTO=static
IPADDR="${2}"
NETMASK="${3}"
ONBOOT=yes
EOF
}

export PASSWORD="letmein"
export DOMAIN="foo.local"
export REALM=$(uppercase $DOMAIN)
export CDN_SERVER="cdn.${DOMAIN}"
export FOR_SERVER="foreman.${DOMAIN}"
export IPA_SERVER="ipa.${DOMAIN}"
export CDN_URL="http://${CDN_SERVER}"
export FOR_URL="http://${FOR_SERVER}"
export CDN_ADDRESS="10.0.30.10"
export IPA_ADDRESS="10.0.30.11"
export FOR_ADDRESS="10.0.30.12"
export IPA1="${IPA_ADDRESS}"
export DNS0="$(grep nameserver /etc/resolv.conf | sed 's/^nameserver //')"
export DNS1="${IPA_ADDRESS}"
export SUBNET="local"
export NETBASE="10.0.30.0"
export NETWORK="${NETBASE}/24"
export NETMASK="255.255.255.0"
export REVERSE="30.0.10.in-addr.arpa"
export IPRANGE="10.0.30.200 10.0.30.250"

export ETH0=$(ip link |awk '/^2:/ { sub(/:/,"",$2); print $2 }')
export ETH1=$(ip link |awk '/^3:/ { sub(/:/,"",$2); print $2 }')

