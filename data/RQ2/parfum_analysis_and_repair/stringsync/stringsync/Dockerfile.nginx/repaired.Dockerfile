FROM nginx:1.21

WORKDIR /www/data
COPY ./web/build/ /www/data/
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf