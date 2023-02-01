FROM alpine
RUN apk update
RUN apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli \
	php7-zlib php7-curl php7-mbstring php7-json php7-session
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.tar.gz
RUN tar -xvf /phpMyAdmin-4.9.5-all-languages.tar.gz
RUN rm -f /phpMyAdmin-4.9.5-all-languages.tar.gz
RUN mv /phpMyAdmin-4.9.5-all-languages /etc/phpmyadmin
RUN rm -rf /var/cache/apk/*

EXPOSE 5000

CMD php -S 0.0.0.0:5000 -t /etc/phpmyadmin/
