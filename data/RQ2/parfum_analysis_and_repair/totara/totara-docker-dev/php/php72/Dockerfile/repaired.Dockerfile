FROM php:7.2-fpm

ARG TIME_ZONE=Pacific/Auckland

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
        apt-transport-https \
        libgd3 \
        libgd-dev \
        libfreetype6-dev \
        libjpeg-dev \
        libmcrypt-dev \
        libpng-dev \
        libxml2-dev \
        libicu-dev \
        libpq-dev \
        gnupg2 \
        nano \
        vim \
        wget \
        openssl \
        locales \
        tzdata \
        git \
        libzip-dev \
        libmemcached-dev \
        zip \
        netcat \
        bc \
        ghostscript \
        graphviz \
        aspell \
        libldap2-dev \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install -j$(nproc) xmlrpc \
        zip \
        intl \
        soap \
        opcache \
        pdo_pgsql \
        pdo_mysql \
        pgsql \
        mysqli \
        exif \
        ldap \
    && docker-php-ext-configure gd \
            --with-freetype-dir=/usr/include/ \
            --with-png-dir=/usr/include/ \
            --with-jpeg-dir=/usr/include/ \
            --with-gd \
    && docker-php-ext-install -j$(nproc) gd \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/tideways/php-profiler-extension.git \
    && cd php-profiler-extension \
    && phpize \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make && make install

RUN echo "extension=tideways_xhprof.so" >> /usr/local/etc/php/conf.d/tideways_xhprof.ini

RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

RUN pecl install -o -f igbinary \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable igbinary

RUN pecl install -o -f memcached \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable memcached

# we need en_US locales for MSSQL connection to work
# we need en_AU locales for behat to work
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# en_AU.UTF-8 UTF-8/en_AU.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# install mssql extension
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl -f https://packages.microsoft.com/config/debian/8/prod.list | tee /etc/apt/sources.list.d/mssql-tools.list \
    && apt-get update && ACCEPT_EULA=Y apt-get --no-install-recommends install -y \
        msodbcsql17 \
        mssql-tools \
        unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

# Workaround to get MSSQL connection working on Debian 9 (stretch)
# https://emacstragic.net/2017/11/06/mssql-odbc-client-on-debian-9-stretch/
RUN wget "https://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb" \
    && DEBIAN_FRONTEND=noninteractive dpkg -i ./libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb

RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile \
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

RUN pear config-set php_ini `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"` system \
    && pecl install sqlsrv-5.8.1 \
    && pecl install pdo_sqlsrv-5.8.1

RUN docker-php-ext-enable sqlsrv.so && docker-php-ext-enable pdo_sqlsrv.so

RUN ln -fs /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata

# Python 3.7 for ML Recommender.
RUN apt-get update && apt install --no-install-recommends -y python3.7 \
    python3-pip \
    python3-wheel \
    python3-venv \
    python3-dev && rm -rf /var/lib/apt/lists/*;

COPY config/php.ini /usr/local/etc/php/
COPY config/fpm.conf /usr/local/etc/php-fpm.d/zz-totara.conf

# Source each .sh file found in the /shell/ folder
RUN echo 'for f in ~/custom_shell/*.sh; do [[ -e "$f" ]] && source "$f"; done;' >> ~/.bashrc

# Have the option of using the oh my zsh shell.
RUN apt-get update && apt-get install --no-install-recommends -y zsh && rm -rf /var/lib/apt/lists/*;
RUN sh -c "$( curl -f https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" -f --unattended
RUN git clone https://github.com/romkatv/powerlevel10k ~/.oh-my-zsh/custom/themes/powerlevel10k
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
RUN echo 'setopt +o nomatch' > ~/.zshrc
RUN echo 'source ~/custom_shell/.zshrc' >> ~/.zshrc
RUN cat ~/.bashrc >> ~/.zshrc
