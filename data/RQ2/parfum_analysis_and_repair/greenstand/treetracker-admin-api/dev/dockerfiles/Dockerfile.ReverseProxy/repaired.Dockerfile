FROM nginx:latest

COPY dev/etc/nginx-reverse-proxy-admin.conf /etc/nginx/nginx.conf
COPY dev/etc/502.html /var/www/custom_502.html