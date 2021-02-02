# ########## NGINX SETUP ##########
yum install -y epel-release yum-utils
yum install -y nginx

cat <<EOT > /etc/nginx/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile             off;
    tcp_nopush            on;
    tcp_nodelay           on;
    keepalive_timeout     65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    server {
        listen       81 default_server;
        listen       [::]:81 default_server;
        server_name  127.0.0.1;
        root         /var/www/html;
	    index index.php index.html index.htm;
	
	    location ~ \.php$ {
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            include fastcgi.conf;
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
        }

	    location ~ /\.ht {
            deny  all;
        }
   
        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
}
EOT

CPU_NUM=$(cat /proc/cpuinfo  | grep "processor" | wc -l)
sed -i -e "s/worker_processes.*;/worker_processes $CPU_NUM;/" /etc/nginx/nginx.conf
nginx -t && systemctl enable --now nginx