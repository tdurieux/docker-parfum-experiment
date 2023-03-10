FROM nginx
EXPOSE 80
EXPOSE 443

WORKDIR /etc/nginx/

RUN mkdir /etc/nginx/location; \
    mkdir /var/www;
COPY dmadminweb/microservice/nginx.conf  /etc/nginx/
COPY dmadminweb/microservice/location/  /etc/nginx/location/

CMD nginx -g 'daemon off;'