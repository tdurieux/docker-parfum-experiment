FROM nginx
LABEL maintainer="jshin@lablup.com" 

COPY ./build/rollup /usr/share/nginx/html
COPY ./configs/default.toml /usr/share/nginx/html/config.toml
RUN rm /etc/nginx/conf.d/default.conf
COPY ./docker_build/nginx.conf /etc/nginx/conf.d/default.template
COPY ./docker_build/nginx-ssl.conf /etc/nginx/conf.d/default-ssl.template