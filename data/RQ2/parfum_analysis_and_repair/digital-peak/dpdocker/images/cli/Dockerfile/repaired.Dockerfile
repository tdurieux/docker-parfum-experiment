ARG PHP_VERSION=8.0

FROM thecodingmachine/php:${PHP_VERSION}-v4-cli-node16

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
