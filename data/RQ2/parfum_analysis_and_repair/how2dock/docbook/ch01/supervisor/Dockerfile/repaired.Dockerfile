FROM ubuntu:14.04

RUN apt-get update && apt-get -y --no-install-recommends install \
    apache2 \
    php5 \
    php5-mysql \
    supervisor \
    wget && rm -rf /var/lib/apt/lists/*;

RUN echo 'mysql-server mysql-server/root_password password root' | debconf-set-selections && \
    echo 'mysql-server mysql-server/root_password_again password root' | debconf-set-selections

RUN apt-get install --no-install-recommends -qqy mysql-server && rm -rf /var/lib/apt/lists/*;

RUN wget https://wordpress.org/latest.tar.gz && \
    tar xzvf latest.tar.gz && \
    cp -R ./wordpress/* /var/www/html && \
    rm /var/www/html/index.html && rm latest.tar.gz

RUN (/usr/bin/mysqld_safe &); sleep 5; mysqladmin -u root -proot create wordpress

COPY wp-config.php /var/www/html/wp-config.php
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord"]
