FROM nginx:1.19-alpine
COPY ./build/wannabe-nginx.conf /etc/nginx/templates/default.conf.template