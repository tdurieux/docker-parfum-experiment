FROM alpine

RUN apk update && \
    apk add --no-cache unzip && \
    apk add --no-cache nginx && \
    apk add --no-cache php-fpm && \
    apk add --no-cache php-json && \
    apk add --no-cache php-mysqli && \
    mkdir /run/nginx;

COPY default.conf /etc/nginx/conf.d/

WORKDIR /var/www/wp-app

ADD https://wordpress.org/latest.zip .

RUN unzip latest.zip && \
    cp -r wordpress/* . && \
    rm -r latest.zip wordpress;

COPY wp-config.php .

EXPOSE 80

CMD ["/bin/sh", "-c", "/usr/sbin/php-fpm7; exec nginx -g 'daemon off;';"]