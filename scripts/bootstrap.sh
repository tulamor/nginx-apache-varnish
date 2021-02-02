#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

########## APACHE SETUP ########## 
yum install -y policycoreutils-python
semanage port -a -t http_port_t -p tcp 82 # Only for TEST ENV, port > 1024 must be used
yum install -y httpd

sed -i 's/^EnableSendfile on/EnableSendfile off/' /etc/httpd/conf/httpd.conf
sed -i 's/^Listen 80/Listen 82/' /etc/httpd/conf/httpd.conf
sed -i 's/^#ServerName www.example.com:80/ServerName apache-server/' /etc/httpd/conf/httpd.conf

systemctl enable --now httpd

########## NGINX SETUP ##########
yum install -y epel-release yum-utils
### EnableSendfile off
sudo echo ./nginx-configuration > /etc/nginx/nginx.conf

CPU_NUM=$(cat /proc/cpuinfo  | grep "processor" | wc -l)
sed -i -e "s/worker_processes.*;/worker_processes $CPU_NUM;/" /etc/nginx/nginx.conf
nginx -t && systemctl enable --now nginx

########## VARNISH SETUP ########## 
yum install -y varnish
cat ./lb-configuration > /etc/varnish/default.vcl
sed -i 's/^VARNISH_LISTEN_PORT=6081/VARNISH_LISTEN_PORT=80/' /etc/varnish/varnish.params
systemctl enable --now varnish.service
systemctl enable --now varnishlog.service

########## PHP SETUP ########## 
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php73
yum install -y php php-fpm
sed -i 's/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php.ini
systemctl enable --now php-fpm

########## APPLICATION ########## 
echo '<?php phpinfo();' > /var/www/html/index.php
