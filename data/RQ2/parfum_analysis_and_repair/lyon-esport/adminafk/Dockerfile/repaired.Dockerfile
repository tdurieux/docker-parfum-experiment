FROM php:7.0-apache

LABEL maintainer="Ludovic Ortega ludovic.ortega@lyon-esport.fr"

# update packages
RUN apt-get update && apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*; # install required packages


# install apache extensions
RUN docker-php-ext-install pdo_mysql

# cleanhtml directory
RUN rm -Rf /var/www/html/*

# copy file to /var/www/html/
COPY . /var/www/html/

# set workdir
WORKDIR /var/www/html/

# remove useless file
RUN rm adminafk.sql server.csv team.csv
