#!/bin/bash

yum install -y bind bind-utils httpd tinyproxy

echo "Setting up Firewall Rules..."

systemctl start firewalld
firewall-cmd --permanent --add-port=53/udp
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --reload
systemctl enable firewalld

sed -i '/listen-on\sport/d' /etc/named.conf
sed -i 's/allow-query .*$/allow-query { any; };/' /etc/named.conf

systemctl start named
systemctl enable named

systemctl enable httpd
systemctl start httpd

sed -i 's/^Port .*/Port 8080/' /etc/tinyproxy/tinyproxy.conf
sed -i 's/^Allow /# Allow /'   /etc/tinyproxy/tinyproxy.conf

systemctl enable tinyproxy
systemctl start tinyproxy
