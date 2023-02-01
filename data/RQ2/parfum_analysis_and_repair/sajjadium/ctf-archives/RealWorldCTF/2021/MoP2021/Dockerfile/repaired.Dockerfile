FROM ubuntu:20.04

RUN apt update

RUN apt-get -y upgrade
RUN apt-get -y --no-install-recommends install tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install apache2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install php && rm -rf /var/lib/apt/lists/*;

COPY php.ini /etc/php/7.4/apache2/php.ini
RUN rm /etc/php/7.4/apache2/conf.d/10-opcache.ini
RUN rm /etc/php/7.4/apache2/conf.d/20-ffi.ini
RUN rm /var/www/html/index.html
COPY index.php /var/www/html/index.php
RUN chmod 755 -R /var/www/html/

COPY flag /flag
COPY readflag /readflag
RUN chmod 555 /readflag
RUN chmod u+s /readflag
RUN chmod 500 /flag

CMD service apache2 restart & tail -f /var/log/apache2/access.log