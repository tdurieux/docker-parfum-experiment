FROM nginx:latest
COPY html/* /etc/nginx/html/
COPY config/nginx.conf /etc/nginx/nginx.conf