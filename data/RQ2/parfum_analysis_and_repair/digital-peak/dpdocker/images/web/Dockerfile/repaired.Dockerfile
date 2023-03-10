ARG PHP_VERSION=8.0

FROM thecodingmachine/php:${PHP_VERSION}-v4-apache-node16

# Enable extensions
ENV PHP_EXTENSION_GD=1
ENV PHP_EXTENSION_GMP=1
ENV PHP_EXTENSION_INTL=1
ENV PHP_EXTENSION_LDAP=1
ENV PHP_EXTENSION_PGSQL=1
ENV PHP_EXTENSION_PDO_PGSQL=1
ENV PHP_EXTENSION_PDO_SQLITE=1
ENV PHP_EXTENSION_SQLITE3=1
ENV PHP_EXTENSION_XDEBUG=1

# PHP ini variables
ENV PHP_INI_XDEBUG__MODE=coverage,debug,profile
ENV PHP_INI_XDEBUG__START_WITH_REQUEST=trigger
ENV PHP_INI_UPLOAD_MAX_FILESIZE=200M
ENV PHP_INI_POST_MAX_SIZE=200M

# Install
RUN sudo apt-get update
RUN sudo apt-get install --no-install-recommends -y mariadb-client && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends -y sqlite3 && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends -y graphviz python && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends -y rsync && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends -y php-pear && rm -rf /var/lib/apt/lists/*;

# Install webgrind
RUN git clone https://github.com/jokkedk/webgrind /var/www/html/wg

# Enable the apache ssl extensions
ENV APACHE_EXTENSION_SOCACHE_SHMCB=1
ENV APACHE_EXTENSION_SSL=1

# Setup the keys
RUN mkdir /home/docker/keys
RUN openssl req -new -newkey rsa:4096 -nodes -keyout /home/docker/keys/server.key -out /home/docker/keys/server.csr -subj "/CN=localhost"
RUN openssl x509 -req -days 365 -in /home/docker/keys/server.csr -signkey /home/docker/keys/server.key -out /home/docker/keys/server.crt
COPY 000-default-ssl.conf /etc/apache2/sites-enabled/000-default-ssl.conf
