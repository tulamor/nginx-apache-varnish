#!/bin/bash
# set -euo pipefail
IFS=$'\n\t'

# ########## APACHE SETUP ##########
yum install nano -y
yum install -y policycoreutils-python
semanage port -a -t http_port_t -p tcp 82 # Only for TEST ENV, port > 1024 must be used
yum install -y httpd

APACHE_CONF="/etc/httpd/conf/httpd.conf"
sed -i 's/^EnableSendfile on/EnableSendfile off/' $APACHE_CONF
sed -i 's/^Listen 80/Listen 82/' $APACHE_CONF
sed -i 's/DirectoryIndex index.html/DirectoryIndex index.html index.php/' $APACHE_CONF
sed -i 's/^#ServerName www.example.com:80/ServerName apache-server/' $APACHE_CONF
echo "ServerTokens Prod" >> $APACHE_CONF
echo "ServerSignature Off" >> $APACHE_CONF

systemctl enable --now httpd
