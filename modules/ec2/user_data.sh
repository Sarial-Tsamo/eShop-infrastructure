#!/bin/bash
yum update -y
yum install nginx -y

cat <<EOF > /etc/nginx/conf.d/reverse.conf
server {
   listen 443 ssl;


   ssl_certificate  /etc/nginx/self.crt;
   ssl_certificate_key  /etc/nginx/self.key;

   location / {
       proxy_pass http://${ECS_PRIVATE_IP}:8080;
       proxy_set_header  Host  \$host;
       proxy_set_header  X-Real-IP \$remote_addr;
   }
}
EOF

# Generate self-signed cert
openssl req -x509 -nodes -days 365 \
-newkey rsa:2048 \
-keyout /etc/nginx/self.key \
-out /etc/nginx/self.crt \
-subj "/CN=localhost"

systemctl enable nginx
systemctl start nginx
