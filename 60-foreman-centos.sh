

mkdir -p /media/dvd
mkdir -p /var/www/html/cdn

mount /dev/sr0 /media/dvd
cp -rv /media/dvd /var/www/html/cdn/centos

cp http-15-cdn.conf /etc/httpd/conf.d

cp /var/www/html/cdn/centos/isolinux/vmlinuz    /var/lib/tftpboot/boot/CentOS-7.2.1511-x86_64-vmlinuz 
cp /var/www/html/cdn/centos/isolinux/initrd.img /var/lib/tftpboot/boot/CentOS-7.2.1511-x86_64-initrd.img 

restorecon -r /var/lib/tftpboot
restorecon -r /var/www/html

