FROM nginx:1.21.0-alpine

RUN rm /etc/nginx/conf.d/default.conf || echo "removed already"
RUN mkdir -p /etc/nginx/conf.d

COPY nginx.conf /etc/nginx/conf.d
COPY nginx_root.conf /etc/nginx/nginx.conf

WORKDIR /usr/src/app
