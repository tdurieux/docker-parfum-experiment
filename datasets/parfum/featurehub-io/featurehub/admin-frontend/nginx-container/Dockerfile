FROM nginx:1.21.0-alpine

# now for nginx
RUN chown -R 999:999 /target /etc/nats/nats-server.conf /db /etc/app-config /etc/common-config
RUN apt-get update && apt-get install -y nginx && mkdir -p /var/lib/nginx/body /var/lib/nginx/proxy /var/lib/nginx/fastcgi
RUN chown -R www-data:www-data /var/lib/nginx/body /var/lib/nginx/proxy /var/lib/nginx /var/log/nginx /usr/share/nginx  /var/lib/nginx/fastcgi
COPY default_site /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx
RUN chown -R 999:999 /etc/nginx /var/lib/nginx /var/log/nginx /var/www/html

EXPOSE 8085
EXPOSE 8701



