# runnable base
FROM boxcar/raring

# REPOS
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y -q software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get -y update

#SHIMS
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl
ENV DEBIAN_FRONTEND noninteractive

# EDITORS
RUN apt-get install --no-install-recommends -y -q vim nano && rm -rf /var/lib/apt/lists/*;

# TOOLS
RUN apt-get install --no-install-recommends -y -q curl git make wget && rm -rf /var/lib/apt/lists/*;

# BUILD
RUN apt-get install --no-install-recommends -y -q build-essential g++ && rm -rf /var/lib/apt/lists/*;

# LANGS

## PHP
RUN apt-get install --no-install-recommends -y -q php5 php5-cli php5-dev php-pear php5-fpm php5-common php5-mcrypt php5-gd php-apc && rm -rf /var/lib/apt/lists/*;

## NODE
RUN apt-get install --no-install-recommends -y -q nodejs && rm -rf /var/lib/apt/lists/*;

# SERVICES

## MEMCACHED
RUN apt-get install --no-install-recommends -y -q memcached && rm -rf /var/lib/apt/lists/*;
RUN pecl install memcache

## MAGICK
RUN apt-get install --no-install-recommends -y -q imagemagick graphicsmagick graphicsmagick-libmagick-dev-compat && rm -rf /var/lib/apt/lists/*;
RUN pecl install imagick

## APACHE
RUN apt-get install --no-install-recommends -y -q apache2 libapache2-mod-php5 && rm -rf /var/lib/apt/lists/*;

## MYSQL
RUN apt-get install --no-install-recommends -y -q mysql-client mysql-server php5-mysql && rm -rf /var/lib/apt/lists/*;
RUN mysqld & sleep 2 && mysqladmin create mydb

## CAKE
RUN a2enmod php5 rewrite
RUN rm -rf /var/www/*
RUN git clone https://github.com/cakephp/cakephp.git /var/www
RUN ln -s /var/www/lib/Cake/Console/cake /bin/cake
RUN chown -R www-data /var/www/app/tmp
# ADD app /var/www/app

# RESET

ENV DEBIAN_FRONTEND dialog

## CONFIG
ENV RUNNABLE_USER_DIR /var/www/app
ENV RUNNABLE_SERVICE_CMDS memcached -d -u www-data; /etc/init.d/apache2 restart; mysqld