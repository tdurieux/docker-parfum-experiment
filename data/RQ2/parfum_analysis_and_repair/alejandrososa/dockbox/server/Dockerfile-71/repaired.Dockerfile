FROM phusion/baseimage:latest

MAINTAINER Alejandro Sosa <alesjohnson@hotmail.com>


RUN DEBIAN_FRONTEND=noninteractive
RUN locale-gen en_US.UTF-8

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV TERM xterm

# Add the "PHP 7" ppa
RUN apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository -y ppa:ondrej/php && rm -rf /var/lib/apt/lists/*;

#Net tools
#RUN apt-get install -y net-tools

#
#--------------------------------------------------------------------------
# Software's Installation
#--------------------------------------------------------------------------
#

# Install "PHP Extentions", "libraries", "Software's"
RUN apt-get update && \
    apt-get install --no-install-recommends -y --allow-downgrades --allow-remove-essential \
            --allow-change-held-packages \
        sudo \
        php-pear \
        php7.1-cli \
        php7.1-common \
        php7.1-curl \
        php7.1-json \
        php7.1-xml \
        php7.1-mbstring \
        php7.1-mcrypt \
        php7.1-mysql \
        php7.1-pgsql \
        php7.1-sqlite \
        php7.1-sqlite3 \
        php7.1-zip \
        php7.1-bcmath \
        php7.1-memcached \
        php7.1-gd \
        php7.1-bcmath \
        php7.1-dev \
        pkg-config \
        libcurl4-openssl-dev \
        libedit-dev \
        libssl-dev \
        libxml2-dev \
        xz-utils \
        libsqlite3-dev \
        sqlite3 \
        git \
        curl \
        vim \
        nano \
        postgresql-client \
        git-core \
        zlib1g-dev \
        build-essential \
        libreadline-dev \
        libyaml-dev \
        libxslt1-dev \
        python-software-properties \
        libffi-dev \
        nodejs \
        ruby-full \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;


#####################################
# Composer:
#####################################

# Install composer and add its bin to the PATH.
RUN curl -f -s https://getcomposer.org/installer | php && \
    echo "export PATH=${PATH}:/var/www/vendor/bin" >> ~/.bashrc && \
    mv composer.phar /usr/local/bin/composer

# Source the bash
RUN . ~/.bashrc


#####################################
# Non-Root User:
#####################################

# Add a non-root user to prevent files being created with root permissions on host machine.
ARG PUID=1000
ARG PGID=1000
RUN groupadd -g $PGID desarrolladores && \
    useradd -u $PUID -g desarrolladores -m desarrollador && \
    apt-get update -yqq

RUN echo "" >> /etc/sudoers  && \
    echo "# User privilege specification" >> /etc/sudoers  && \
    echo "desarrollador   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers  && \
    echo "" >> /etc/sudoers

#####################################
# SOAP:
#####################################
USER root

ARG INSTALL_SOAP=false
ENV INSTALL_SOAP ${INSTALL_SOAP}

RUN if [ ${INSTALL_SOAP} = true ]; then \
  add-apt-repository -y ppa:ondrej/php && \
  apt-get update -yqq && \
  apt-get -y --no-install-recommends install libxml2-dev php7.1-soap \
; rm -rf /var/lib/apt/lists/*; fi

#####################################
# Set Timezone
#####################################

ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


#####################################
# Composer:
#####################################
# Add the composer.json
COPY ./composer.json /home/desarrollador/.composer/composer.json

# Make sure that ~/.composer belongs to desarrollador
RUN chown -R desarrollador:desarrolladores /home/desarrollador/.composer
USER desarrollador

# Check if global install need to be ran
ARG COMPOSER_GLOBAL_INSTALL=false
ENV COMPOSER_GLOBAL_INSTALL ${COMPOSER_GLOBAL_INSTALL}
RUN if [ ${COMPOSER_GLOBAL_INSTALL} = true ]; then \
    # run the install
    composer global install \
;fi

# Export composer vendor path
RUN echo "" >> ~/.bashrc && \
echo 'export PATH="~/.composer/vendor/bin:$PATH"' >> ~/.bashrc


#####################################
# Crontab
#####################################
USER root

COPY ./crontab /etc/cron.d
RUN chmod -R 644 /etc/cron.d


#####################################
# User Aliases
#####################################
USER desarrollador
COPY ./aliases.sh /home/desarrollador/aliases.sh
RUN echo "" >> ~/.bashrc
RUN echo "# Load Custom Aliases" >> ~/.bashrc
RUN echo "source /home/desarrollador/aliases.sh" >> ~/.bashrc && \
	echo "" >> ~/.bashrc && \
	sed -i 's/\r//' /home/desarrollador/aliases.sh && \
	sed -i 's/^#! \/bin\/sh/#! \/bin\/bash/' /home/desarrollador/aliases.sh

USER root
RUN echo "" >> ~/.bashrc && \
    echo "# Load Custom Aliases" >> ~/.bashrc && \
    echo "source /home/desarrollador/aliases.sh" >> ~/.bashrc && \
	echo "" >> ~/.bashrc && \
	sed -i 's/\r//' /home/desarrollador/aliases.sh && \
	sed -i 's/^#! \/bin\/sh/#! \/bin\/bash/' /home/desarrollador/aliases.sh


#####################################
# xDebug:
#####################################
ARG INSTALL_XDEBUG=false
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
    apt-get update && \
    apt-get install --no-install-recommends -y --force-yes php7.1-xdebug && \
    sed -i 's/^/;/g' /etc/php/7.1/cli/conf.d/20-xdebug.ini && \
    echo "alias phpunit='php -dzend_extension=xdebug.so /var/www/vendor/bin/phpunit'" >> ~/.bashrc \
; rm -rf /var/lib/apt/lists/*; fi
# ADD for REMOTE debugging
COPY ./xdebug.ini /etc/php/7.1/cli/conf.d/xdebug.ini


#####################################
# ssh:
#####################################
ARG INSTALL_WORKSPACE_SSH=false
ENV INSTALL_WORKSPACE_SSH ${INSTALL_WORKSPACE_SSH}

ADD ssh/insecure_id_rsa /tmp/id_rsa
ADD ssh/insecure_id_rsa.pub /tmp/id_rsa.pub
ADD ssh/ssh-key /tmp/ssh-key
ADD ssh/sshd_config /etc/ssh/sshd_config
RUN ssh-keygen -A

RUN if [ ${INSTALL_WORKSPACE_SSH} = true ]; then \
    rm -f /etc/service/sshd/down && \
    cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys \
        && cat /tmp/id_rsa.pub >> /root/.ssh/id_rsa.pub \
        && cat /tmp/id_rsa >> /root/.ssh/id_rsa \
        && cat /tmp/ssh-key >> /root/.ssh/authorized_keys \
        && rm -f /tmp/id_rsa* \
        && chmod 644 /root/.ssh/authorized_keys /root/.ssh/id_rsa.pub \
    && chmod 400 /root/.ssh/id_rsa \
    && service ssh restart \
;fi


#####################################
# MongoDB:
#####################################

# Check if Mongo needs to be installed
ARG INSTALL_MONGO=false
ENV INSTALL_MONGO ${INSTALL_MONGO}
RUN if [ ${INSTALL_MONGO} = true ]; then \
    # Install the mongodb extension
    pecl install mongodb && \
    echo "extension=mongodb.so" >> /etc/php/7.1/mods-available/mongodb.ini && \
    ln -s /etc/php/7.1/mods-available/mongodb.ini /etc/php/7.1/cli/conf.d/30-mongodb.ini \
;fi


USER desarrollador

#####################################
# Node / NVM:
#####################################

# Check if NVM needs to be installed
ARG NODE_VERSION=stable
ENV NODE_VERSION ${NODE_VERSION}
ARG INSTALL_NODE=false
ENV INSTALL_NODE ${INSTALL_NODE}
ENV NVM_DIR /home/desarrollador/.nvm
RUN if [ ${INSTALL_NODE} = true ]; then \
    curl -f -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash && \
        . $NVM_DIR/nvm.sh && \
        nvm install ${NODE_VERSION} && \
        nvm use ${NODE_VERSION} && \
        nvm alias ${NODE_VERSION} && \
        npm install -g less && \
        npm install -g webpack && \
        npm install -g vue && \
        npm install -g react react-dom \
; npm cache clean --force; fi

# Wouldn't execute when added to the RUN statement in the above block
# Source NVM when loading bash since ~/.profile isn't loaded on non-login shell
RUN if [ ${INSTALL_NODE} = true ]; then \
    echo "" >> ~/.bashrc && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc \
;fi

# Add NVM binaries to root's .bashrc
USER root

RUN if [ ${INSTALL_NODE} = true ]; then \
    echo "" >> ~/.bashrc && \
    echo 'export NVM_DIR="/home/desarrollador/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc \
;fi

#####################################
# YARN:
#####################################

USER desarrollador

ARG INSTALL_YARN=false
ENV INSTALL_YARN ${INSTALL_YARN}
ARG YARN_VERSION=latest
ENV YARN_VERSION ${YARN_VERSION}

RUN if [ ${INSTALL_YARN} = true ]; then \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    if [ ${YARN_VERSION} = "latest" ]; then \
        curl -f -o- -L https://yarnpkg.com/install.sh | bash; \
    else \
        curl -f -o- -L https://yarnpkg.com/install.sh | bash -s -- --version ${YARN_VERSION}; \
    fi && \
    echo "" >> ~/.bashrc && \
    echo 'export PATH="$HOME/.yarn/bin:$PATH"' >> ~/.bashrc \
; else \
        curl -f -o- -L https://yarnpkg.com/install.sh | bash -s -- --version ${YARN_VERSION}; \
    fi \


fi

# Add YARN binaries to root's .bashrc
USER root

RUN if [ ${INSTALL_YARN} = true ]; then \
    echo "" >> ~/.bashrc && \
    echo 'export YARN_DIR="/home/desarrollador/.yarn"' >> ~/.bashrc && \
    echo 'export PATH="$YARN_DIR/bin:$PATH"' >> ~/.bashrc \
;fi

#####################################
# PHP V8JS:
#####################################
USER root

ARG INSTALL_V8JS_EXTENSION=false
ENV INSTALL_V8JS_EXTENSION ${INSTALL_V8JS_EXTENSION}
RUN if [ ${INSTALL_V8JS} = true ]; then \
    add-apt-repository -y ppa:pinepain/libv8-5.4 \
    && apt-get update -yqq \
    && apt-get install --no-install-recommends -y php-xml php-dev php-pear libv8-5.4 \
    && pecl install v8js \
    && echo "extension=v8js.so" >> /etc/php/7.1/cli/php.ini \
; rm -rf /var/lib/apt/lists/*; fi

#####################################
# SASS:
#####################################
USER desarrollador

ARG INSTALL_SASS=false
ENV INSTALL_SASS ${INSTALL_SASS}

RUN if [ ${INSTALL_SASS} = true ]; then \
    # Install the sass bin
    sudo gem install sass \
;fi

#####################################
# Non-root user : PHPUnit path
#####################################

# add ./vendor/bin to non-root user's bashrc (needed for phpunit)
USER desarrollador

RUN echo "" >> ~/.bashrc && \
    echo 'export PATH="/var/www/vendor/bin:$PATH"' >> ~/.bashrc

#####################################
# Laravel Envoy:
#####################################
USER desarrollador

ARG INSTALL_LARAVEL_ENVOY=false
ENV INSTALL_LARAVEL_ENVOY ${INSTALL_LARAVEL_ENVOY}

RUN if [ ${INSTALL_LARAVEL_ENVOY} = true ]; then \
    # Install the Laravel Envoy
    composer global require "laravel/envoy=~1.0" \
;fi

#####################################
# Laravel Installer:
#####################################
USER root

ARG INSTALL_LARAVEL_INSTALLER=false
ENV INSTALL_LARAVEL_INSTALLER ${INSTALL_LARAVEL_INSTALLER}

RUN if [ ${INSTALL_LARAVEL_INSTALLER} = true ]; then \
    # Install the Laravel Installer
	echo "" >> ~/.bashrc && \
	echo 'export PATH="~/.composer/vendor/bin:$PATH"' >> ~/.bashrc \
	&& composer global require "laravel/installer" \
;fi


#####################################
# Deployer:
#####################################
USER desarrollador

ARG INSTALL_DEPLOYER=false
ENV INSTALL_DEPLOYER ${INSTALL_DEPLOYER}

RUN if [ ${INSTALL_DEPLOYER} = true ]; then \
    # Install the Deployer
    composer global require "deployer/deployer" \
;fi

#####################################
# SQL SERVER:
#####################################
USER root
ARG INSTALL_MSSQL=false
ENV INSTALL_MSSQL ${INSTALL_MSSQL}

RUN if [ ${INSTALL_MSSQL} = true ]; then \
        cd / && \
        apt-get update -yqq && \
        apt-get install --no-install-recommends -y --force-yes wget apt-transport-https curl freetds-common libsybdb5 freetds-bin unixodbc unixodbc-dev && \

    #####################################
    #  The following steps were taken from
    #  Microsoft's github account:
    #  https://github.com/Microsoft/msphpsql/wiki/Dockerfile-for-getting-pdo_sqlsrv-for-PHP-7.0-on-Debian-in-3-ways
    #####################################

    # Add PHP 7 repository
    # for Debian jessie
    # And System upgrade
        cd / && \
        echo "deb http://packages.dotdeb.org jessie all" \
        | tee /etc/apt/sources.list.d/dotdeb.list \
        && wget -qO- https://www.dotdeb.org/dotdeb.gpg \
        | apt-key add - \
        && apt-get update -yqq \
        && apt-get upgrade -qq && \

    # Install UnixODBC
    # Compile odbc_config as it is not part of unixodbc package
        cd / && \
        apt-get update -yqq && \
        apt-get install --no-install-recommends -y whiptail \
        unixodbc libgss3 odbcinst devscripts debhelper dh-exec dh-autoreconf libreadline-dev libltdl-dev \
        && dget -u -x http://http.debian.net/debian/pool/main/u/unixodbc/unixodbc_2.3.1-3.dsc \
        && cd unixodbc-*/ \
        && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install \
        && cp -v ./exe/odbc_config /usr/local/bin/ && \

    # Fake uname for install.sh
        printf '#!/bin/bash\nif [ "$*" == "-p" ]; then echo "x86_64"; else /bin/uname "$@"; fi' \
        | tee /usr/local/bin/uname \
        && chmod +x /usr/local/bin/uname && \

    # Microsoft ODBC Driver 13 for Linux
    # Note: There's a copy of this tar on my hubiC
        cd / && \
        wget -nv -O msodbcsql-13.0.0.0.tar.gz \
        "https://meetsstorenew.blob.core.windows.net/contianerhd/Ubuntu%2013.0%20Tar/msodbcsql-13.0.0.0.tar.gz?st=2016-10-18T17%3A29%3A00Z&se=2022-10-19T17%3A29%3A00Z&sp=rl&sv=2015-04-05&sr=b&sig=cDwPfrouVeIQf0vi%2BnKt%2BzX8Z8caIYvRCmicDL5oknY%3D" \
        && tar -xf msodbcsql-13.0.0.0.tar.gz \
        && cd msodbcsql-*/ \
        && ldd lib64/libmsodbcsql-13.0.so.0.0 \
        && ./install.sh install --accept-license \
        && ls -l /opt/microsoft/msodbcsql/ \
        && odbcinst -q -d -n "ODBC Driver 13 for SQL Server" && \


    #####################################
    # Install sqlsrv y pdo_sqlsrv
    # extensions:
    #####################################

    pecl install sqlsrv-4.0.8 && \
    pecl install pdo_sqlsrv-4.0.8 && \

    #####################################
    # Set locales for the container
    #####################################

    apt-get install --no-install-recommends -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen \
    && echo "extension=sqlsrv.so" > /etc/php/7.1/cli/conf.d/20-sqlsrv.ini \
    && echo "extension=pdo_sqlsrv.so" > /etc/php/7.1/cli/conf.d/20-pdo_sqlsrv.ini \
; rm msodbcsql-13.0.0.0.tar.gz rm -rf /var/lib/apt/lists/*; fi

#####################################
# Minio:
#####################################
USER root
ARG INSTALL_MC=false
ENV INSTALL_MC ${INSTALL_MC}

COPY mc/config.json /root/.mc/config.json

RUN if [ ${INSTALL_MC} = true ]; then\
    curl -fsSL -o /usr/local/bin/mc https://dl.minio.io/client/mc/release/linux-amd64/mc && \
    chmod +x /usr/local/bin/mc \
;fi

#####################################
# Image optimizers:
#####################################
USER root
ARG INSTALL_IMAGE_OPTIMIZERS=false
ENV INSTALL_IMAGE_OPTIMIZERS ${INSTALL_IMAGE_OPTIMIZERS}
RUN if [ ${INSTALL_IMAGE_OPTIMIZERS} = true ]; then \
    apt-get install --no-install-recommends -y --force-yes jpegoptim optipng pngquant gifsicle && \
    if [ ${INSTALL_NODE} = true ]; then \
        . ~/.bashrc && npm install -g svgo \
    ; npm cache clean --force; fi \
; rm -rf /var/lib/apt/lists/*; fi
#####################################
# ZeroMQ:
#####################################
ARG INSTALL_ZMQ=false
RUN if [ ${INSTALL_ZMQ} = true ]; then \
    apt-get update -yqq && \
    apt-get install --no-install-recommends -y build-essential libtool autoconf pkg-config libsodium-dev libzmq-dev && \
    pecl install -o -f zmq-beta && rm -rf /tmp/pear && \
    echo "extension=zmq.so" > /etc/php/7.1/cli/conf.d/zmq.ini \
; rm -rf /var/lib/apt/lists/*; fi
#####################################
# Symfony:
#####################################
USER root
ARG INSTALL_SYMFONY=false
ENV INSTALL_SYMFONY ${INSTALL_SYMFONY}
RUN if [ ${INSTALL_SYMFONY} = true ]; then \
  mkdir -p /usr/local/bin \
  && curl -f -LsS https://symfony.com/installer -o /usr/local/bin/symfony \
  && chmod a+x /usr/local/bin/symfony \

  #  Symfony 3 alias
  && echo 'alias sydev="php bin/console -e=dev"' >> ~/.bashrc \
  && echo 'alias syprod="php bin/console -e=prod"' >> ~/.bashrc \





; fi


#RUN source ~/.bashrc

#####################################
# PYTHON:
#####################################

ARG INSTALL_PYTHON=false
ENV INSTALL_PYTHON ${INSTALL_PYTHON}
RUN if [ ${INSTALL_PYTHON} = true ]; then \
  apt-get update \
  && apt-get -y --no-install-recommends install python python-pip python-dev build-essential \
  && pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir --upgrade virtualenv \
; rm -rf /var/lib/apt/lists/*; fi

#
#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#

# Clean up
USER root
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set default work directory
WORKDIR /var/www
