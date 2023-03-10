FROM nginx:1.13-alpine

WORKDIR /var/www/Minds

ENV UPSTREAM_ENDPOINT=front-live-server:4200

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/nginx.conf
COPY dev-ssr.conf.tpl /dev-ssr.conf.tpl
COPY nginx_entrypoint_dev_ssr.sh /nginx_entrypoint_dev_ssr.sh

ENTRYPOINT /nginx_entrypoint_dev_ssr.sh