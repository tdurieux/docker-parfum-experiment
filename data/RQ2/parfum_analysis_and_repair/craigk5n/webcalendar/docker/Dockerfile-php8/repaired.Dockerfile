FROM php:8.0-apache
MAINTAINER craigk5n <craig@k5n.us>
LABEL vendor "k5n.us"

RUN docker-php-ext-install mysqli

# Copy only the files included in a release rather than all files

RUN mkdir -p /var/www/html/images \
  /var/www/html/pub \
  /var/www/html/tools \
  /var/www/html/translations \
  /var/www/html/install \
  /var/www/html/themes 
COPY images /var/www/html/images/
COPY includes /var/www/html/includes/
# In case there was a copy in the local dev setup, remove any
# existing settings.php.
RUN rm -f /var/www/html/includes/settings.php
RUN touch /var/www/html/includes/settings.php
run chmod 777 /var/www/html/includes/settings.php
COPY install /var/www/html/install/
COPY pub /var/www/html/pub/
COPY tools /var/www/html/tools/
COPY themes /var/www/html/themes/
COPY translations /var/www/html/translations/
COPY [a-z]*php favicon.ico GPL.html /var/www/html/
COPY docs/WebCalendar-SysAdmin.html docs/newwin.gif /var/www/html/docs/