#  
#--------------------------------------------------------------------------  
# Image Setup  
#--------------------------------------------------------------------------  
#  
  
FROM php:7.0-fpm  
  
MAINTAINER Mahmoud Zalt <mahmoud@zalt.me>  
  
#  
#--------------------------------------------------------------------------  
# Software's Installation  
#--------------------------------------------------------------------------  
#  
# Installing tools and PHP extentions using "apt", "docker-php", "pecl",  
#  
# Install "curl", "libmemcached-dev", "libpq-dev", "libjpeg-dev",  
# "libpng12-dev", "libfreetype6-dev", "libssl-dev", "libmcrypt-dev",  
RUN apt-get update && \  
apt-get install -y --no-install-recommends \  
curl \  
libmemcached-dev \  
libz-dev \  
libpq-dev \  
libjpeg-dev \  
libpng12-dev \  
libfreetype6-dev \  
libssl-dev \  
libmcrypt-dev \  
libfreetype6 \  
libfreetype6-dev \  
libfontconfig1 \  
libfontconfig1-dev  
  
# Install the PHP mcrypt extention  
RUN docker-php-ext-install mcrypt  
  
# Install the PHP pdo_mysql extention  
RUN docker-php-ext-install mysqli pdo_mysql  
  
# Install the PHP pdo_pgsql extention  
RUN docker-php-ext-install pdo_pgsql  
  
# Install the PHP zip extention  
RUN docker-php-ext-install zip  
  
#####################################  
# gd:  
#####################################  
# Install the PHP gd library  
RUN docker-php-ext-configure gd \  
\--enable-gd-native-ttf \  
\--with-jpeg-dir=/usr/lib \  
\--with-freetype-dir=/usr/include/freetype2 && \  
docker-php-ext-install gd  

