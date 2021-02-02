Vagrant box configuration provides nginx & apache php web server environment used together with varnish load balancer

### TESTS
```bash
curl -I 192.168.100.101
curl -I 192.168.100.101:81 # Nginx
curl -I 192.168.100.101:82 # Apache

curl -I 127.0.0.1
curl -I 127.0.0.1:81
curl -I 127.0.0.1:82
echo "" > log; for INT in {1..1000};do curl -I 127.0.0.1:80 &>> log; done; cat log | grep nginx | wc -l
cat log | grep Apache | wc -l
```

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
