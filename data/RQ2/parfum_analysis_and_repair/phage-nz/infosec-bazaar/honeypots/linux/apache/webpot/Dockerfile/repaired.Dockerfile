FROM php:7.0-apache

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN a2enmod rewrite
RUN a2enmod headers

RUN apt-get update
RUN apt-get install --no-install-recommends -y -q apt-utils dialog && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q libapache2-mod-security2 && rm -rf /var/lib/apt/lists/*;
RUN a2enmod security2

COPY src/ /var/www/html/
COPY conf/headers.conf /etc/apache2/mods-enabled/

RUN rm /var/log/apache2/error.log && touch /var/log/apache2/error.log
RUN rm /var/log/apache2/access.log && touch /var/log/apache2/access.log

EXPOSE 80