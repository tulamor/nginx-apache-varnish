########## PHP SETUP ########## 
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php73
yum install -y php php-fpm
sed -i 's/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php.ini
systemctl enable --now php-fpm

########## APPLICATION ########## 
echo '<?php phpinfo();' > /var/www/html/index.php