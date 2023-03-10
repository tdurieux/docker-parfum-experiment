# Use the official Docker Hub Ubuntu 18.04 base image
FROM ubuntu:20.04

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Update the base image
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade

# Setup PHP5
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:ondrej/php
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install apache2 libapache2-mod-php7.2 sudo rsyslog wget mysql-client curl nodejs && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install php7.2-cli php7.2-xml php7.2-mysql php7.2-pgsql php7.2-json php7.2-curl php7.2-mbstring php7.2-intl php7.2-redis php7.2-dev php-pear composer && rm -rf /var/lib/apt/lists/*;

RUN sed -i 's/memory_limit = 128M/memory_limit = 1G/g' /etc/php/7.2/apache2/php.ini
RUN sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php/7.2/apache2/php.ini
RUN sed -i 's/short_open_tag = Off/short_open_tag = On/g' /etc/php/7.2/apache2/php.ini
RUN sed -i 's/short_open_tag = Off/short_open_tag = On/g' /etc/php/7.2/cli/php.ini
RUN sed -i 's/display_errors = On/display_errors = Off/g' /etc/php/7.2/apache2/php.ini
RUN sed -i 's/error_reporting = E_ALL \& ~E_DEPRECATED \& ~E_STRICT/error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED/g' /etc/php/7.2/apache2/php.ini

# Add zip toolbox
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install zip unzip php-zip && rm -rf /var/lib/apt/lists/*;

# Setup igbinary
RUN DEBIAN_FRONTEND=noninteractive pecl install igbinary
RUN echo "extension=igbinary.so" > /etc/php/7.2/mods-available/igbinary.ini
#RUN ln -s /etc/php/7.2/mods-available/igbinary.ini /etc/php/7.2/cli/conf.d/20-igbinary.ini
#RUN ln -s /etc/php/7.2/mods-available/igbinary.ini /etc/php/7.2/apache2/conf.d/20-igbinary.ini

# Setup Memcached
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install libmemcached11 libmemcachedutil2 build-essential libmemcached-dev libz-dev libxml2-dev zlib1g-dev libicu-dev g++ && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install apt-utils && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install pkg-config re2c && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive pecl channel-update pecl.php.net
RUN DEBIAN_FRONTEND=noninteractive pecl download memcached-3.0.4 && tar xvzf memcached-3.0.4.tgz && cd memcached-3.0.4 && phpize && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-memcached-igbinary && make && make install && rm memcached-3.0.4.tgz
RUN echo "extension=memcached.so" > /etc/php/7.2/mods-available/memcached.ini
RUN ln -s /etc/php/7.2/mods-available/memcached.ini /etc/php/7.2/cli/conf.d/20-memcached.ini
RUN ln -s /etc/php/7.2/mods-available/memcached.ini /etc/php/7.2/apache2/conf.d/20-memcached.ini

# HTTP_Request2
RUN DEBIAN_FRONTEND=noninteractive pear install HTTP_Request2

# Setup awscli
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install python3 python3-pip rsync git wget rinetd && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive pip --no-cache-dir install awscli

# Install NodeJS, Zotero web-library requires: node: ^8.16.0 (https://gist.github.com/remarkablemark/aacf14c29b3f01d6900d13137b21db3a#file-dockerfile-L5)
RUN mkdir -p /usr/local/nvm
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 10.22.1
RUN DEBIAN_FRONTEND=noninteractive wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default
# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Setup Apache2
RUN a2enmod rewrite
RUN a2enmod headers

# Enable the new virtualhost
COPY zotero.conf /etc/apache2/sites-available/
RUN a2dissite 000-default
RUN a2ensite zotero

# Override gzip configuration
COPY gzip.conf /etc/apache2/conf-available/
RUN a2enconf gzip

# AWS local credentials
RUN mkdir ~/.aws  && bash -c 'echo -e "[default]\nregion = us-east-1" > ~/.aws/config' && bash -c 'echo -e "[default]\naws_access_key_id = zotero\naws_secret_access_key = zoterodocker" > ~/.aws/credentials'

# Chown log directory
RUN chown 33:33 /var/log/apache2

# Rinetd
RUN echo "0.0.0.0		8082		minio		9000" >> /etc/rinetd.conf

# Expose and entrypoint
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
VOLUME /var/www/zotero
EXPOSE 80/TCP
EXPOSE 81/TCP
EXPOSE 82/TCP
EXPOSE 8001/TCP

ENTRYPOINT ["/entrypoint.sh"]

