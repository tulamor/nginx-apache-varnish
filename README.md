Vagrant box configuration provides nginx & apache php web server environment used together with varnish load balancer

### TODO
```
Make config files override default settings [use conf.d] 
(Do not overwrite global conf files)
Investigate why varnishlog.service failing
Add security upgrades (dir listing / limit requests)
Use exact version for downloading tools
Disable "get latest" version of CENTOS
Get rid of warnings "NOKEY" / GPG keys
Check remote resources
Provide additional links to remote resources if unavailable
```
### TESTS
```bash
curl -I 192.168.100.101
curl -I 192.168.100.101:81 # Nginx
curl -I 192.168.100.101:82 # Apache

# connection check inside virtual machine
curl -I 127.0.0.1
curl -I 127.0.0.1:81
curl -I 127.0.0.1:82

echo "" > log; for INT in {1..2000};do curl -I 127.0.0.1:80 &>> log; done; cat log | grep nginx | wc -l
cat log | grep Apache | wc -l
```

---
Improved:
```bash
# Hide apache server version
/etc/httpd/conf/httpd.conf
---
ServerTokens Prod
ServerSignature Off

# Hide nginx server version
/etc/nginx/nginx.conf
---
http {
  server_tokens off;
}

# Hide PHP server version
/etc/php.ini
---
cgi.fix_pathinfo=0
expose_php = off
```
