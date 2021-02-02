Vagrant box configuration provides nginx & apache php web server environment used together with varnish load balancer  
---
Imprpoved:
```bash
# Hide apache server version
/etc/httpd/conf/httpd.conf
ServerTokens Prod
ServerSignature Off

# Hide nginx server version
/etc/nginx/nginx.conf
http {
  server_tokens off;
}

# Hide PHP server version
/etc/php.ini
expose_php = off

```
