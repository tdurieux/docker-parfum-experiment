FROM nginx
MAINTAINER Jeongkyu Shin <jshin@lablup.com>

COPY ./build/rollup /usr/share/nginx/html
COPY ./config.toml /usr/share/nginx/html/config.toml
RUN rm /etc/nginx/conf.d/default.conf
COPY ./docker_build/nginx-site.conf /etc/nginx/conf.d/default.template