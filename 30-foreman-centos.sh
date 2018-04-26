#!/bin/bash

# http://foreman.foo.local:81/centos/$version/os/$arch

# Packages/centos-release-7-4.1708.el7.centos.x86_64.rpm

wwwroot="/var/www/html/cdn/centos/7/os"

mkdir -p /media/dvd
mkdir -p "${wwwroot}"

mount -o loop "$1" /media/dvd

release=$(./release /media/dvd/Packages/centos-release*)

echo  "CentOS ${release}"

cp -rv /media/dvd/ "${wwwroot}/x86_64"

cp http-15-cdn.conf /etc/httpd/conf.d

cp ${wwwroot}/x86_64/isolinux/vmlinuz    /var/lib/tftpboot/boot/CentOS-${release}-x86_64-vmlinuz 
cp ${wwwroot}/x86_64/isolinux/initrd.img /var/lib/tftpboot/boot/CentOS-${release}-x86_64-initrd.img 

restorecon -r /var/lib/tftpboot
restorecon -r /var/www/html

systemctl restart httpd
