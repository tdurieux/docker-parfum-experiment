FROM nginx:latest
ADD artifacts/build /usr/share/nginx/html/
ADD nginx.default.conf /etc/nginx/conf.d/default.conf