FROM nginx:1.13-alpine

WORKDIR /var/www/Minds

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/nginx.conf
COPY dev.conf /etc/nginx/conf.d/dev.conf
COPY nginx_entrypoint_dev.sh /nginx_entrypoint_dev.sh

ENTRYPOINT /nginx_entrypoint_dev.sh