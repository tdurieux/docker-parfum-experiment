FROM dockersecplayground/linode_lamp:v2.0 
USER root
RUN  apt-get update && apt-get install -y unzip &&  /allow_url_include.sh && sed -i -e s/bind-address.*/bind-address\=\ \ 0\.\0\.\0\.0/g /etc/mysql/my.cnf && sed -i -e s/^user.*/user=root/g  /etc/mysql/my.cnf && chown -R www-data:www-data /var/log/apache2  && chown -R www-data:www-data /var/www

CMD service mysql restart && $ENV apache2ctl -D FOREGROUND