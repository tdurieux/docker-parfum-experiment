FROM nginx

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./server.crt /etc/nginx/server.crt
COPY ./server.key /etc/nginx/server.key