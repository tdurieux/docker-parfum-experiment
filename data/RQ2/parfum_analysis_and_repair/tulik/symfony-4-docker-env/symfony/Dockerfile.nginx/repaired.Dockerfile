FROM nginx:alpine

COPY docker/nginx/conf.d /etc/nginx/conf.d/
COPY public /srv/symfony/public