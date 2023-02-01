# based on ubuntu 18.04 (bionic)
FROM phusion/baseimage:0.11

VOLUME /srv/rukzuk/htdocs/cms

# proposed breaks some php packages (e.g. php-intl)
RUN rm -rf /etc/apt/sources.list.d/proposed.list

# phusion/baseimage is not always up to date. :-(
RUN apt-get update  && \
    apt-get dist-upgrade -y --no-install-recommends

# Set Timezone
RUN echo "Europe/Berlin" > /etc/timezone

# Install Depencies
RUN apt-get install -y --no-install-recommends \
        tzdata \
        sudo

RUN dpkg-reconfigure --frontend noninteractive tzdata

# Make Debian/Ubuntu and Docker friends
ENV DEBIAN_FRONTEND noninteractive

# install phantomjs
RUN apt-get install -y --no-install-recommends phantomjs

# PhantomJS Offscreen wrapper
COPY phantomjs-offscreen /usr/local/bin/phantomjs
RUN chmod +x /usr/local/bin/phantomjs

# add php source list
RUN apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update

# Install Apache httpd
RUN apt-get install -y --no-install-recommends \
        sqlite3 \
        apache2 \
        libapache2-mod-php7.3 \
        msmtp \
        msmtp-mta \
        php7.3 \
#        php7.3-sqlite \
        php7.3-mysql \
        php7.3-cli \
        php7.3-curl \
        php7.3-gd \
        php7.3-intl \
        php7.3-xml \
        php7.3-zip \
        php7.3-mbstring

# dev/build stuff (pecl for mcrypt and v8js)
RUN apt-get install -y --no-install-recommends \
        build-essential \
        libmcrypt-dev \
        libmcrypt4 \
        php7.3-dev \
        php-pear

# install mcrypt (now pecl) DISABLED because it is deprecated
#RUN sudo CFLAGS=-w CPPFLAGS=-w pecl install mcrypt
#RUN echo "extension = mcrypt.so" | sudo tee -a /etc/php/7.3/mods-available/mcrypt.ini
#RUN phpenmod mcrypt

# lib v8
RUN add-apt-repository ppa:stesie/libv8 && apt-get update
RUN apt-get install -y libv8-7.5-dev

RUN echo "/opt/libv8-7.5/lib" | sudo tee -a /etc/ld.so.conf.d/libv8.conf
RUN ldconfig

RUN printf "\/opt/libv8-7.5\n" | sudo CFLAGS=-w CPPFLAGS=-w pecl install v8js-2.1.1
RUN echo "extension = v8js.so" | sudo tee -a /etc/php/7.3/mods-available/v8js.ini 

# Activate PHP mods
RUN phpenmod v8js

# Activate Apache mods
RUN a2enmod ssl && \
    a2enmod rewrite

# Install mysql
RUN apt-get install -y --no-install-recommends mariadb-server

# major version update if 
ENV MARIADB_MAJOR 10.1

## based on https://github.com/docker-library/mariadb/blob/master/10.1/Dockerfile#L90
# the "/var/lib/mysql" stuff here is because the mysql-server postinst doesn't have an explicit way to disable the mysql_install_db codepath besides having a database already "configured" (ie, stuff in /var/lib/mysql/mysql)
# also, we set debconf keys to make APT a little quieter
RUN set -ex; \
	{ \
		echo "mariadb-server-$MARIADB_MAJOR" mysql-server/root_password password 'unused'; \
		echo "mariadb-server-$MARIADB_MAJOR" mysql-server/root_password_again password 'unused'; \
	} | debconf-set-selections; \
	apt-get update; \
	apt-get install -y \
		"mariadb-server" \
		socat \
	; \
#	rm -rf /var/lib/apt/lists/*; \
# comment out any "user" entires in the MySQL config ("docker-entrypoint.sh" or "--user" will handle user switching)
	sed -ri 's/^user\s/#&/' /etc/mysql/my.cnf /etc/mysql/conf.d/*; \
# purge and re-create /var/lib/mysql with appropriate ownership
	rm -rf /var/lib/mysql; \
	mkdir -p /var/lib/mysql /var/run/mysqld; \
	chown -R mysql:mysql /var/lib/mysql /var/run/mysqld; \
# ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
	chmod 777 /var/run/mysqld; \
# comment out a few problematic configuration values
	find /etc/mysql/ -name '*.cnf' -print0 \
		| xargs -0 grep -lZE '^(bind-address|log)' \
		| xargs -rt -0 sed -Ei 's/^(bind-address|log)/#&/'; \
# don't reverse lookup hostnames, they are usually another container; fix log size
	echo '[mysqld]\nskip-host-cache\nskip-name-resolve\ninnodb_log_file_size=128M\ninnodb_buffer_pool_size=512M' > /etc/mysql/conf.d/docker.cnf

VOLUME /var/lib/mysql

# Activate mysql in runit
RUN mkdir -p /etc/service/mysqld
COPY mysqld.runit /etc/service/mysqld/run
RUN chmod +x /etc/service/mysqld/run


# Activate apache2 in runit
RUN mkdir -p /etc/service/apache2
COPY apache2.runit /etc/service/apache2/run
RUN chmod +x /etc/service/apache2/run

# Create folder
ENV CMS_PATH /opt/rukzuk/htdocs
ENV INSTANCE_PATH /srv/rukzuk
RUN mkdir -p ${CMS_PATH}
RUN mkdir -p ${INSTANCE_PATH}/htdocs/cms
RUN chown -R www-data:www-data ${INSTANCE_PATH}/htdocs

# Install latest github release
RUN curl -L $(curl -s https://api.github.com/repos/rukzuk/rukzuk/releases/latest | grep browser_download_url | grep 'tgz\|tar.gz' | cut -d '"' -f 4) | tar -xz --strip 1 -C ${CMS_PATH}/..

RUN ln -s ${CMS_PATH}/app/server/environment ${INSTANCE_PATH}/environment
RUN ln -s ${CMS_PATH} ${INSTANCE_PATH}/application

# rukzuk env config (for init script)
ENV APPLICATION_ENV standalone

## sqlite (disabled)
#  ENV CMS_DB_TYPE=sqlite
#  ENV CMS_SQLITE_DB ${INSTANCE_PATH}/htdocs/cms/db.sqlite3
#  COPY config_sqlite.php ${INSTANCE_PATH}/config.php

## mysql
ENV CMS_DB_TYPE=mysql
ENV CMS_MYSQL_USER=rukzuk
ENV CMS_MYSQL_PASSWORD=rukzuk
ENV CMS_MYSQL_DB=rukzuk
COPY config_mysql.php ${INSTANCE_PATH}/config.php

COPY cms.apache /etc/apache2/sites-available/000-default.conf
COPY msmtprc.tpl /etc/msmtprc.tpl
COPY root-my-cnf.tpl /etc/root-my-cnf.tpl

# my init scripts (run before any runit services)
RUN mkdir -p /etc/my_init.d
COPY mysql_start.sh     /etc/my_init.d/20-mysql_start.sh
RUN chmod +x            /etc/my_init.d/20-mysql_start.sh
COPY mysql_conf_user.sh /etc/my_init.d/21-mysql_conf_user.sh
RUN chmod +x            /etc/my_init.d/21-mysql_conf_user.sh
COPY init.sh            /etc/my_init.d/30-rukzuk_init.sh
RUN chmod +x            /etc/my_init.d/30-rukzuk_init.sh
COPY mysql_end.sh       /etc/my_init.d/40-mysql_end.sh
RUN chmod +x            /etc/my_init.d/40-mysql_end.sh

# tool scripts
RUN mkdir -p /opt/rukzuk-tools/
COPY import-metajson.php /opt/rukzuk-tools/import-metajson.php
COPY import-data.sh      /opt/rukzuk-tools/import-data.sh
RUN chmod +x             /opt/rukzuk-tools/import-data.sh

## Publisher

# install phyton and pip
RUN apt-get install -y --no-install-recommends \
        build-essential \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        redis

# Add users and folders
RUN useradd -s /bin/bash -d /opt/publisher publisher
RUN mkdir -p /var/log/publisher
RUN chown publisher /var/log/publisher
RUN mkdir -p /var/tmp/publisher
RUN chown publisher /var/tmp/publisher

# copy code
RUN mkdir -p /opt/publisher
# get latest publisher release form github and extract it
RUN curl -L $(curl -s https://api.github.com/repos/rukzuk/publisher/releases/latest | grep tarball_url | cut -d '"' -f 4) | tar -xz --strip 1 -C /opt/publisher
# remove dev config file
RUN rm /opt/publisher/settings-dev.ini 2>/dev/null
# fix rights
RUN chown -R publisher /opt/publisher

# install requirements
RUN pip3 install -r /opt/publisher/requirements.txt

# Activate services in runit
RUN mkdir -p /etc/service/supervisord
RUN cp /opt/publisher/conf/supervisord.runit /etc/service/supervisord/run
RUN chmod +x /etc/service/supervisord/run

RUN mkdir -p /etc/service/redis
RUN cp /opt/publisher/conf/redis.runit /etc/service/redis/run
RUN chmod +x /etc/service/redis/run

### End Publisher


# Remove unused packages (only used to build)  & Cleanup 
RUN apt-get purge -y php7.3-dev libmcrypt-dev php-pear build-essential
RUN apt-get clean -y
RUN apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/*

EXPOSE 80

