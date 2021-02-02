#!/bin/bash
# set -euo pipefail
IFS=$'\n\t'

# ########## APACHE SETUP ########## 
yum install -y policycoreutils-python
semanage port -a -t http_port_t -p tcp 82 # Only for TEST ENV, port > 1024 must be used
yum install -y httpd

sed -i 's/^EnableSendfile on/EnableSendfile off/' /etc/httpd/conf/httpd.conf
sed -i 's/^Listen 80/Listen 82/' /etc/httpd/conf/httpd.conf
sed -i 's/^#ServerName www.example.com:80/ServerName apache-server/' /etc/httpd/conf/httpd.conf

systemctl enable --now httpd
