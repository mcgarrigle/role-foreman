
#rm -rf /var/www/html/cdn/centos

# http://mirror.centos.org/centos/$version/os/$arch

wwwroot="/var/www/html/cdn/centos/7/os"

mkdir -p /media/dvd
mkdir -p "${wwwroot}"

mount -o loop "$1" /media/dvd
#cp -rv /media/dvd/ "${wwwroot}/x86_64"

cp http-15-cdn.conf /etc/httpd/conf.d

cp ${wwwroot}/x86_64/isolinux/vmlinuz    /var/lib/tftpboot/boot/CentOS-7.2.1511-x86_64-vmlinuz 
cp ${wwwroot}/x86_64/isolinux/initrd.img /var/lib/tftpboot/boot/CentOS-7.2.1511-x86_64-initrd.img 

restorecon -r /var/lib/tftpboot
restorecon -r /var/www/html

