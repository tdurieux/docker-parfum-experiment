FROM nginx:1.16
COPY ./flo_web/turn_server/index.html /usr/share/nginx/html/index.html
COPY ./flo_web/nginx-turn.conf /etc/nginx/conf.d/default.conf