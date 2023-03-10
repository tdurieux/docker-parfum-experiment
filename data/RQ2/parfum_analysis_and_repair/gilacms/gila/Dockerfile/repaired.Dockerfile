FROM ubuntu:18.04

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install apache2 && rm -rf /var/lib/apt/lists/*;

ENV TZ=America/Mexico_City
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y --no-install-recommends install php php-json php-mysql php-mbstring php-zip php-gd php-xml && rm -rf /var/lib/apt/lists/*;
RUN a2enmod rewrite

WORKDIR /var/www/html/
COPY src src
COPY themes themes
COPY assets assets
COPY log log
COPY sites sites
COPY data data
COPY tmp tmp
COPY robots.txt robots.txt
COPY config.default.php config.default.php
COPY .htaccess .htaccess
COPY index.php index.php
RUN chmod 777 -R /var/www/html
RUN rm /var/www/html/index.html
RUN apt-get clean

EXPOSE 80
COPY tests/scripts/000-default.conf /etc/apache2/sites-available/000-default.conf
CMD ["apache2ctl", "-D", "FOREGROUND"]
