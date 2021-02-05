#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# apt-get update  
# apt-get upgrade
# sudo apt-get clean
# cat /dev/null > ~/.bash_history && history -c

########## PHP SETUP ########## 
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php73
yum install -y php php-fpm
cp /vagrant/config/php.ini /etc/
systemctl enable --now php-fpm

########## APACHE SETUP ##########
yum install -y httpd
yum install -y policycoreutils-python
semanage port -a -t http_port_t -p tcp 82 # Only for TEST ENV, port > 1024 must be used
cp /vagrant/config/httpd.conf /etc/httpd/conf/
systemctl enable --now httpd

########## NGINX SETUP ##########
yum install -y epel-release yum-utils nginx
cp /vagrant/config/nginx.conf /etc/nginx/
CPU_NUM=$(cat /proc/cpuinfo  | grep "processor" | wc -l)
sed -i -e "s/worker_processes.*;/worker_processes $CPU_NUM;/" /etc/nginx/nginx.conf
nginx -t && systemctl enable --now nginx

########## VARNISH SETUP ########## 
yum install -y varnish
cp /vagrant/config/varnish.params /etc/varnish/
cp /vagrant/config/default.vcl /etc/varnish/
systemctl enable --now varnish.service
# systemctl enable --now varnishlog.service

########## APPLICATION ########## 
cp -R /vagrant/html/ /var/www/