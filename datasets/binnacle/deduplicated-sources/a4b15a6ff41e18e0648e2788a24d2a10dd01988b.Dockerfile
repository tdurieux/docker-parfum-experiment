FROM ubuntu:17.10

RUN apt-get -y update && apt-get -y install software-properties-common
# a utf-8 locale is needed to make the import of the ondrej repo work
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php && apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install composer postgresql php7.2 php7.2-cli php7.2-fpm \
                       php7.2-json php7.2-pgsql php7.2-curl php7.2-xml \
                       php7.2-zip php7.2-mbstring php7.2-gd apache2 \
                       libapache2-mod-php7.2 dirmngr

RUN rm -f /etc/apache2/sites-enabled/000-default.conf

RUN a2enmod rewrite

COPY . /var/www/airship
WORKDIR /var/www/airship
RUN composer install --no-dev

RUN chown -R www-data:www-data .
RUN chmod -R g+w .

ENV CONF /etc/apache2/sites-enabled/airship.conf

RUN echo "<VirtualHost *:80>" > $CONF && \
    echo "DocumentRoot /var/www/airship/src/public" >> $CONF && \
    echo "ErrorLog /dev/stderr" >> $CONF && \
    echo "CustomLog /dev/stdout combined" >> $CONF && \
    echo "<Directory />" >> $CONF && \
    echo "RewriteEngine On" >> $CONF && \
    echo "RewriteCond %{REQUEST_FILENAME} -f [OR]" >> $CONF && \
    echo "RewriteCond %{REQUEST_FILENAME} -d" >> $CONF && \
    echo "RewriteRule (.*) - [L,QSA]" >> $CONF && \
    echo "RewriteRule (.*) /index.php?\$1 [L,QSA]" >> $CONF && \
    echo "</Directory>" >> $CONF && \
    echo "</VirtualHost>" >> $CONF

# make php-fpm log to STDERR so docker logs sees PHP's error logging
RUN ln -s /dev/stderr /var/log/php7.2-fpm.log

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2

CMD ["apache2", "-DFOREGROUND"]
