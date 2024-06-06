#!/bin/bash
yum install nginx -y
systemctl start nginx

echo "server {
        listen 80;
        listen [::]:80;

        server_name _; # Public IPv4 Address

        location / {
           proxy_pass http://${PRIVATE_SERVER_IP}:3000/;       #<Private Ip Address of Private Instance>:<port>
        }
}" > /etc/nginx/conf.d/reverse.conf

systemctl restart nginx