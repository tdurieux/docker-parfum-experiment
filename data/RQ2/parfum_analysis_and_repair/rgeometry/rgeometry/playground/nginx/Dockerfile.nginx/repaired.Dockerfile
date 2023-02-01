FROM nginx
COPY nginx_default.conf /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY loader.html /var/www/html/
EXPOSE 80
EXPOSE 443