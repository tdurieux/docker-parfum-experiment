FROM nginx:1.21.1

RUN mkdir -p /opt/sc/sockets

RUN rm /etc/nginx/conf.d/default.conf

COPY '*.sh' ./