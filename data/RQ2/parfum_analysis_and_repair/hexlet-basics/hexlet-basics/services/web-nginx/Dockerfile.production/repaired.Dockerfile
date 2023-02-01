FROM nginx:1.21.6

COPY /public /var/www/hexlet-basics/shared/public

COPY services/web-nginx/files/production/nginx.hexlet.basics.conf /etc/nginx/conf.d/hexlet-basics.conf
COPY services/web-nginx/files/production/gzip.conf /etc/nginx/gzip.conf
COPY services/web-nginx/files/.htpasswd /etc/nginx/.htpasswd
RUN rm -rf /etc/nginx/conf.d/default.conf