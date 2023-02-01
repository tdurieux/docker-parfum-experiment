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
        sudo && rm -rf /var/lib/apt/lists/*;

RUN dpkg-reconfigure --frontend noninteractive tzdata

# Make Debian/Ubuntu and Docker friends
ENV DEBIAN_FRONTEND noninteractive

# install phantomjs
RUN apt-get install -y --no-install-recommends phantomjs && rm -rf /var/lib/apt/lists/*;

# PhantomJS Offscreen wrapper
COPY phantomjs-offscreen /usr/local/bin/phantomjs
RUN chmod +x /usr/local/bin/phantomjs

# add php source list
RUN apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && rm -rf /var/lib/apt/lists/*;

# TODO: consider add-apt-repository ppa:ondrej/apache2

# Install Apache httpd and php (php-dev/php-pear is required for pecl)
RUN apt-get install -y --no-install-recommends \
        sqlite3 \
        apache2 \
        libapache2-mod-php7.3 \
        msmtp \
        msmtp-mta \
        php7.3 \
        php7.3-sqlite \
        php7.3-cli \
        php7.3-curl \
        php7.3-gd \
        php7.3-intl \
        php7.3-xml \
        php7.3-zip \
        php7.3-mbstring && rm -rf /var/lib/apt/lists/*;

# dev/build stuff (pecl for mcrypt and v8js)
RUN apt-get install -y --no-install-recommends \
        build-essential \
        libmcrypt-dev \
        php7.3-dev \
        php-pear && rm -rf /var/lib/apt/lists/*;

# more dev stuff (might be outdated due to distro packages)
RUN apt-get install -y --no-install-recommends \
        nodejs \
        npm \
        grunt \
        composer && rm -rf /var/lib/apt/lists/*; \


# install mcrypt (now pecl) DISABLED because it is deprecated
#RUN sudo CFLAGS=-w CPPFLAGS=-w pecl install mcrypt
#RUN echo "extension = mcrypt.so" | sudo tee -a /etc/php/7.3/mods-available/mcrypt.ini
#RUN phpenmod mcrypt

# lib v8 / phpv8js
RUN add-apt-repository ppa:stesie/libv8 && apt-get update
RUN apt-get install --no-install-recommends -y libv8-7.5-dev && rm -rf /var/lib/apt/lists/*;

RUN echo "/opt/libv8-7.5/lib" | sudo tee -a /etc/ld.so.conf.d/libv8.conf
RUN ldconfig

RUN printf "\/opt/libv8-7.5\n" | sudo CFLAGS=-w CPPFLAGS=-w pecl install v8js-2.1.1
RUN echo "extension = v8js.so" | sudo tee -a /etc/php/7.3/mods-available/v8js.ini

RUN phpenmod v8js


# Activate Apache mods
RUN a2enmod ssl && \
    a2enmod rewrite

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

# Install the release/cmsrelase.tar.gz (a version from our Jenkins)
COPY release/ /tmp/rukzuk_release/
RUN if [ -e /tmp/rukzuk_release/cmsrelease.tar.gz ]; then \
 tar -xf /tmp/rukzuk_release/cmsrelease.tar.gz -C ${CMS_PATH}/.. --strip 1; rm /tmp/rukzuk_release/cmsrelease.tar.gzfi
RUN if [ -e /tmp/rukzuk_release/ ]; then rm -Rf /tmp/rukzuk_release/; fi

RUN ln -s ${CMS_PATH}/app/server/environment ${INSTANCE_PATH}/environment
RUN ln -s ${CMS_PATH} ${INSTANCE_PATH}/application

# Initial
ENV APPLICATION_ENV standalone
ENV CMS_DB_TYPE=sqlite
ENV CMS_SQLITE_DB ${INSTANCE_PATH}/htdocs/cms/db.sqlite3
COPY config_sqlite.php ${INSTANCE_PATH}/config.php
COPY cms.apache /etc/apache2/sites-available/000-default.conf
RUN mkdir -p /etc/my_init.d
COPY init.sh /etc/my_init.d/30-rukzuk_init.sh
RUN chmod +x /etc/my_init.d/30-rukzuk_init.sh
COPY msmtprc.tpl /etc/msmtprc.tpl

EXPOSE 80


# >>DEVVM>> do not remove this marker (used at jenkins)


#
# Stuff for vagrant below
#

# Create user
ENV USERNAME vagrant
RUN useradd --create-home -s /bin/bash $USERNAME
RUN gpasswd -a vagrant www-data

# Configure user - SSH access
RUN rm -f /etc/service/sshd/down
RUN mkdir -p /home/$USERNAME/.ssh && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== $USERNAME insecure public key" > /home/$USERNAME/.ssh/authorized_keys && \
    chmod 700 /home/$USERNAME/.ssh && \
    echo -n "$USERNAME:$USERNAME" | chpasswd && \
    touch /home/$USERNAME/.hushlogin && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/ && \
    mkdir -p /etc/sudoers.d && echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME && chmod 0440 /etc/sudoers.d/$USERNAME

